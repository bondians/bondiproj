#import "MyController.h"

#import <QuickLite/QuickLiteRow.h>
#import <QuickLite/QuickLiteDatabaseExtras.h>

@implementation MyController

- (void)awakeFromNib
{
    NSString* filePath = [NSString stringWithFormat: @"%@/%@", NSTemporaryDirectory(), @"BLOBTester_temp_data"];
    
    db = [[QuickLiteDatabase databaseWithFile: [filePath stringByExpandingTildeInPath]] retain];
    
    if (![db open]) {
        [chooseButton setEnabled: FALSE];
        NSLog(@"Trouble when creating the data file.");
    } else {
        // Make sure we start with a clean database
        NSArray* tables = [db tables];
        int i, tableCount = [tables count];
        
        for (i = 0; i < tableCount; i++)
            [db dropTable: [tables objectAtIndex: i]];
        
        [db createTable: @"images" withColumns: [NSArray arrayWithObjects: QLRecordUID, @"myPicture", nil] andDatatypes: [NSArray arrayWithObjects: QLRecordUIDDatatype, QLContainer, nil]];
    }
    
    [showButton setEnabled: FALSE];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [db closeSavingChanges:NO];
}

- (IBAction)chooseFileAction:(id)sender
{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    // Configure the panel
    [openPanel setCanChooseFiles: YES];
    [openPanel setCanChooseDirectories: NO];
    [openPanel setResolvesAliases: YES];
    [openPanel setAllowsMultipleSelection: NO];
    
    // Display the open sheet
    [openPanel beginSheetForDirectory: nil
                                 file: nil
                                types: nil
                       modalForWindow: [chooseButton window]
                        modalDelegate: self
                       didEndSelector: @selector(openPanelDidEnd: returnCode: contextInfo:)
                          contextInfo: nil];
}

- (void)openPanelDidEnd:(NSOpenPanel*)panel returnCode:(int)rc contextInfo:(void *) ctx
{
    if (rc == NSOKButton) {
        NSString * filePath = [panel filename];
        
        [[chooseButton window] setTitle: [filePath lastPathComponent]];
	
	NSData* data = [NSData dataWithContentsOfFile: filePath];
	if (data) {
            // Delete the old picture
            [db deleteAllRowsInTable:@"images"];
            
            QuickLiteCursor *cursor = [db performQuery: @"SELECT * FROM images;"];
            
            // Let's use QuickEdit: add the new one to the cursor
            if (![cursor insertRowWithValues:[NSArray arrayWithObjects:[NSNull null], data, nil] forColumns:[NSArray arrayWithObjects:[NSString stringWithFormat: @"images.%@", QLRecordUID], @"images.myPicture", nil]]) {
                NSAlert *alert = [[[NSAlert alloc] init] autorelease];
                [alert addButtonWithTitle:@"OK"];
                [alert setMessageText:@"An error has occurred"];
                [alert setInformativeText:[db lastError]];
                [alert setAlertStyle:NSInformationalAlertStyle];
                [alert beginSheetModalForWindow:[chooseButton window] modalDelegate:self didEndSelector:nil contextInfo:nil];
                
                [self setImage: nil inView: originalImage];
            } else {
                NSData* sanityImage = nil;

                // Save the cursor to the database
                if (![cursor save]) {
                    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
                    [alert addButtonWithTitle:@"OK"];
                    [alert setMessageText:@"An error has occurred"];
                    [alert setInformativeText:@"The cursor could not be saved."];
                    [alert setAlertStyle:NSInformationalAlertStyle];
                    [alert beginSheetModalForWindow:[chooseButton window] modalDelegate:self didEndSelector:nil contextInfo:nil];
                } else {
                    // Sanity check: don't take for granted that the BLOB is in good condition.
                    // Retrieve it again via a new cursor
                    QuickLiteCursor *sanityCursor = [db performQuery: @"SELECT * FROM images;"];
                    sanityImage = [[sanityCursor rowAtIndex: 0] valueForColumn: @"images.myPicture"];
                    if (!sanityImage) {
                        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
                        [alert addButtonWithTitle:@"OK"];
                        [alert setMessageText:@"An error has occurred"];
                        [alert setInformativeText:@"The image could not be retrieved!"];
                        [alert setAlertStyle:NSInformationalAlertStyle];
                        [alert beginSheetModalForWindow:[chooseButton window] modalDelegate:self didEndSelector:nil contextInfo:nil];
                    }
                }

                NSImage* image = [[NSImage alloc] initWithData: sanityImage];
                [self setImage: image inView: originalImage];
                [image release];
		
                [showButton setEnabled: TRUE];
            }
	} else {
            NSLog(@"I cannot read the selected file.");
	}
	
	[self setImage: nil inView: decodedImage];
    }
} 

- (IBAction)showImageAction:(id)sender
{
    QuickLiteCursor* cursor = [db performQuery: @"SELECT * FROM images;"];
    NSData* data = [[cursor rowAtIndex: 0] valueForColumn: @"images.myPicture"];
    if (data) {
        NSImage* image = [[NSImage alloc] initWithData: data];
        [self setImage: image inView: decodedImage];
        [image release];
    } else {
        NSLog(@"I cannot read the data from the database.");
    }
    
    [showButton setEnabled: FALSE];
}

- (void)setImage:(NSImage*)image inView:(NSImageView*)imageView
{
    [imageView setImage: image];
}

@end

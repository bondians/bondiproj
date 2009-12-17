#import "MyController.h"

#import <QuickLite/QuickLiteGlobals.h>

@implementation MyController

- (void)awakeFromNib
{
    [tableView sizeLastColumnToFit];
    
    log = [[NSMutableArray alloc]init];
    
    // Start listening to distributed _QLPrivateNotificationSchemaHasChanged and _QLPrivateNotificationContentsHaveChanged messages
    NSDistributedNotificationCenter* center = [NSDistributedNotificationCenter defaultCenter];
    
    // Disclaimer: this is *not* advised. These private notifications are targeted to QuickLite, which will then update
    // its internal state. Once everything is correct, it sends a local notification so that the app can react properly.
    // If you trap these private notifications and act before QuickLite does, there is a chance you'll screw things up.
    // I do that because I'm only a listener, and I don't need to change anything. In other words, I'm a heck of a citizen :-)
    
    [center addObserver:self selector:@selector(sqlQueryHasBeenSent:) name:QLDatabaseHasSentSQLStatementNotification object:nil];
    
    [[NSApplication sharedApplication]setDelegate:self];
    
    [self refreshUI];
    
    [window makeKeyAndOrderFront: nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [log release];
}

- (void)setPath:(NSString*)dbPath
{
    if (dbPath != path) {
        [path release];
        path = [dbPath copy];
    }
}

- (NSString*)path
{
    return path;
}

- (IBAction)openDatabase:(id)sender
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
                       modalForWindow: window
                        modalDelegate: self
                       didEndSelector: @selector(openPanelDidEnd: returnCode: contextInfo:)
                          contextInfo: nil];
}

- (void)openPanelDidEnd:(NSOpenPanel*)panel returnCode:(int)rc contextInfo:(void *) ctx
{
    if (rc == NSOKButton) {
        [self setPath: [panel filename]];	
    }
    
    [self refreshUI];
}  

- (IBAction)closeDatabase:(id)sender
{
    [self setPath:nil];
    [self refreshUI];
}

- (void)refreshUI
{
    if ([self path]) {
        [statusText setStringValue:[NSString stringWithFormat:@"Database selected. Listening to: %@", [self path]]];
    } else {
        [statusText setStringValue:@"Database not selected. Listening system-wide."];
    }
    
    [closeButton setEnabled:([self path] != nil)];
    [openButton setEnabled:([self path] == nil)];
    [clearButton setEnabled:([log count] > 0)];
}

- (IBAction)clearLog:(id)sender
{
    [log removeAllObjects];
    [tableView reloadData];
    [self refreshUI];
}

- (void)sqlQueryHasBeenSent:(NSNotification*)notification
{
    NSString* databasePath = [[notification userInfo] objectForKey:QLDatabasePathIdentifier];
    
    if ([self path] != nil) {
        // Check whether the notification has to do with our own database
        if (![databasePath isEqualToString:[self path]])
            return;
    }
    
    //[self addEntryToLog:[[notification userInfo]objectForKey:QLSQLStatementIdentifier]];
    [self addEntryToLog:[notification userInfo]];
}

- (void)addEntryToLog:(NSDictionary*)info
{
    if (!info)
        return;
    
    [log addObject: info];
    [tableView reloadData];
    [tableView sizeLastColumnToFit];
    [tableView scrollRowToVisible:[log count] - 1];
    [clearButton setEnabled:YES];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    NSString* identifier = [aTableColumn identifier];
    id value = [[log objectAtIndex: rowIndex]objectForKey:identifier];
    
    if ([identifier isEqualToString:QLTimestampIdentifier]) {
        NSCalendarDate *date = [NSCalendarDate dateWithString:[value description]];
        NSString* timestamp = [date descriptionWithCalendarFormat:@"%Y-%m-%d %H:%M:%S.%F"];
        return timestamp;
    }
    
    return value;
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [log count];
}

@end

//
//  MyDocument.m
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sat Aug 16 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import "MyDocument.h"
#import "Globals.h"

static NSString* kSMXDatabaseNotSelected = @"< Database not selected >";

@implementation MyDocument

- (void)awakeFromNib
{
    mDatabase = nil;
    
    // Setup UI
    [mCloseButton setEnabled: NO];
    [mRefreshButton setEnabled: NO];
    [mDeleteButton setEnabled: NO];
    
    [mSQLQueryField setEditable: NO];
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver: self selector:@selector(performQuery:) name: kSMXSQLQueryHasChanged object: nil];
    [center addObserver: self selector:@selector(schemaHasChanged:) name: QLDatabaseHasChangedNotification object: nil];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    if (mDatabase != nil)
        [self closeSQLiteDatabase: nil];
    
    [super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    return YES;
}

- (void)windowWillClose:(NSNotification *)aNotification
{
    [self closeSQLiteDatabase: nil];
}

- (IBAction)openDocument:(id)sender
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
                       modalForWindow: [mOpenButton window]
                        modalDelegate: self
                       didEndSelector: @selector(openPanelDidEnd: returnCode: contextInfo:)
                          contextInfo: nil];
}

- (void)openPanelDidEnd:(NSOpenPanel*)panel returnCode:(int)rc contextInfo:(void *) ctx
{
    if (rc == NSOKButton) {
        NSString * path = [panel filename];
        BOOL trouble = NO;
        
        [[mOpenButton window] setTitle: [path stringByAbbreviatingWithTildeInPath]];
        [mOpenButton setEnabled: NO];
        [mCloseButton setEnabled: YES];
        [mRefreshButton setEnabled: YES];
        [mDeleteButton setEnabled: YES];
	
        [mSQLQueryField setEditable: YES];
	
        // Open the database
        mDatabase = [[QuickLiteDatabase databaseWithFile: path] retain];
        if (![mDatabase open: NO cacheMethod:CacheDataOnDemand]) {
            trouble = YES;
        }
        
        if (trouble) {
            [self freeQuickLiteDatabase];
        } else {
            [self setDebugMode:nil];
            [self setSendsSQLStatements:nil];
            
            [mTablesDelegate setDatabase: mDatabase];
            [mColumnsDelegate setDatabase: mDatabase];
            [mResultsDelegate setDatabase: mDatabase];
            [mImportDataDelegate setDatabase: mDatabase];
            [self extractSQLiteDatabase];
        }
    }
}  

- (IBAction)createNewDatabase:(id)sender
{
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    
    // Configure the panel
    
    // Display the open sheet
    [savePanel beginSheetForDirectory: nil
                                 file: nil
                       modalForWindow: [mOpenButton window]
                        modalDelegate: self
                       didEndSelector: @selector(createDatabasePanelDidEnd: returnCode: contextInfo:)
                          contextInfo: nil];
}

- (void)createDatabasePanelDidEnd:(NSSavePanel*)panel returnCode:(int)rc contextInfo:(void*)ctx
{
    if (rc == NSOKButton) {
        [mDatabase closeSavingChanges:YES];
        
        NSString * path = [panel filename];
        BOOL trouble = NO;
        
        [[mOpenButton window] setTitle: [path stringByAbbreviatingWithTildeInPath]];
        [mOpenButton setEnabled: NO];
        [mCloseButton setEnabled: YES];
        [mRefreshButton setEnabled: YES];
        [mDeleteButton setEnabled: YES];
        
        [mSQLQueryField setEditable: YES];
        
        // Open the database
        mDatabase = [[QuickLiteDatabase databaseWithFile: path] retain];
        if (![mDatabase open: NO cacheMethod:DoNotCacheData]) {
            trouble = YES;
        }
        
        if (trouble) {
            [self freeQuickLiteDatabase];
        } else {
            [mDatabase setSendsSQLStatementWhenNotifyingOfChanges:YES];
            
            [mTablesDelegate setDatabase: mDatabase];
            [mColumnsDelegate setDatabase: mDatabase];
            [mResultsDelegate setDatabase: mDatabase];
            [mImportDataDelegate setDatabase: mDatabase];
            [self extractSQLiteDatabase];
        }
    }
}

- (IBAction)closeSQLiteDatabase:(id)sender
{
    [mDatabase closeSavingChanges:YES];
    [self freeQuickLiteDatabase];
    
    [mTablesDelegate setDatabase: nil];
    [mColumnsDelegate setDatabase: nil];
    [mResultsDelegate setDatabase: nil];
    
    [mTablesDelegate displayDatabaseTables];
}

- (IBAction)executeSQLQuery:(id)sender
{
    if ((mDatabase != nil) && (![[mSQLQueryField stringValue] isEqualToString: @""])) {
        NSArray* objectArray = [NSArray arrayWithObjects: [mSQLQueryField stringValue], [self windowForSheet], nil];
        [[NSNotificationCenter defaultCenter] postNotificationName: kSMXPerformSQLQuery object: objectArray];
    }
}

- (IBAction)openImportSheet:(id)sender
{
    [NSApp beginSheet:  mImportPanel
       modalForWindow:  [mOpenButton window]
        modalDelegate:   nil
       didEndSelector:  nil
          contextInfo:     nil];
	   
    int result = [NSApp runModalForWindow: mImportPanel];
    
    [NSApp endSheet: mImportPanel];
    [mImportPanel orderOut: self];
    
    if (result == NSOKButton)
        [self extractSQLiteDatabase];
}

- (IBAction)refreshUI:(id)sender
{
    [self extractSQLiteDatabase];
}

- (IBAction)dropTable:(id)sender
{
    [mTablesDelegate dropSelectedTable];
    [self extractSQLiteDatabase];
}

- (IBAction)setDebugMode:(id)sender
{
    [mDatabase setIsInDebugMode:([mDebugButton intValue] == 1)];
}

- (IBAction)setSendsSQLStatements:(id)sender
{
    [mDatabase setSendsSQLStatementWhenNotifyingOfChanges:([mSendSQLStatementButton intValue] == 1)];
}

- (void)extractSQLiteDatabase
{
    [mTablesDelegate displayDatabaseTables];
}

- (void)freeQuickLiteDatabase
{
    [mDatabase release];
    mDatabase = nil;
    
    [mOpenButton setEnabled: YES];
    [mCloseButton setEnabled: NO];
    [mRefreshButton setEnabled: NO];
    [mDeleteButton setEnabled: NO];
    
    [mSQLQueryField setEditable: NO];
    [mSQLQueryField setStringValue: @""];
    
    [[mOpenButton window] setTitle: kSMXDatabaseNotSelected];
}

- (QuickLiteDatabase*)database
{
    return mDatabase;
}

- (void)performQuery:(NSNotification*)notification
{
    [mSQLQueryField setStringValue: [notification object]];
}

- (void)schemaHasChanged:(NSNotification*)notification
{
    NSLog(@"schemaHasChanged notification: %@", [mDatabase databasePath]);
}

@end

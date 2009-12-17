/*
 *  Controller.m
 *  SuperTableView
 *
 *  Created by tciuro on Tue Jan 20 2003.
 *  Copyright (c) 2003 Tito Ciuro. All rights reserved.
 *
 */

#import "Controller.h"
#import <QuickLite/QuickLiteCursor.h>
#import <QuickLite/QuickLiteDatabaseExtras.h>

#import <ctype.h>

NSString* const sDataFileName		= @"SuperTableView.data";

NSString* const sTableName              = @"people";
NSString* const sTableNameBackup	= @"people_backup";
NSString* const sTableFirstName		= @"first";
NSString* const sTableLastName		= @"last";

@implementation Controller

- (void)awakeFromNib
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Initialization
    mDataPath = [[NSString stringWithFormat: @"%@/%@", [fm currentDirectoryPath], sDataFileName] retain];
    mSQLCursor = nil;
    
    srand (time (NULL));
    
    [[NSApplication sharedApplication] setDelegate: self];
    
    [fm removeFileAtPath: mDataPath handler: nil];
    
    // Just open the database
    [self openDatabase];
    
    [mDrawer toggle: nil];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    [mDataPath release];
    [mSQLCursor release];
    
    [mDatabase closeSavingChanges:NO];
    [mDatabase release];
    
    return NSTerminateNow;
}

#pragma mark// ==================================
#pragma mark// Action Methods
#pragma mark// ==================================

- (IBAction)clearAndCreate:(id)sender
{
    double records = [[mRecordsField stringValue] doubleValue];
    NSDate* timingCreateStarted = nil;
    double generationSeconds = 0.0;
    double indexingSeconds = 0.0;
    double createMirrorSeconds = 0.0;
    double commitSeconds = 0.0;
    double compactSeconds = 0.0;
    int popupSelection = [mIndexOptions indexOfSelectedItem];
    
    // Generate the random string before timing
    NSMutableArray* randomStrings = [[NSMutableArray alloc]initWithCapacity:records * 2];
    unsigned long i;
    
    [self restartUI];
    [self setProcessInfo: @"Generating random strings... "];
    
    for (i = 0; i < records; i++) {
        if (i % 5000 == 0) {
            [mProgressBar incrementBy: 5000];
            [mProgressBar displayIfNeeded];
        }
        
        int length = ([self generateRandomNumber] % 25) + 1;
        [randomStrings addObject:[self generateDummyString: length]];
        length = ([self generateRandomNumber] % 25) + 1;
        [randomStrings addObject:[self generateDummyString: length]];
    }
    
    [self restartUI];
    
    [mDatabase beginTransaction];
    
    // Clear the database
    [mDatabase dropTable:sTableName];
    [mDatabase dropTable:sTableNameBackup];
    
    timingCreateStarted = [NSDate date];
    
    // Make sure we start with an empty database. Create the table and indices as needed.
    NSArray* creationColumns = [NSArray arrayWithObjects:QLRecordUID, sTableFirstName, sTableLastName, nil];
    NSArray* creationDatatypes = [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, nil];
    [mDatabase createTable:sTableName withColumns:creationColumns andDatatypes:creationDatatypes];
    
    // Reset the UI
    
    if (popupSelection == SPTV_IndexBefore) {
        NSDate* timingIndexingStarted = [NSDate date];
        [self setProcessInfo: @"Indexing data... "];
        
        [mDatabase createIndexForColumn:sTableFirstName inTable:sTableName isUnique:NO];
        [mDatabase createIndexForColumn:sTableLastName inTable:sTableName isUnique:NO];
        indexingSeconds = [[NSDate date] timeIntervalSinceDate: timingIndexingStarted];
    }
    
    // Initialize the UI
    [mTableLineCount setStringValue: @""];
    [mTableLineCount displayIfNeeded];
    
    [mGenerateStatusField setStringValue: @"Work in progress... "];
    [mGenerateStatusField displayIfNeeded];
    [mSelectStatusField setStringValue: @"Work in progress... "];
    [mSelectStatusField displayIfNeeded];
    [self setProcessInfo: [NSString stringWithFormat: @"Creating %ld records... ", (unsigned long)records]];
    
    if (records > 0) {
        [self generateDummyRecords: randomStrings];
        
        generationSeconds = [[NSDate date] timeIntervalSinceDate: timingCreateStarted];
        
        if (popupSelection == SPTV_IndexAfter) {
            timingCreateStarted = [NSDate date];
            [self setProcessInfo: @"Indexing data... "];
            
            [mDatabase createIndexForColumn:sTableFirstName inTable:sTableName isUnique:NO];
            [mDatabase createIndexForColumn:sTableLastName inTable:sTableName isUnique:NO];
            
            indexingSeconds = [[NSDate date] timeIntervalSinceDate: timingCreateStarted];
        }
    }
    
    if ([mGenerateMirrorButton intValue] == 1) {
        NSDate* timingOperationStarted = [NSDate date];
        [self setProcessInfo: @"Creating mirror table... "];
        
        // Make sure we start with an empty database. Create the table and indices as needed.
        NSArray* creationColumns = [NSArray arrayWithObjects:QLRecordUID, sTableFirstName, sTableLastName, nil];
        NSArray* creationDatatypes = [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, nil];
        [mDatabase createTable:sTableNameBackup withColumns:creationColumns andDatatypes:creationDatatypes];
        
        if (popupSelection == SPTV_IndexBefore) {
            [mDatabase createIndexForColumn:sTableFirstName inTable:sTableNameBackup isUnique:NO];
            [mDatabase createIndexForColumn:sTableLastName inTable:sTableNameBackup isUnique:NO];
        }
        
        [mDatabase copyTable:sTableName toTable:sTableNameBackup];
        
        if (popupSelection == SPTV_IndexAfter) {
            [mDatabase createIndexForColumn:sTableFirstName inTable:sTableNameBackup isUnique:NO];
            [mDatabase createIndexForColumn:sTableLastName inTable:sTableNameBackup isUnique:NO];
        }
        
        createMirrorSeconds = [[NSDate date] timeIntervalSinceDate: timingOperationStarted];
    }
    
    NSMutableString* string = [NSMutableString string];
    
    if (records > 0) {        
        if (popupSelection == SPTV_NoIndex)
            [string appendString: [NSString stringWithFormat: @"Inserting %ld records without indexing took: %.2f sec. (%.2f rec/sec). ", (unsigned long)records, generationSeconds, (records / generationSeconds)]];
        else if (popupSelection == SPTV_IndexBefore)
            [string appendString: [NSString stringWithFormat: @"Inserting %ld records while indexing took: %.2f sec. (%.2f rec/sec). ", (unsigned long)records, generationSeconds, (records / generationSeconds)]];
        else {
            [string appendString: [NSString stringWithFormat: @"Inserting %ld records took: %.2f sec. (%.2f rec/sec). ", (unsigned long)records, generationSeconds, (records / generationSeconds)]];
            [string appendString: [NSString stringWithFormat: @"Post-indexing %ld records took: %.2f sec. (%.2f rec/sec). ", (unsigned long)records, indexingSeconds, (records / indexingSeconds)]];
        }
        
        if ([mGenerateMirrorButton intValue] == 1) {
            if (popupSelection == SPTV_NoIndex)
                [string appendString: [NSString stringWithFormat: @"Generating a mirror table without indexing took: %.2f sec. ", createMirrorSeconds]];
            else if (popupSelection == SPTV_IndexBefore)
                [string appendString: [NSString stringWithFormat: @"Generating a mirror table while indexing took: %.2f sec. ", createMirrorSeconds]];
            else
                [string appendString: [NSString stringWithFormat: @"Generating a mirror table took with post-indexing: %.2f sec. ", createMirrorSeconds]];                
        }
        
        [mDatabase commitTransaction];
        commitSeconds = [[NSDate date] timeIntervalSinceDate: timingCreateStarted];
        [string appendString: [NSString stringWithFormat: @"Committing the data took: %.2f sec. ", commitSeconds]];
        
        [mDatabase compact];
        compactSeconds = [[NSDate date] timeIntervalSinceDate: timingCreateStarted];
        [string appendString: [NSString stringWithFormat: @"Compacting the datafile took: %.2f sec. ", compactSeconds]];
        
        NSDictionary *attrs = [[NSFileManager defaultManager] fileAttributesAtPath: mDataPath traverseLink: NO];
        [string appendString: [NSString stringWithFormat: @"File size: %ldKB. ", [[attrs objectForKey: @"NSFileSize"] longValue] / 1024]];
        
        [self selectRecords: nil];
    } else {
        [mSelectStatusField setStringValue: @""];
        [mDatabase rollbackTransaction];
    }
    
    [mGenerateStatusField setStringValue: string];
    NSLog(@"%@", string);
    
    NSLog(@"%@", [mSelectStatusField stringValue]);
    
    [self setProcessInfo: @"Ready. "];
    
    // Cleanup
    [randomStrings release];
}

- (IBAction)selectRecords:(id)sender
{
    NSString* value = [mSelectValueField stringValue];
    SPTV_SearchType matchType = [mSelectMatchType selectedRow];
    unsigned long rowCount = 0;
    unsigned long totalRecords = (unsigned long)[[mRecordsField stringValue] doubleValue];
    NSDate* timingStarted= [NSDate date];
    double seconds = 0.0;
    NSString* sqlQuery;
    
    switch ([mSelectOptions selectedRow]) {
        case 0:
            [mSelectStatusField setStringValue: @"No records selected."];
            break;
        case 1:
            [self setProcessInfo: @"Selecting all records... "];
            sqlQuery = [self selectRecordsWithMatchType: matchType andValue: @""];
            break;
        default:
            sqlQuery = [self selectRecordsWithMatchType: matchType andValue: value];
            switch(matchType) {
                case SPTV_Contains:
                    [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Selecting records containing '%@'... ", value]];
                    break;
                case SPTV_StartsWith:
                    [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Selecting records starting with '%@'... ", value]];
                    break;
                case SPTV_ExactMatch:
                    [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Selecting records equal to '%@'... ", value]];
                    break;
                case SPTV_Join:
                    [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Selecting records joining '%@'... ", value]];
                    break;
            }
                break;
    }
    
    [mSQLCursor release];
    mSQLCursor = nil;
    
    switch ([mSelectOptions selectedRow]) {
        case 0:
            // No need to do anything...
            break;
        case 1:
            mSQLCursor = [[mDatabase performQuery: sqlQuery]retain];
            seconds = [[NSDate date] timeIntervalSinceDate: timingStarted];
            rowCount = [mSQLCursor rowCount];
            [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Selecting all records took: %.2f sec. ", seconds]];
            break;
        default:
            mSQLCursor = [[mDatabase performQuery: sqlQuery]retain];
            seconds = [[NSDate date] timeIntervalSinceDate: timingStarted];
            rowCount = [mSQLCursor rowCount];
            switch(matchType) {
                case SPTV_Contains:
                    [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Selecting %ld records containing '%@' out of %ld took: %.2f sec. ", rowCount, value, totalRecords, seconds]];
                    break;
                case SPTV_StartsWith:
                    [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Selecting %ld records starting with '%@' out of %ld took: %.2f sec. ", rowCount, value, totalRecords, seconds]];
                    break;
                case SPTV_ExactMatch:
                    [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Selecting %ld records equal to '%@' out of %ld took: %.2f sec. ", rowCount, value, totalRecords, seconds]];
                    break;
                case SPTV_Join:
                    [mSelectStatusField setStringValue: [NSString stringWithFormat: @"Joining %ld records via 'Last' with '%@' out of %ld took: %.2f sec. ", rowCount, value, totalRecords, seconds]];
                    break;
            }
                break;
    }
    
    [mTableView reloadData];
    
    if (rowCount == 1)
        [mTableLineCount setStringValue: [NSString stringWithFormat: @"%ld record selected", rowCount]];
    else
        [mTableLineCount setStringValue: [NSString stringWithFormat: @"%ld records selected", rowCount]];
    
    [self setProcessInfo: @"Done"];
}

- (IBAction)setCacheMethod:(id)sender
{
    QLCacheMethod cacheMethod = [sender intValue];
    [mDatabase setCacheMethod:cacheMethod];
}

- (IBAction)setDebugMode:(id)sender
{
    [mDatabase setIsInDebugMode:([mDebugButton intValue] == 1)];
}

- (IBAction)setSendsSQLStatements:(id)sender
{
    [mDatabase setSendsSQLStatementWhenNotifyingOfChanges:([mSendSQLStatementButton intValue] == 1)];
}

#pragma mark// ==================================
#pragma mark// TableView Methods
#pragma mark// ==================================

// This object is the data source of its NSTableView. servicesList is the NSArray containing all those mMakutoSharingServices that have been discovered.
- (int)numberOfRowsInTableView:(NSTableView *)theTableView
{
    return [mSQLCursor rowCount];
}

- (id)tableView:(NSTableView *)theTableView objectValueForTableColumn:(NSTableColumn *)theColumn row:(int)rowIndex
{
    NSString* columnName = [theColumn identifier];
    NSString* value;
    QuickLiteRow* row = [mSQLCursor rowAtIndex: rowIndex];
    
    value = [row stringForColumn: columnName];
    if (value == nil)
        value = @"";
    
    return value;
}

#pragma mark// ==================================
#pragma mark// Miscellaneous Methods
#pragma mark// ==================================

- (void)openDatabase
{
    if (mDatabase != nil) {
        [mDatabase release];
        mDatabase = nil;
    }
    
    // Create and open the database
    mDatabase = [[QuickLiteDatabase alloc] initWithFile: sDataFileName];
    if ((!mDatabase) || (![mDatabase open:YES cacheMethod:CacheDataOnDemand])) {
        NSBeginAlertSheet(@"The database cannot be created. ",			// sheet message
                          @"OK",              				// default button label
                          nil,              				// alternate button label
                          nil,                    				// other button
                          mWindow,						// window sheet is attached to
                          self,                   				// we'll be our own delegate
                          nil,						// did-end selector
                          NULL,                   				// no need for did-dismiss selector
                          nil,                 				// context info
                          [NSString stringWithFormat: @"An unexpected error occurred when attempting to create the database '%@'. ", sDataFileName], //additional text
                          nil);						// optionalParameters. The printf-style parameters used to format message.
        if (mDatabase != nil) {
            [mDatabase release];
            mDatabase = nil;
        }
        [[NSApplication sharedApplication] terminate: nil];
    } else {
        [self setDebugMode:nil];
        [self setSendsSQLStatements:nil];
    }
}

- (void)generateDummyRecords:(NSArray*)randomStrings
{
    unsigned long i, numRecords = [randomStrings count];
    
    for(i = 0; i < numRecords; i += 2) {
        if (i % 5000 == 0) {
            [mProgressBar incrementBy: 5000];
            [mProgressBar displayIfNeeded];
        }
        
        NSString* first = [randomStrings objectAtIndex:i];
        NSString* last = [randomStrings objectAtIndex:i + 1];
        
        [mDatabase insertValues: [NSArray arrayWithObjects: [NSNull null], first, last, nil] forColumns: [NSArray arrayWithObjects: QLRecordUID, sTableFirstName, sTableLastName, nil] inTable: sTableName];
    }
}

- (NSString*)generateDummyString:(unsigned int)length
{
    char string[length];
    
    {
        unsigned long i, c, t = 0;
        
        for(i = 0; i < length; i++) {
            do {
                c = ([self generateRandomNumber] % (122 - 65 + 1)) + 65;
            } while (isalpha(c) == 0);
            string[t++] = c;
        }
    }
    
    string[length]='\0';
    
    return [NSString stringWithUTF8String: string];
}

- (unsigned long)generateRandomNumber
{
    return rand();
}

- (NSString*)selectRecordsWithMatchType:(SPTV_SearchType)matchType andValue:(NSString*)value
{
    NSString* sqlQuery = nil;
    
    if ([value isEqualToString: @""]) {
        sqlQuery = [NSString stringWithFormat: @"SELECT * FROM %@;", sTableName];
    } else {
        switch(matchType) {
            case SPTV_Contains:
                sqlQuery = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@ LIKE '%c%@%c' OR %@ LIKE '%c%@%c';", sTableName, sTableFirstName, '%', value, '%', sTableLastName, '%', value, '%'];
                break;
            case SPTV_StartsWith:
                sqlQuery = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@ LIKE '%@%c' OR %@ LIKE '%@%c';", sTableName, sTableFirstName, value, '%', sTableLastName, value, '%'];
                break;
            case SPTV_ExactMatch:
                sqlQuery = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@ = '%@' OR %@ = '%@';", sTableName, sTableFirstName, value, sTableLastName, value];
                break;
            case SPTV_Join:
                sqlQuery = [NSString stringWithFormat: @"SELECT DISTINCT %@, %@, %@ FROM %@ INNER JOIN %@ ON %@.%@ = %@_backup.%@ WHERE %@.%@ = '%@';",
                    [NSString stringWithFormat: @"%@.%@", sTableName, QLRecordUID],
                    [NSString stringWithFormat: @"%@.%@", sTableName, sTableFirstName],
                    [NSString stringWithFormat: @"%@.%@", sTableName, sTableLastName],
                    sTableName,
                    [NSString stringWithFormat: @"%@_backup", sTableName],
                    sTableName,
                    sTableLastName,
                    sTableName,
                    sTableLastName,
                    sTableName,
                    sTableLastName,
                    value];
                break;
        }
    }
    
    return sqlQuery;
}

- (void)restartUI
{
    unsigned long records = [[mRecordsField stringValue] doubleValue];
    
    // Set the progress bar
    [mProgressBar setMaxValue: records];
    [mProgressBar setDoubleValue: 0.0];
    [mProgressBar display];
    
    // Set the process info
    [self setProcessInfo: @"Ready. "];
}

- (void)setProcessInfo:(NSString*)message
{
    // Set the process info
    [mProcessInfo setStringValue: message];
    [mProcessInfo displayIfNeeded];
}

@end

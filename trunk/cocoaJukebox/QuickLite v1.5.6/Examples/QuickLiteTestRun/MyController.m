#import "MyController.h"

#import <Foundation/Foundation.h>

#import <QuickLite/QuickLiteGlobals.h>
#import <QuickLite/QuickLiteCursor.h>
#import <QuickLite/QuickLiteDatabaseExtras.h>
#import <QuickLite/sqliteInt.h>

#import <stdio.h>

NSString* const sMyAddressTable         = @"address";

NSString* const sMyTestFirstName	= @"First";
NSString* const sMyTestLastName		= @"Last";
NSString* const sMyTestZIP		= @"ZIP";
NSString* const sMyTestCountry		= @"Country";

NSString* const sMyTestDatabasePath	= @"~/MyTest.database";
NSString* const sMyImportFileDatafile   = @"~/Doctors.txt";

@implementation MyController

- (void)awakeFromNib
{
    _db = nil;
}

-(IBAction)runTests:(id)sender
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSString* path = [sMyTestDatabasePath stringByExpandingTildeInPath];
    QuickLiteCursor* cursor = nil;
    
    _db = [QuickLiteDatabase databaseWithFile:path];
    
    if ([_db open]) {//:YES cacheMethod:DoNotCacheData exposeSQLOnNotify:NO debugMode:NO]) {
        NSLog(@"The database is now open:%@", path);
    } else {
        NSLog(@"Trouble when opening the data file. Make sure the path is valid.");
        return;
    }
    
    NSLog(@"SQLite version: %@", [_db sqliteVersion]);
    NSLog(@"Database encoding: %@", [_db databaseEncoding]);
    
    [_db beginTransaction];
    
    // Make sure we start with a clean database
    NSArray* tables = [_db tables];
    int i, tableCount = [tables count];
    NSLog(@"Clearing the following tables found in the database:%@", tables);
    
    for (i = 0; i < tableCount; i++) {
        NSString* table = [tables objectAtIndex:i];
        if (![_db dropTable:table]) {
            NSLog(@"Couldn't drop the table '%@':%@", table, [_db lastError]);
            return;
        }
    }
    
//    NSLog(@"Importing file:%@...", sMyImportFileDatafile);
//    QLImportResult importResult = [_db importFromFile:@"~/Doctors.txt" encoding:NSMacOSRomanStringEncoding columnDelimiter:@"\t" endOfRecord:@"\r" table:@"doctors" dropTableIfItExistsAndRecreate:YES clearTableContentsBeforeImporting:YES];
//    if (importResult != QLImportOK) {
//        NSLog(@"Importing file '%@' failed (ID %d)", sMyImportFileDatafile, importResult);
//    } else {
//        NSLog(@"File '%@' imported successfully", sMyImportFileDatafile);
//        // Create and execute the query
//        cursor = [_db performQuery:@"SELECT * FROM doctors;"];
//        NSLog(@"Executing query:%@", [cursor sqlQuery]);
//        // Get the cursor row count
//        NSLog(@"Number of records imported:%ld", [cursor rowCount]);
//    }
    
    // Create table 'test'
    NSLog(@"Creating table 'test'...");
    NSArray* creationColumns = [NSArray arrayWithObjects:QLRecordUID, @"testString", @"testNumber", @"testBoolean", @"testDateTime", @"testContainer", nil];
    NSArray* creationDatatypes = [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLNumber, QLBoolean, QLDateTime, QLContainer, nil];
    if (![_db createTable:@"test" withColumns:creationColumns andDatatypes:creationDatatypes]) {
        NSLog(@"Error when creating 'test' table:%@", [_db lastError]);
        return;
    } else {
        NSArray* tables = [_db tables];
        if (![tables containsObject:@"test"]) {
            NSLog(@"Table 'test' not found!");
            return;
        }
    }
    
    // Create table 'address'
    NSLog(@"Creating table 'address'...");
    creationColumns = [NSArray arrayWithObjects:QLRecordUID, sMyTestFirstName, sMyTestLastName, sMyTestZIP, sMyTestCountry, nil];
    creationDatatypes = [NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, QLString, QLString, nil];
    if (![_db createTable:sMyAddressTable withColumns:creationColumns andDatatypes:creationDatatypes]) {
        NSLog(@"Error when creating 'address' table:%@", [_db lastError]);
        return;
    } else {
        NSArray* tables = [_db tables];
        if (![tables containsObject:sMyAddressTable]) {
            NSLog(@"Table 'address' not found!");
            return;
        }
    }
    
    NSLog(@"Column names for table 'address':%@", [_db columnsForTable:sMyAddressTable]);
    
    // Create table 't1'
    NSLog(@"Creating table 't1'...");
    creationColumns = [NSArray arrayWithObjects:@"x", @"y", @"z", nil];
    creationDatatypes = [NSArray arrayWithObjects:QLRecordUIDDatatype, QLNumber, QLNumber, nil];
    if (![_db createTable:@"t1" withColumns:creationColumns andDatatypes:creationDatatypes]) {
        NSLog(@"Error when creating 't1' table:%@", [_db lastError]);
        return;
    } else {
        NSArray* tables = [_db tables];
        if (![tables containsObject:@"t1"]) {
            NSLog(@"Table 't1' not found!");
            return;
        }
    }
    
    NSLog(@"Tables found in the database:%@", [_db tables]);
    NSLog(@"Get the maximum rowUID for 'address' (should be 0):%ld", [_db maxRowUIDForTable:sMyAddressTable]);
    
    // Add some data to it
    NSLog(@"Adding test data to the database...");
    const char* cstr = "test string converted to data";
    NSString* testDataString = @"Just one string";
    NSNumber* testDataNumber = [NSNumber numberWithFloat:1715.675];
    NSNumber* testDataBool = [NSNumber numberWithBool:YES];
    NSCalendarDate* testDataDate = [NSCalendarDate calendarDate];
    NSData* testDataData = [NSData dataWithBytes:cstr length:strlen(cstr)];
    if (![_db insertValues:[NSArray arrayWithObjects:[NSNull null], testDataString, testDataNumber, testDataBool, testDataDate, testDataData, nil] forColumns:[NSArray arrayWithObjects:QLRecordUID, @"testString", @"testNumber", @"testBoolean", @"testDateTime", @"testContainer", nil] inTable:@"test"]) {
        NSLog(@"Error when adding data to table 'test':%@", [_db lastError]);
        return;
    }
    
    NSLog(@"Verifying the test data...");
    NSNumber* lastRowUID = [_db lastRowInserted];
    QuickLiteRow* row = [[_db performQuery:[NSString stringWithFormat:@"SELECT * FROM test WHERE test.%@ = '%ld';", QLRecordUID, [lastRowUID unsignedLongValue]]]rowAtIndex:0];
    if (!row) {
        NSLog(@"The test data in table 'test' could not be retrieved:%@", [_db lastError]);
        return;
    }
    
    NSString* verifyString = [row valueForColumn:@"test.testString"];
    NSNumber* verifyNumber = [row valueForColumn:@"test.testNumber"];
    NSNumber* verifyBool = [row valueForColumn:@"test.testBoolean"];
    NSCalendarDate* verifyDate = [row valueForColumn:@"test.testDateTime"];
    NSData* verifyData = [row valueForColumn:@"test.testContainer"];
    if (![testDataString isEqualToString: verifyString])
        NSLog(@"Error verifying the test data: 'testString' failed: %@ ---> %@", testDataString, verifyString);
    else
        NSLog(@"String test passed");
    if (![[testDataNumber description] isEqualToString: [verifyNumber description]])
        NSLog(@"Error verifying the test data: 'testNumber' failed: %@ ---> %@", testDataNumber, verifyNumber);
    else
        NSLog(@"Number test passed");
    if (![[testDataBool description] isEqualToString: [verifyBool description]])
        NSLog(@"Error verifying the test data: 'testBoolean' failed: %@ ---> %@", testDataBool, verifyBool);
    else
        NSLog(@"Boolean test passed");
    if (fabs([testDataDate timeIntervalSinceDate:verifyDate]) >= 1)
        NSLog(@"Error verifying the test data: 'testDateTime' failed: %@ ---> %@", testDataDate, verifyDate);
    else
        NSLog(@"Date/Time test passed");
    if (![testDataData isEqual: verifyData])
        NSLog(@"Error verifying the test data: 'testContainer' failed: %@ ---> %@", testDataData, verifyData);
    else
        NSLog(@"Container test passed");
    
    if (![_db insertValues:[NSArray arrayWithObjects:[NSNull null], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil] forColumns:[NSArray arrayWithObjects:@"x", @"y", @"z", nil] inTable:@"t1"]) {
        NSLog(@"Error when adding data to table 't1':%@", [_db lastError]);
        return;
    }
    
    testDataString = @"9.0";
    testDataNumber = [NSNumber numberWithFloat:9.0];
    testDataBool = [NSNumber numberWithBool:YES];
    testDataDate = [NSCalendarDate calendarDate];
    testDataData = [NSData dataWithBytes:cstr length:strlen(cstr)];
    if (![_db insertValues:[NSArray arrayWithObjects:[NSNull null], testDataString, testDataNumber, testDataBool, testDataDate, testDataData, nil] forColumns:[NSArray arrayWithObjects:QLRecordUID, @"testString", @"testNumber", @"testBoolean", @"testDateTime", @"testContainer", nil] inTable:@"test"]) {
        NSLog(@"Error when adding data to table 'test':%@", [_db lastError]);
        return;
    }
    
    NSLog(@"State of table 't1' before removing column 'y':%@", [_db datatypesForTable:@"t1"]);
    if (![_db removeColumn:@"y" fromTable:@"t1"]) {
        NSLog(@"Error when removing column 'y' in table 't1':%@", [_db lastError]);
        return;
    } else {
        NSLog(@"New state of table 't1':%@", [_db datatypesForTable:@"t1"]);
    }
    
    if (![_db insertValues:[NSArray arrayWithObjects:[NSNull null], [NSNumber numberWithInt:345], nil] forColumns:[NSArray arrayWithObjects:@"x", @"z", nil] inTable:@"t1"]) {
        NSLog(@"Error when adding data to table 't1':%@", [_db lastError]);
        return;
    }
    if (![_db insertValues:[NSArray arrayWithObjects:[NSNull null], [NSNumber numberWithInt:321], nil] forColumns:[NSArray arrayWithObjects:@"x", @"z", nil] inTable:@"t1"]) {
        NSLog(@"Error when adding data to table 't1':%@", [_db lastError]);
        return;
    }
    
    NSLog(@"Adding table 'country' to the database...");
    if (![_db createTable:@"country" withColumns:[NSArray arrayWithObjects:sMyTestCountry, nil] andDatatypes:[NSArray arrayWithObjects:QLString, nil]]) {
        NSLog(@"Error when creating 'country' table:%@", [_db lastError]);
        return;
    }
    
    NSLog(@"Column names for table 'country':%@", [_db columnsForTable:@"country"]);
    NSLog(@"Datatypes for table 'country':%@", [_db datatypesForTable:@"country"]);
    
    NSLog(@"Adding temporary table 'tempTable' to the database...");
    if (![_db createTemporaryTable:@"tempTable" withColumns:[NSArray arrayWithObjects:QLRecordUID, @"dummy", nil] andDatatypes:[NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, nil]]) {
        NSLog(@"Error when creating temporary 'tempTable' table:%@", [_db lastError]);
        return;
    }
    
    NSLog(@"Column names for table 'tempTable':%@", [_db columnsForTable:@"tempTable"]);
    NSLog(@"Datatypes for table 'tempTable':%@", [_db datatypesForTable:@"tempTable"]);
    NSLog(@"Indexed columns for table 'tempTable':%@", [_db indexedColumnsForTable:@"tempTable"]);
        
    // Test for an empty cursor, add some data and save
    cursor = [_db performQuery:@"SELECT * FROM address;"];
    
    NSLog(@"Tables in the cursor:%@", [cursor tables]);
    NSLog(@"Values for column (should be empty):%@", [cursor valuesForColumn:@"address.ROWID"]);
    [cursor insertRowWithValues:[NSArray arrayWithObjects:[NSNull null], @"Javi", @"Ciur—", @"Espa–a", nil] forColumns:[NSArray arrayWithObjects:[NSString stringWithFormat:@"address.%@", QLRecordUID], [NSString stringWithFormat:@"address.%@", sMyTestFirstName], [NSString stringWithFormat:@"address.%@", sMyTestLastName], [NSString stringWithFormat:@"address.%@", sMyTestCountry], nil]];
    [cursor insertRowWithValues:[NSArray arrayWithObjects:[NSNull null], @"Ana", @"Garaicoechevarria", @"Espa–a", nil] forColumns:[NSArray arrayWithObjects:[NSString stringWithFormat:@"address.%@", QLRecordUID], [NSString stringWithFormat:@"address.%@", sMyTestFirstName], [NSString stringWithFormat:@"address.%@", sMyTestLastName], [NSString stringWithFormat:@"address.%@", sMyTestCountry], nil]];
    [cursor save];
    
    // Insert some test data via the database object
    NSLog(@"Inserting some test data to the 'address' table...");
    
    NSString* someQuote = @"'This is a test'";
    someQuote = [QuickLiteDatabase escapeQuotesFromString:someQuote];
    BOOL flagReturned = [cursor setValue:someQuote forColumn:@"address.Last"];
    NSLog(@"Value: %@", [[cursor rowAtIndex:0]valueForColumn:@"address.Last"]);
    [cursor save];
    cursor = [_db performQuery:@"SELECT * FROM address;"];
    NSLog(@"Value: %@", [[cursor rowAtIndex:0]valueForColumn:@"address.Last"]);

    [_db insertValues:[NSArray arrayWithObjects:[NSNull null], @"Tito", @"Ciur—", @"Espa–a", nil] forColumns:[NSArray arrayWithObjects:QLRecordUID, sMyTestFirstName, sMyTestLastName, sMyTestCountry, nil] inTable:sMyAddressTable];
    [_db insertValues:[NSArray arrayWithObjects:[NSNull null], @"Sam", @"Miti", @"Italy", nil] forColumns:[NSArray arrayWithObjects:QLRecordUID, sMyTestFirstName, sMyTestLastName, sMyTestCountry, nil] inTable:sMyAddressTable];
    [_db insertValues:[NSArray arrayWithObjects:[NSNull null], @"Joe", @"Schmuck", @"Germany", nil] forColumns:[NSArray arrayWithObjects:QLRecordUID, sMyTestFirstName, sMyTestLastName, sMyTestCountry, nil] inTable:sMyAddressTable];
    
    /*
     // ---- create in-memory database -------------------
     {
         QuickLiteDatabase *mem_db2 = [QuickLiteDatabase databaseWithFile:@":memory:"];
         [mem_db2 open:YES cacheMethod:DoNotCacheData];
         
         //copy
         [mem_db2 performQuery:[NSString stringWithFormat:@"ATTACH DATABASE '%@' AS file_db", [_db databasePath]]];
         
         [mem_db2 createTable:@"address_mem_2"
                  withColumns:[NSArray arrayWithObjects:QLRecordUID, sMyTestFirstName, sMyTestLastName, sMyTestZIP, sMyTestCountry, nil]
                 andDatatypes:[NSArray arrayWithObjects:QLRecordUIDDatatype, QLString, QLString, QLString, QLString, nil]];
         
         if (![mem_db2 copyTable:@"file_db.address" toTable:@"address_mem_2"])
             NSLog(@"Error when copying data to table 'address_mem_2':%@", [mem_db2 lastError]);
         else
             NSLog(@"Contents of address_mem_2: %@", [mem_db2 performQuery:@"SELECT * FROM address_mem_2;"]);
         [mem_db2 performQuery:[NSString stringWithFormat:@"DETACH DATABASE '%@'", [_db databasePath]]];
     }
     */
    NSLog(@"Inserting some test data to the 'country' table...");
    [_db insertValues:[NSArray arrayWithObjects:[NSNull null], @"Espa–a", nil] forColumns:[NSArray arrayWithObjects:QLRecordUID, sMyTestCountry, nil] inTable:@"country"];
    [_db insertValues:[NSArray arrayWithObjects:[NSNull null], @"Italy", nil] forColumns:[NSArray arrayWithObjects:QLRecordUID, sMyTestCountry, nil] inTable:@"country"];
    
    NSLog(@"Inserting some test data to the 'tempTable' table...");
    [_db insertValues:[NSArray arrayWithObjects:[NSNull null], @"whatever...", nil] forColumns:[NSArray arrayWithObjects:QLRecordUID, @"dummy", nil] inTable:@"tempTable"];
    
    // Add one more column, ad-hoc
    NSLog(@"Adding column 'SSN' to 'address'...");
    if (![_db addColumn:@"SSN" withDataType:QLString toTable:sMyAddressTable])
        NSLog(@"Error calling addColumn:%@", [_db lastError]);
    
    // Remove one column, ad-hoc
    NSLog(@"Removing column 'SSN' from 'address'...");
    if (![_db removeColumn:@"SSN" fromTable:sMyAddressTable])
        NSLog(@"Error calling removeColumn:%@", [_db lastError]);
    
    // Create indexes
    NSLog(@"Indexing '%@' in table '%@'", sMyTestFirstName, sMyAddressTable);
    [_db createIndexForColumn:sMyTestFirstName inTable:sMyAddressTable isUnique:NO];
    NSLog(@"Indexing '%@' in table '%@'", sMyTestLastName, sMyAddressTable);
    [_db createIndexForColumn:sMyTestLastName inTable:sMyAddressTable isUnique:NO];
    NSLog(@"Indexing '%@' in table '%@'", @"ThisShouldNotWork", sMyAddressTable);
    if (![_db createIndexForColumn:@"ThisShouldNotWork" inTable:sMyAddressTable isUnique:NO])
        NSLog(@"Error calling createIndexForColumn:%@", [_db lastError]);
    NSLog(@"Indexing '%@' in table '%@'", sMyTestCountry, @"country");
    [_db createIndexForColumn:sMyTestCountry inTable:@"country" isUnique:NO];
    NSLog(@"Indexing '%@' in table '%@'", @"dummy", @"tempTable");
    [_db createIndexForColumn:@"dummy" inTable:@"tempTable" isUnique:NO];
    
    // Find out what tables are contained in the database
    NSLog(@"Indexes found in the table 'address':%@", [_db indexedColumnsForTable:sMyAddressTable]);
    
    // Find out what tables are contained in the database
    NSLog(@"Tables found in the database:%@", [_db tables]);
    
    // Find out what columns are contained in the 'address' table
    NSLog(@"Column names for table 'address':%@", [_db columnsForTable:sMyAddressTable]);
    
    // Find out what temporary tables are contained in the database
    NSLog(@"Temporary tables found in the database:%@", [_db temporaryTables]);
    
    // Find out what temporary columns are contained in the 'address' table
    NSLog(@"Column names for temporary table 'tempTable':%@", [_db columnsForTable:@"tempTable"]);
    
    NSLog(@"Indexes for temporary table 'tempTable':%@", [_db indexedColumnsForTable:@"tempTable"]);
    
    NSLog(@"Cache size:%ld pages (4KB each)", [_db sessionCacheSize]);
    NSLog(@"Setting the cache to 1100 pages...");
    [_db setSessionCacheSize:1100];
    NSLog(@"Cache size:%ld pages (4KB each)", [_db sessionCacheSize]);
    
    NSLog(@"Synchronous mode:%d", [_db synchronousMode]);
    NSLog(@"Setting the synchronous mode to FULL...");
    [_db setSynchronousMode:SynchronousModeFull];
    NSLog(@"Synchronous mode:%d", [_db synchronousMode]);
    
    NSLog(@"Temp store mode:%d", [_db tempStoreMode]);
    
    NSLog(@"Data types for table 'Table_THIS_SHOULD_NOT_WORK':%@", [_db datatypesForTable:@"Table_THIS_SHOULD_NOT_WORK"]);
    
    // Create and execute the query
    cursor = [_db performQuery:@"SELECT * FROM adDresS, country WHERE address.Country = country.Country;"];
    NSLog(@"Executing query:%@", [cursor sqlQuery]);
    
    // Find out what first name values are found in the cursor
    NSLog(@"Column values for '%@' found in the cursor:%@", sMyTestFirstName, [cursor valuesForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
    
    // Find out what ZIP values are found in the cursor
    NSLog(@"Column values for '%@' found in the cursor:%@", sMyTestZIP, [cursor valuesForColumn:[NSString stringWithFormat:@"address.%@", sMyTestZIP]]);
    
    // Get the cursor row count
    NSLog(@"Records selected:%ld", [cursor rowCount]);
    NSLog(@"Columns in result set:%ld", [cursor columnCount]);
    NSLog(@"");
    
    for (i = 0; i < [cursor rowCount]; i++) {
        QuickLiteRow* row = [cursor rowAtIndex:i];
        
        if (row != nil) {
            NSLog(@"%@:%@", QLRecordUID, [row valueForColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID]]);
            NSLog(@"%@:%@", sMyTestFirstName, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
            NSLog(@"%@:%@", sMyTestLastName, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestLastName]]);
            NSLog(@"%@:%@", sMyTestCountry, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestCountry]]);
            NSLog(@"%@:%@", sMyTestZIP, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestZIP]]);
            NSLog(@"");
            NSLog(@"Calling 'description' for row:");
            NSLog(@"%@", row);
        }
    }
    
    {
        QuickLiteCursor *a = [_db performQuery:@"SELECT * FROM address WHERE Country LIKE 'Espa–a';"];
        QuickLiteCursor *b = [_db performQuery:@"SELECT * FROM address WHERE Country LIKE 'Italy';"];
        NSLog(@"[a unionCursor:b]: %@", [a unionCursor:b cacheMethod:DoNotCacheData]);
    }
    
    {
        QuickLiteCursor *a = [_db performQuery:@"SELECT * FROM address;"];
        QuickLiteCursor *b = [_db performQuery:@"SELECT * FROM address WHERE Country LIKE 'Espa–a';"];
        NSLog(@"[a minusCursor:b]: %@", [a minusCursor:b cacheMethod:DoNotCacheData]);
    }
    
    {
        QuickLiteCursor *a = [_db performQuery:@"SELECT * FROM address;"];
        QuickLiteCursor *b = [_db performQuery:@"SELECT * FROM address WHERE Country LIKE 'Espa–a';"];
        NSLog(@"[a intersectCursor:b]: %@", [a intersectCursor:b cacheMethod:DoNotCacheData]);
    }
    
    {
        QuickLiteCursor *a = [_db performQuery:@"SELECT * FROM address WHERE Country LIKE 'Espa–a';"];
        QuickLiteCursor *b = [_db performQuery:@"SELECT * FROM address WHERE Country LIKE 'Espa–a';"];
        NSLog(@"[a minusCursor:b]: %@", [a minusCursor:b cacheMethod:DoNotCacheData]);
    }
    
    {
        QuickLiteCursor *cursor = [_db performQuery:@"SELECT * FROM address;"];
        
        NSLog(@"[matchingRowWithValue:%@ forColumn:address.First]: %ld", @"Tito", [cursor matchingRowWithValue:@"Tito" forColumn:@"address.First"]);
        NSLog(@"[matchingRowWithValue:%@ forColumn:address.First startAtIndex:3]: %ld", @"Tito", [cursor matchingRowWithValue:@"Tito" forColumn:@"address.First" startAtIndex:3]);
        NSLog(@"[matchingRowWithValue:%@ forColumn:address.First startAtIndex:0 comparisonMethod:NSCaseInsensitiveSearch]: %ld", @"TIto", [cursor matchingRowWithValue:@"TIto" forColumn:@"address.First" startAtIndex:0 comparisonMethod:NSCaseInsensitiveSearch]);
        NSLog(@"[matchingRowWithValue:%@ forColumn:address.First startAtIndex:0 comparisonMethod:NSLiteralSearch]: %ld", @"TIto", [cursor matchingRowWithValue:@"TIto" forColumn:@"address.First" startAtIndex:0 comparisonMethod:NSLiteralSearch]);
        
        NSLog(@"[matchingRowsWithValues:%@ forColumn:%@ setOperation:Union]: %@", [NSArray arrayWithObjects:@"Espa–a", @"Italy", nil], @"address.Country", [cursor matchingRowsWithValues:[NSArray arrayWithObjects:@"Espa–a", @"Italy", nil] forColumn:@"address.Country"]);
        NSLog(@"[matchingRowsWithValues:%@ forColumn:%@ setOperation:Union comparisonMethod:NSCaseInsensitiveSearch]: %@", [NSArray arrayWithObjects:@"Espa–a", @"Italy", nil], @"address.Country", [cursor matchingRowsWithValues:[NSArray arrayWithObjects:@"Espa–a", @"Italy", nil] forColumn:@"address.Country" comparisonMethod:NSCaseInsensitiveSearch]);
        NSLog(@"[matchingRowsWithValues:%@ forColumn:%@ setOperation:Union comparisonMethod:NSLiteralSearch]: %@", [NSArray arrayWithObjects:@"Espa–a", @"ITALY", nil], @"address.Country", [cursor matchingRowsWithValues:[NSArray arrayWithObjects:@"Espa–a", @"ITALY", nil] forColumn:@"address.Country" comparisonMethod:NSLiteralSearch]);
    }
    
    NSLog(@"Data types for table 'address'...");
    NSLog(@"%@", [_db datatypesForTable:sMyAddressTable]);
    
    // Save the row to be tested later
    row = [cursor rowAtIndex:2];
    NSLog(@"Values for row #2 before editing it:%@", [row values]);
    
    NSLog(@"Setting a value for sMyTestFirstName to 'Rogger Rabbit'...");
    if(![row setValue:@"Rogger Rabbit" forColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]])
        NSLog(@"The row couldn't be modified");
    else
        NSLog(@"Getting the value for sMyTestFirstName:%@", [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
    
    NSLog(@"Values for row #2 after editing it:%@", [row values]);
    
    // Find out what column values are found in the cursor
    NSLog(@"Column values found in the cursor for sMyTestFirstName:%@", [cursor valuesForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
    
    // Find out what column values are found in the cursor
    NSLog(@"Column values found in the cursor for sMyTestZIP:%@", [cursor valuesForColumn:[NSString stringWithFormat:@"address.%@", sMyTestZIP]]);
    
    // Attempt to update all rows at once
    NSLog(@"Attempting to set the ZIP of the cursor to '94025'...");
    if (![cursor setValue:@"94025" forColumn:[NSString stringWithFormat:@"address.%@", sMyTestZIP]]) {
        NSLog(@"The cursor update failed:%@", [_db lastError]);
        return;
    }
    
    //[_db performQuery:@"UPDATE address SET Last = NULL WHERE ROWID = '1';"];
    
    {   //???
        QuickLiteCursor *myCursor = [_db performQuery:@"SELECT * FROM address LIMIT 1;"];
        if ([myCursor rowCount]) {
            NSDictionary *rowData = [myCursor valuesForRow:0];
            NSNumber *rowUID = [rowData objectForKey:@"address.ROWID"];
            NSArray *columns = [rowData allKeys];
            NSArray *values = [rowData allValues];
            if (![_db updateValues:values forColumns:columns withRowUID:rowUID inTable:@"address"]) {
                NSLog(@"UpdateValues failed for rowUID: %@.", rowUID);
            } else {
                QuickLiteCursor* cursorCheck = [_db performQuery:[NSString stringWithFormat:@"SELECT * FROM address WHERE address.ROWID = '%@';", rowUID]];
                NSLog(@"UpdateValues result:\n%@", cursorCheck);
            }
        }
    }
    
    // Attempt to update all rows at once
    NSLog(@"Attempting to set the Country of the cursor to 'NULL'...");
    if (![cursor setValue:[NSNull null] forColumn:[NSString stringWithFormat:@"address.%@", sMyTestCountry]]) {
        NSLog(@"The cursor update failed:%@", [_db lastError]);
        return;
    } else {
        NSLog(@"The cursor update has been successful");
    }
    
    // Attempt to update all rows at once
    NSLog(@"Attempting to set the ROWID of the cursor to 'NULL'...");
    if (![cursor setValue:[NSNull null] forColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID]]) {
        NSLog(@"The cursor update failed (as expected)");
    }
    
    NSLog(@"Inserting a new record in 'address' via cursor...");
    if (![cursor insertRowWithValues:[NSArray arrayWithObjects:[NSNull null], @"Thor", @"Gotewald", @"Sweden", nil] forColumns:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@.%@", sMyAddressTable, QLRecordUID], [NSString stringWithFormat:@"%@.%@", sMyAddressTable, sMyTestFirstName], [NSString stringWithFormat:@"%@.%@", sMyAddressTable, sMyTestLastName], [NSString stringWithFormat:@"%@.%@", sMyAddressTable, sMyTestCountry], nil]])
        NSLog(@"Inserting failed.");
    
    NSLog(@"Obtaining the range of the inserted rows...");
    NSRange range = [cursor rangeOfInsertedRows];
    NSLog(@"Location: %ld  Length: %ld", range.location, range.length);
    
    NSLog(@"Modified rowUIDs:%@", [cursor modifiedRowUIDs]);
    NSLog(@"Column values for '%@' found in the cursor:%@", sMyTestFirstName, [cursor valuesForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
    NSLog(@"Tables found in the cursor:%@", [cursor tables]);
    
    NSLog(@"Committing the changes to the database...");
    if ([_db save]) {
        [cursor refresh];
        NSLog(@"Obtaining the range of the inserted rows (should fail)...");
        NSRange range = [cursor rangeOfInsertedRows];
        NSLog(@"Location: %ld  Length: %ld", range.location, range.length);
    } else {
        NSLog(@"The changes couldn't be saved:%@", [_db lastError]);
    }
    
    [_db beginTransaction];
    
    // Just a test to verify edits on inserted (not yet commited) values
    {
        //QuickLiteCursor* cursor = [_db performQuery: @"SELECT Last FROM address WHERE ROWID = '-1';"];
        QuickLiteCursor* cursor = [_db performQuery: @"SELECT Last FROM address;"];
        [cursor insertRowWithValues:[NSArray arrayWithObjects:@"Petardo", nil] forColumns:[NSArray arrayWithObjects:@"address.Last", nil]];
        NSLog(@"cursor before editing the new (not yet saved) entry:%@", cursor);
        
        QuickLiteRow* row = [cursor rowAtIndex: [cursor rowCount] - 1];
        [row setValue:@"Kuesko" forColumn:@"address.Last"];
        NSLog(@"cursor after editing the new (not yet saved) entry:%@", cursor);
        
        [cursor save];
        NSLog(@"New cursor data:%@", [_db performQuery: @"SELECT Last FROM address;"]);
    }
    
    NSLog(@"Contents of the cursor after committing:%@", cursor);
    
    NSLog(@"[row description]:\n%@", [row description]);
    
    NSLog(@"Values for row 0:%@", [row values]);
    NSLog(@"Values for tableAndColumn '%@':%@", sMyTestFirstName, [cursor valuesForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
    
    NSLog(@"Setting a value for sMyTestFirstName to 'Taz'...");
    if(![row setValue:@"Taz" forColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]])
        NSLog(@"The row couldn't be modified");
    else
        NSLog(@"[row description]:\n%@", [row description]);
    
    NSLog(@"Reverting the changes uncommitted...");
    [_db revert];
    
    [_db beginTransaction];
    
    NSLog(@"Setting the country of row %ld to 'Congo'...", [row index]);
    if(![row setValue:@"Congo" forColumn:[NSString stringWithFormat:@"address.%@", sMyTestCountry]])
        NSLog(@"The row couldn't be modified");
    else
        NSLog(@"Getting the value for sMyTestCountry:%@", [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestCountry]]);	
    
    for (i = 0; i < [cursor rowCount]; i++) {
        QuickLiteRow* row = [cursor rowAtIndex:i];
        
        if (row != nil) {
            NSLog(@"%@:%@", QLRecordUID, [row valueForColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID]]);
            NSLog(@"%@:%@", sMyTestFirstName, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
            NSLog(@"%@:%@", sMyTestLastName, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestLastName]]);
            NSLog(@"%@:%@", sMyTestCountry, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestCountry]]);
            NSLog(@"%@:%@", sMyTestZIP, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestZIP]]);
            NSLog(@" ");
            NSLog(@"Calling 'description' for row:");
            NSLog(@"%@", row);
        }
    }
    
    NSLog(@"Attempting to set the rowUID for the row to another value (it should fail)...");
    if(![row setValue:@"321123" forColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID]])
        NSLog(@"The row couldn't be modified (as expected)");
    
    NSLog(@"Verifying the integrity of the database...");
    if ([_db integrityCheck])
        NSLog(@"The database seems to be OK.");
    else
        NSLog(@"The database seems to be damaged.");
    
    NSLog(@"[cursor description] before deleting row #2:\n%@", [cursor description]);
    if ([cursor removeAllRowUIDsAtIndex:2]) {
        NSLog(@"Deletion of rowUID '2' has succeeded.");
    } else {
        NSLog(@"Deletion of rowUID '2' has failed.");
    }
    NSLog(@"[cursor description] after calling delete row #2:\n%@", [cursor description]);
    
    NSLog(@"[cursor valuesForRow:2]:%@", [cursor valuesForRow:2]);
    
    NSNumber* rowUID = [NSNumber numberWithInt:6];
    NSArray* values = [NSArray arrayWithObjects:@"33149", @"USA", nil];
    NSArray* columns = [NSArray arrayWithObjects: sMyTestZIP, sMyTestCountry, nil];
    
    NSLog(@"Updating rowUID 6 with ZIP = 33149 and Country = USA...");
    if (![_db updateValues:values forColumns:columns withRowUID:rowUID inTable:sMyAddressTable]) {
        NSLog(@"UpdateValues failed for rowUID: %@.", rowUID);
    } else {
        QuickLiteCursor* cursorCheck = [_db performQuery:@"SELECT * FROM address WHERE address.ROWID = '6';"];
        NSLog(@"UpdateValues result:\n%@", cursorCheck);
    }
    
    NSLog(@"Get the maximum rowUID for 'address' (should be 6):%ld", [_db maxRowUIDForTable:sMyAddressTable]);
    
    NSLog(@"Get the row index for column 'Country' containing 'Italy'...");
    unsigned long rowIndex = [cursor matchingRowWithValue:@"Italy" forColumn:@"address.Country"];
    if (rowIndex != NSNotFound) {
        NSLog(@"Value found:");
        NSLog(@"%@", [cursor rowAtIndex:rowIndex]);
    } else {
        NSLog(@"Value not found.");
    }
    
    NSLog(@"Get the row index for column 'Country' containing 'Neverland' (it should fail)...");
    rowIndex = [cursor matchingRowWithValue:@"Neverland" forColumn:@"address.Country"];
    if (rowIndex != NSNotFound) {
        QuickLiteRow* singleRow = [cursor rowAtIndex:rowIndex];
        NSLog(@"Value found:");
        NSLog(@"%@", singleRow);
        NSLog(@"Row %d: rowUID --> %d", i, [singleRow intValueForColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID]]);
    } else {
        NSLog(@"Value not found.");
    }
    
    NSLog(@"Get all row indexes for column 'Country' containing 'Espa–a'...");
    NSArray* rowIndexes = [cursor matchingRowsWithValues:[NSArray arrayWithObject:@"Espa–a"] forColumn:@"address.Country" comparisonMethod:NSCaseInsensitiveSearch];
    if (rowIndexes) {
        NSLog(@"Rows found matching value: %ld", [rowIndexes count]);
        for (i = 0; i < [rowIndexes count]; i++) {
            QuickLiteRow* row = [cursor rowAtIndex:[[rowIndexes objectAtIndex:i]unsignedIntValue]];
            
            if (row != nil) {
                NSLog(@"Row %d: rowUID --> %d", i, [row intValueForColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID]]);
                NSLog(@"Row %d: Last --> %s", i, [row textValueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestLastName]]);
                NSLog(@"%@:%@", QLRecordUID, [row valueForColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID]]);
                NSLog(@"%@:%@", sMyTestFirstName, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
                NSLog(@"%@:%@", sMyTestLastName, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestLastName]]);
                NSLog(@"%@:%@", sMyTestCountry, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestCountry]]);
                NSLog(@"%@:%@", sMyTestZIP, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestZIP]]);
                NSLog(@" ");
            }
        }
    } else {
        NSLog(@"Value not found.");
    }
    
    cursor = [_db performQuery:@"SELECT * FROM address;"];
    
    for (i = 0; i < [cursor rowCount]; i++) {
        QuickLiteRow* row = [cursor rowAtIndex:i];
        
        if (row != nil) {
            NSLog(@"%@:%@", QLRecordUID, [row valueForColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID]]);
            NSLog(@"%@:%@", sMyTestFirstName, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
            NSLog(@"%@:%@", sMyTestLastName, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestLastName]]);
            NSLog(@"%@:%@", sMyTestCountry, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestCountry]]);
            NSLog(@"%@:%@", sMyTestZIP, [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestZIP]]);
            NSLog(@"");
            NSLog(@"Calling 'description' for row:");
            NSLog(@"%@", row);
        }
    }
    
    NSLog(@"List of rowUIDs (fetching its scalar type): ");
    for (i = 0; i < [cursor rowCount]; i++) {
        NSLog(@"Row %d: rowUID --> %qi", i, [cursor longLongValueForColumn:[NSString stringWithFormat:@"address.%@", QLRecordUID] andRow:i]);
    }
    
    // Create an address backup table...
    columns = [_db columnsForTable:sMyAddressTable];
    NSArray *datatypes = [_db datatypesForTable:sMyAddressTable];
    NSLog(@"Copying table 'address' to 'address_backup'...");
    if (![_db createTable:@"address_backup" withColumns:columns andDatatypes:datatypes]) {
        NSLog(@"Error when creating 'address_backup' table:%@", [_db lastError]);
        return;
    }
    if ([_db copyTable:sMyAddressTable toTable:@"address_backup"] == NO)
        NSLog(@"copyTable failed for address and address_backup.");
    
    NSLog(@"tables: %@", [_db tables]);
    NSLog(@"allTables: %@", [_db allTables]);
    
    NSLog(@"Table info for 'people': %@", [_db tableInfo: @"address"]);
    
    NSLog(@"Closing the database...");
    [_db close];
    _db = nil;
    
    [cursor refresh];
    
    NSLog(@"Setting the value for sMyTestFirstName to 'Dummy Value'...");
    if(![row setValue:@"Dummy Value" forColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]])
        NSLog(@"The row couldn't be modified.");
    
    NSLog(@"[cursor description] after the database has been closed:\n%@", [cursor description]);
    NSLog(@"[row description]:\n%@", [row description]);
    
    NSLog(@"[cursor columnCount]:%d", [cursor columnCount]);
    NSLog(@"[cursor rowCount]:%d", [cursor rowCount]);
    
    NSLog(@"[row valueForColumn:sMyTestFirstName] -> %@", [row valueForColumn:[NSString stringWithFormat:@"address.%@", sMyTestFirstName]]);
    
    [pool release];
}

@end

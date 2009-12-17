//
//  SqliteBenchMark.m
//  SuperTableView
//
//  Created by JŽr™me Lebel on Mon Jan 20 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "SqliteBenchMark.h"
#import <fcntl.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <sys/stat.h>
#include <unistd.h>

#define SQL_DATABASE_NAME @"/tmp/database.data"
#define STRING_SIZE 25
NSString* const sTableName		= @"people";
NSString* const sTableRecordID		= @"recordID";
NSString* const sTableColumn		= @"column_";

@interface SqliteBenchMark(PrivateAPI)
- (NSTimeInterval)createIndex;
- (BOOL)openNewDatabase;
- (void)generateDummyRecords;
- (void)generateDummyStringWithBuffer:(char *)buffer length:(unsigned int)length;
- (unsigned long)generateRandomNumber;
@end

@implementation SqliteBenchMark
- (id)initWithDelegate:(id)newDelegate
{
    [super init];
    delegate = newDelegate;
    return self;
}

- (void)dealloc
{
    [mDatabase release];
    [super dealloc];
}

- (void)setNumberOfRecords:(unsigned long)newRecords
{
    mRecords = newRecords;
}

- (void)setNumberOfColumns:(unsigned long)newColumns
{
    mColumns = newColumns;
}

- (void)setNumberOfIndexedColumns:(unsigned long)newIndexedColumns
{
    mIndexedColumns = newIndexedColumns;
}

- (void)setIndexingType:(SPTV_IndexType)newIndexingType;
{
    indexingType = newIndexingType;
}

- (NSString *)databasePath
{
    return SQL_DATABASE_NAME;
}

- (QuickLiteDatabase *)database
{
    return mDatabase;
}

- (NSTimeInterval)indexingSeconds
{
    return indexingSeconds;
}

- (NSTimeInterval)insertingSeconds
{
    return insertingSeconds;
}

- (NSTimeInterval)selectingSeconds
{
    return selectingSeconds;
}

- (BOOL)startBenchMark
{
    BOOL result = YES;
    NSDate* timingCreateStarted;

    // Create a new database
    if(![self openNewDatabase]) {
        result = NO;
    } else {
        if (indexingType == SPTV_IndexBefore) {
            indexingSeconds = [self createIndex];
        }

        if (mRecords > 0) {
            timingCreateStarted= [NSDate date];
            [self generateDummyRecords];

            insertingSeconds = [[NSDate date] timeIntervalSinceDate: timingCreateStarted];

            if (indexingType == SPTV_IndexAfter) {
                indexingSeconds = [self createIndex];
            }
        }
    }
    return result;
}

- (QuickLiteResult *)selectRecordsWithMatchType:(SPTV_SearchType)matchType andValue:(NSString*)value
{
    QuickLiteResult * sqlResult;
    NSMutableString* sqlQuery = nil;
    NSDate* timingStarted;

    if ([value isEqualToString: @""]) {
        sqlQuery = [[NSMutableString alloc] initWithFormat: @"SELECT * FROM %@", sTableName];
    } else {
        NSString * operatorFormat;
        NSString * valueFormat;
        unsigned long i;

        sqlQuery = [[NSMutableString alloc] initWithFormat: @"SELECT * FROM %@ WHERE ", sTableName];
        switch(matchType) {
            case SPTV_Contains:
                operatorFormat = @"LIKE";
                valueFormat = @"'%%%@%%'";
                break;
            case SPTV_StartsWith:
                operatorFormat = @"LIKE";
                valueFormat = @"'%@%%'";
                break;
            default:
                operatorFormat = @"=";
                valueFormat = @"'%@'";
                break;
        }
        for(i = 0; i < mColumns; i++) {
            [sqlQuery appendFormat:@"%@%ld %@ ", sTableColumn, i, operatorFormat];
            [sqlQuery appendFormat:valueFormat, value];
            if(i + 1 < mColumns) {
                [sqlQuery appendString:@" OR "];
            }
        }
    }
    
    timingStarted = [NSDate date];
    sqlResult = [mDatabase performQuery: sqlQuery];
    selectingSeconds = [[NSDate date] timeIntervalSinceDate: timingStarted];
    return sqlResult;
}

- (unsigned long)recordsInTable
{
    NSString* sqlQuery;
    QuickLiteResult* results;
    NSString* value;
    
    sqlQuery = [NSString stringWithFormat: @"SELECT COUNT(*) FROM %@", sTableName];
    results = [mDatabase performQuery: sqlQuery];
    
    value = [results stringForColumn: @"COUNT(*)" andRow: 0];
    if (value != nil)
	return [value intValue];

    return 0;
}

- (NSString *)columnNameAtIndex:(unsigned long)index
{
    return [NSString stringWithFormat:@"%@%d", sTableColumn, index];
}
@end

@implementation SqliteBenchMark(PrivateAPI)

- (NSTimeInterval)createIndex
{
    unsigned long i;
    NSDate* timingCreateStarted= [NSDate date];
    NSString * sqlQuery;

    [delegate indexingRecords];

    [mDatabase performQuery: @"BEGIN TRANSACTION"];

    for(i = 0; i < mIndexedColumns; i++) {
        sqlQuery = [[NSString alloc] initWithFormat: @"CREATE INDEX %@ ON %@(%@%ld)", [NSString stringWithFormat: @"%@_idx_%@%ld", sTableName, sTableColumn, i], sTableName, sTableColumn, i];
        [mDatabase performQuery: sqlQuery];
        [sqlQuery release];
    }

    [mDatabase performQuery: @"COMMIT"];

    return [[NSDate date] timeIntervalSinceDate: timingCreateStarted];
}

- (BOOL)openNewDatabase
{
    BOOL result = YES;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableString* sqlQuery;

    if (mDatabase != nil) {
        [mDatabase close];
        [mDatabase release];
        mDatabase = nil;
    }

    // Remove the file
    [fm removeFileAtPath: SQL_DATABASE_NAME handler: nil];

    // Create and open the database
    mDatabase = [QuickLiteDatabase databaseWithFile: SQL_DATABASE_NAME];
    if( [mDatabase open] ) {
        unsigned long i;

        // make sure we keep it around
        [mDatabase retain];

        sqlQuery = [NSMutableString stringWithFormat: @"CREATE TABLE %@ (%@ INTEGER PRIMARY KEY", sTableName, sTableRecordID];
        for(i = 0; i < mColumns; i++) {
            [sqlQuery appendFormat: @", %@%ld VARCHAR(255)", sTableColumn, i];
        }
        [sqlQuery appendString:@")"];

        // Make sure we start with an empty database. Create the table and indices as needed.
        [mDatabase performQuery: @"BEGIN TRANSACTION"];
        [mDatabase performQuery: sqlQuery];
        [mDatabase performQuery: @"COMMIT"];

    } else {
        result = NO;
    }
    return result;
}

- (void)generateDummyRecords
{
    unsigned long i;
    unsigned long columnCursor;
    unsigned long progressBarStep;
    unsigned long stepCounter = 0;
    NSMutableString* sqlFirstPart;
    NSMutableString* sqlSecondPart;
    NSString * sqlQuery;
    char* dummyString = malloc(STRING_SIZE + 1);

    [delegate insertingRecords];
    sqlFirstPart = [[NSMutableString alloc] initWithFormat: @"INSERT INTO %@ (%@", sTableName, sTableRecordID];
    for (columnCursor = 0; columnCursor < mColumns; columnCursor++) {
        [sqlFirstPart appendFormat:@", %@%ld", sTableColumn, columnCursor];
    }
    [sqlFirstPart appendString:@") VALUES (NULL"];

    [mDatabase performQuery: @"BEGIN TRANSACTION"];

    progressBarStep = mRecords * 0.02; // update the display after 2% of the mRecords
    for(i = 0; i < mRecords; i++) {

        stepCounter++;
        if (stepCounter >= progressBarStep) {
            [delegate insertingRecordsStep:stepCounter];
            stepCounter = 0;
        }

        sqlSecondPart = [[NSMutableString alloc] init];
        for (columnCursor = 0; columnCursor < mColumns; columnCursor++) {
            [self generateDummyStringWithBuffer:dummyString length:([self generateRandomNumber] % 25) + 1];
            [sqlSecondPart appendFormat:@", '%s'", dummyString];
        }
        sqlQuery = [[NSString alloc] initWithFormat:@"%@%@)", sqlFirstPart, sqlSecondPart];
        [mDatabase performQuery: sqlQuery];
        [sqlQuery release];
    }
    free(dummyString);

    [mDatabase performQuery: @"COMMIT"];
    [delegate insertingRecordsStep:stepCounter];
    [sqlFirstPart release];
}

- (void)generateDummyStringWithBuffer:(char *)buffer length:(unsigned int)length
{
    unsigned long i, c, t = 0;

    for(i = 0; i < length; i++) {
        do {
            c = ([self generateRandomNumber] % (122 - 65 + 1)) + 65;
        } while (isalpha(c) == 0);
        buffer[t++] = c;
    }

    buffer[length]='\0';
}

- (unsigned long)generateRandomNumber
{
    return rand();
}
@end

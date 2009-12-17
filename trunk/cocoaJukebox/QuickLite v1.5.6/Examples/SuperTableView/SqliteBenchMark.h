//
//  SqliteBenchMark.h
//  SuperTableView
//
//  Created by JŽr™me Lebel on Mon Jan 20 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickLiteDatabase.h"
#import "QuickLiteResult.h"

typedef enum SPTV_IndexType
{
    SPTV_NoIndex = 0,
    SPTV_IndexBefore,
    SPTV_IndexAfter
} SPTV_IndexType;

typedef enum SPTV_SearchType
{
    SPTV_Contains = 0,
    SPTV_StartsWith,
    SPTV_ExactMatch,
    SPTV_Join
} SPTV_SearchType;

@protocol SqliteBenchMarkDelegateProtocol
- (void)indexingRecords;
- (void)insertingRecords;
- (void)insertingRecordsStep:(unsigned long)stepOfRecords;
@end

@interface SqliteBenchMark : NSObject {
    int queryFile;
    
    unsigned long mRecords;
    unsigned long mColumns;
    unsigned long mIndexedColumns;
    SPTV_IndexType indexingType;

    NSTimeInterval indexingSeconds;
    NSTimeInterval insertingSeconds;
    NSTimeInterval selectingSeconds;

    QuickLiteDatabase *mDatabase;
    id delegate;
}
- (id)initWithDelegate:(id)newDelegate;

- (void)setNumberOfRecords:(unsigned long)newRecords;
- (void)setNumberOfColumns:(unsigned long)newColumns;
- (void)setNumberOfIndexedColumns:(unsigned long)newIndexedColumns;
- (void)setIndexingType:(SPTV_IndexType)newIndexingType;

- (NSTimeInterval)indexingSeconds;
- (NSTimeInterval)insertingSeconds;
- (NSTimeInterval)selectingSeconds;
- (QuickLiteDatabase *)database;
- (NSString *)databasePath;

- (BOOL)startBenchMark;
- (QuickLiteResult *)selectRecordsWithMatchType:(SPTV_SearchType)matchType andValue:(NSString*)value;
- (unsigned long)recordsInTable;
- (NSString *)columnNameAtIndex:(unsigned long)index;
@end

/*
 *  Controller.h
 *  SuperTableView
 *
 *  Created by tciuro on Tue Jan 20 2003.
 *  Copyright (c) 2003 Tito Ciuro. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>

#import <QuickLite/QuickLiteDatabase.h>
#import <QuickLite/QuickLiteCursor.h>

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

@interface Controller : NSObject
{
    IBOutlet NSWindow			*mWindow;
    IBOutlet NSTableView		*mTableView;
    IBOutlet NSTextField		*mTableLineCount;
    
    IBOutlet NSDrawer			*mDrawer;
    IBOutlet NSTextField		*mRecordsField;
    IBOutlet NSPopUpButton		*mIndexOptions;
    IBOutlet NSTextField		*mGenerateStatusField;
    IBOutlet NSMatrix			*mSelectOptions;
    IBOutlet NSMatrix			*mSelectMatchType;
    IBOutlet NSTextField		*mSelectValueField;
    IBOutlet NSTextField		*mSelectStatusField;
    IBOutlet NSProgressIndicator	*mProgressBar;
    IBOutlet NSTextField		*mProcessInfo;
    IBOutlet NSButton                   *mGenerateMirrorButton;
    IBOutlet NSButton			*mDebugButton;
    IBOutlet NSButton			*mSendSQLStatementButton;
    
    QuickLiteDatabase	*mDatabase;    
    NSString			*mDataPath;
    QuickLiteCursor		*mSQLCursor;		
}

- (IBAction)clearAndCreate:(id)sender;
- (IBAction)selectRecords:(id)sender;
- (IBAction)setCacheMethod:(id)sender;
- (IBAction)setDebugMode:(id)sender;
- (IBAction)setSendsSQLStatements:(id)sender;

- (void)openDatabase;
- (void)generateDummyRecords:(NSArray*)randomStrings;
- (NSString*)generateDummyString:(unsigned int)length;
- (unsigned long)generateRandomNumber;
- (NSString*)selectRecordsWithMatchType:(SPTV_SearchType)matchType andValue:(NSString*)value;

- (void)restartUI;
- (void)setProcessInfo:(NSString*)message;

@end

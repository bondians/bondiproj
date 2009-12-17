//
//  MyDocument.h
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sat Aug 16 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QuickLite/QuickLiteDatabase.h>
#import "MyTablesTableViewDelegate.h"
#import "MyColumnsTableViewDelegate.h"
#import "MyResultsTableViewDelegate.h"
#import "MyImportDataDelegate.h"

@interface MyDocument : NSDocument
{
    IBOutlet NSTextField*			mSQLQueryField;
    IBOutlet NSButton*				mOpenButton;
    IBOutlet NSButton*				mCloseButton;
    IBOutlet MyTablesTableViewDelegate*		mTablesDelegate;
    IBOutlet MyColumnsTableViewDelegate*	mColumnsDelegate;
    IBOutlet MyResultsTableViewDelegate*	mResultsDelegate;
    IBOutlet MyImportDataDelegate*              mImportDataDelegate;
    IBOutlet NSPanel*                           mImportPanel;
    IBOutlet NSButton*                          mRefreshButton;
    IBOutlet NSButton*				mDeleteButton;
    IBOutlet NSButton*				mDebugButton;
    IBOutlet NSButton*				mSendSQLStatementButton;
    
    NSWindowController*                         mWindowController;
    QuickLiteDatabase*                          mDatabase;
}

- (IBAction)openDocument:(id)sender;
- (IBAction)createNewDatabase:(id)sender;
- (IBAction)closeSQLiteDatabase:(id)sender;
- (IBAction)executeSQLQuery:(id)sender;
- (IBAction)openImportSheet:(id)sender;
- (IBAction)refreshUI:(id)sender;
- (IBAction)dropTable:(id)sender;
- (IBAction)setDebugMode:(id)sender;
- (IBAction)setSendsSQLStatements:(id)sender;

- (void)extractSQLiteDatabase;
- (void)freeQuickLiteDatabase;

- (QuickLiteDatabase*)database;

@end

//
//  MyTablesTableViewDelegate.h
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sat Aug 16 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuickLite/QuickLiteDatabase.h>
#import <QuickLite/QuickLiteDatabaseExtras.h>

@interface MyTablesTableViewDelegate : NSObject
{
    IBOutlet NSTableView*	mTablesTableView;
    
    QuickLiteDatabase*		mDatabase;
    NSArray*				mTables;
}

- (void)setDatabase:(QuickLiteDatabase*)database;
- (void)displayDatabaseTables;
- (void)notifyTableSelectionHasChanged;

- (void)dropSelectedTable;

@end

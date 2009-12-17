//
//  MyResultsTableViewDelegate.h
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sat Aug 16 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuickLite/QuickLiteDatabase.h>
#import <QuickLite/QuickLiteCursor.h>

@interface MyResultsTableViewDelegate : NSObject
{
    IBOutlet NSTableView*	mResultsTableView;
    
    QuickLiteDatabase*		mDatabase;
    QuickLiteCursor*		mCursor;
}

- (void)setDatabase:(QuickLiteDatabase*)database;
- (void)removeTableColumnsFromTableView;
- (void)addEmptyColumn:(NSCell*)cell;

@end

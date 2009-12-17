//
//  MyColumnsTableViewDelegate.h
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sat Aug 16 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuickLite/QuickLiteDatabase.h>

@interface MyColumnsTableViewDelegate : NSObject
{
    IBOutlet NSTableView*	mColumnsTableView;
    
    QuickLiteDatabase*		mDatabase;
    NSArray*			mColumns;
}

- (void)setDatabase:(QuickLiteDatabase*)database;

@end

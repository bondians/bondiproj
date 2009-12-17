//
//  MyColumnsTableViewDelegate.m
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sat Aug 16 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import "MyColumnsTableViewDelegate.h"
#import "Globals.h"
#import <QuickLite/QuickLiteRow.h>

@implementation MyColumnsTableViewDelegate

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(displayColumnsForTable:) name: kSMXTableHasBeenSelected object: nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [mColumns release];
    
    [super dealloc];
}

- (void)setDatabase:(QuickLiteDatabase*)database
{
    mDatabase = database;
}

- (void)displayColumnsForTable:(NSNotification*)notification
{
    NSString* table = [notification object];
    
    if (mColumns != nil) {
        [mColumns release];
        mColumns = nil;
    }
    
    if (table != nil)
        mColumns = [[mDatabase columnsForTable: table] retain];
    
    [mColumnsTableView reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [mColumns count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    return [mColumns objectAtIndex: rowIndex];
}

@end

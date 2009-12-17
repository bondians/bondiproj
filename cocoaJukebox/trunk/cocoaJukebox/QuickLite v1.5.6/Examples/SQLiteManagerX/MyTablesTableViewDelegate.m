//
//  MyTablesTableViewDelegate.m
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sat Aug 16 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import "MyTablesTableViewDelegate.h"
#import "Globals.h"
#import <QuickLite/QuickLiteRow.h>
#import <QuickLite/QuickLiteGlobals.h>

@implementation MyTablesTableViewDelegate

- (void)dealloc
{
    [mTables release];
    
    [super dealloc];
}

- (void)setDatabase:(QuickLiteDatabase*)database
{
    mDatabase = database;
}

- (void)displayDatabaseTables
{
    if (mTables != nil) {
        [mTables release];
        mTables = nil;
    }
    
    NSArray* allTables = [[mDatabase allTables] objectForKey: @"main"];
    if ([allTables containsObject:QLP_SchemaTable]) {
        mTables = [allTables retain];
    } else {
        mTables = [[mDatabase tables] retain];
    }
    
    [mTablesTableView reloadData];
    
    [self notifyTableSelectionHasChanged];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [mTables count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    return [mTables objectAtIndex: rowIndex];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    [self notifyTableSelectionHasChanged];
}

- (void)notifyTableSelectionHasChanged
{
    int selectedRow = [mTablesTableView selectedRow];
    
    if (selectedRow == -1) {
        [[NSNotificationCenter defaultCenter] postNotificationName: kSMXTableHasBeenSelected object: nil];
        [[NSNotificationCenter defaultCenter] postNotificationName: kSMXPerformSQLQuery object: nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName: kSMXTableHasBeenSelected object: [mTables objectAtIndex: selectedRow]];
        
        if ([mTables count]) {
            NSString* queryString = [NSString stringWithFormat: @"SELECT * FROM %@", [mTables objectAtIndex: selectedRow]];
            NSArray* objectArray = [NSArray arrayWithObjects: queryString, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName: kSMXPerformSQLQuery object: objectArray];
            
            [[NSNotificationCenter defaultCenter] postNotificationName: kSMXSQLQueryHasChanged object: queryString];
        }
    }
}

- (void)dropSelectedTable
{
    int selectedRow = [mTablesTableView selectedRow];
    [mDatabase dropTable: [mTables objectAtIndex: selectedRow]];
}

@end

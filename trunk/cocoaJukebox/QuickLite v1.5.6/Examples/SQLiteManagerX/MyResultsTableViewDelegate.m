//
//  MyResultsTableViewDelegate.m
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sat Aug 16 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import "MyResultsTableViewDelegate.h"
#import "Globals.h"
#import <QuickLite/QuickLiteRow.h>

@implementation MyResultsTableViewDelegate

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(clearResultsTableView:) name: kSMXTableHasBeenSelected object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(performQuery:) name: kSMXPerformSQLQuery object: nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [mCursor release];
    
    [super dealloc];
}

- (void)setDatabase:(QuickLiteDatabase*)database
{
    mDatabase = database;
}

- (void)clearResultsTableView:(NSNotification*)notification
{
    NSString* table = [notification object];
    
    if (table == nil) {
        NSArray* tableColumns = [mResultsTableView tableColumns];
        NSCell* cell = [[tableColumns objectAtIndex: 0] dataCell];
        
        [self removeTableColumnsFromTableView];
        [self addEmptyColumn: cell];
        [mResultsTableView sizeLastColumnToFit];
        [mResultsTableView setNeedsDisplay: YES];
    }
}

- (void)performQuery:(NSNotification*)notification
{
    NSString* query = nil;
    NSWindow* sheetWindow = nil;
    NSArray* tableColumns = [mResultsTableView tableColumns];
    NSCell* cell = [[tableColumns objectAtIndex: 0] dataCell];
    
    if ([[notification object] count] >= 1)
        query = [[notification object] objectAtIndex: 0];
    
    if ([[notification object] count] >= 2)
        sheetWindow = [[notification object] objectAtIndex: 1];
    
    [mCursor release];
    mCursor = nil;
    
    if (query != nil) {
        NSArray* columns = nil;
        unsigned int i;
        
        mCursor = [[mDatabase performQuery: query] retain];
        columns = [mCursor columns];
        
        if (columns) {
            [self removeTableColumnsFromTableView];
            
            [cell setWraps: YES];
            
            for (i = 0; i < [columns count]; i++) {
                NSTableColumn* tableColumn = [[NSTableColumn alloc] initWithIdentifier: [columns objectAtIndex: i]];
                [tableColumn setDataCell: cell];
                [[tableColumn headerCell] setStringValue: [columns objectAtIndex: i]];
                [tableColumn sizeToFit];
                [mResultsTableView addTableColumn: tableColumn];
                [tableColumn release];
            }
            
            [mResultsTableView sizeLastColumnToFit];
        } else {
            [self clearResultsTableView: nil];
        }
        
        int SQLiteErrorID = [mDatabase lastErrorID];
        
        if (SQLiteErrorID != QLSuccess) {
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            
            [alert addButtonWithTitle: @"OK"];
            [alert setMessageText: @"There was an error when executing the query"];
            [alert setInformativeText: [NSString stringWithFormat: @"Query: %@\n\nError: %@ (ID %ld)", query, [mDatabase lastError], SQLiteErrorID]];
            [alert setAlertStyle: NSWarningAlertStyle];
            
            [alert beginSheetModalForWindow: sheetWindow modalDelegate: self didEndSelector: nil contextInfo: nil];
        }
    } else {
        [self addEmptyColumn: cell];
    }
    
    [mResultsTableView reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [mCursor rowCount];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    static NSDictionary *info = nil;
    
    if (info == nil) {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode: NSLineBreakByTruncatingMiddle];
        info = [[NSDictionary alloc] initWithObjectsAndKeys: style, NSParagraphStyleAttributeName, nil];
        [style release];
    }
    
    QuickLiteRow* row = [mCursor rowAtIndex: rowIndex];
    return [[[NSAttributedString alloc] initWithString: [row stringForColumn: [aTableColumn identifier]] attributes: info] autorelease];
}

- (void)removeTableColumnsFromTableView
{
    NSArray* tableColumns = [mResultsTableView tableColumns];
    int i;
    
    for (i = [tableColumns count] - 1; i >= 0; i--)
        [mResultsTableView removeTableColumn: [tableColumns objectAtIndex: i]];
}

- (void)addEmptyColumn:(NSCell*)cell
{
    NSTableColumn* tableColumn = [[NSTableColumn alloc] initWithIdentifier: @""];
    
    [tableColumn setDataCell: cell];
    [[tableColumn headerCell] setStringValue: @""];
    [mResultsTableView addTableColumn: tableColumn];
}

@end

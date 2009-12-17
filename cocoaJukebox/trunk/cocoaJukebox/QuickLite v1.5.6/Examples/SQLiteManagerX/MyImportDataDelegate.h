//
//  MyImportDataDelegate.h
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sun Aug 31 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuickLite/QuickLiteDatabase.h>

@interface MyImportDataDelegate : NSObject
{
    IBOutlet NSTextField*           mImportFilePathField;
    IBOutlet NSPopUpButton*         mEncodingsPopup;
    IBOutlet NSTextField*           mColumnDelimiterField;
    IBOutlet NSTextField*           mEndOfRecordDelimiterField;
    IBOutlet NSTextField*           mTableNameField;
    IBOutlet NSButton*              mGenerateTableButton;
    IBOutlet NSButton*              mImportButton;
    IBOutlet NSProgressIndicator*   mProgressIndicator;
    IBOutlet NSTextField*           mStatusField;
    
    QuickLiteDatabase*              mDatabase;
    BOOL                            mImportFileChosen;
    NSMutableDictionary*            mStringEncodings;
}

- (NSDictionary*)encodingTypes;

- (void)buildEncodingsPopup;
- (void)setDatabase:(QuickLiteDatabase*)database;
- (void)validateUI;

- (IBAction)chooseImportFile:(id)sender;
- (IBAction)createTableButtonClicked:(id)sender;
- (IBAction)importFile:(id)sender;
- (IBAction)cancelImport:(id)sender;

@end

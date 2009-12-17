//
//  MyImportDataDelegate.m
//  SQLiteManagerX
//
//  Created by Tito Ciuro on Sun Aug 31 2003.
//  Copyright (c) 2003 Tito Ciuro. All rights reserved.
//

#import "MyImportDataDelegate.h"
#import <QuickLite/QuickLiteDatabase.h>

@implementation MyImportDataDelegate

- (void)awakeFromNib
{
    mImportFileChosen = NO;
    [mProgressIndicator setUsesThreadedAnimation: YES];
    
    [self buildEncodingsPopup];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(textDidChange:) name: NSControlTextDidChangeNotification object: nil];
    
    [self validateUI];
}

- (NSDictionary*)encodingTypes
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject: [NSNumber numberWithLong: NSASCIIStringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSASCIIStringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSNEXTSTEPStringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSNEXTSTEPStringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSJapaneseEUCStringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSJapaneseEUCStringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSISOLatin1StringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSISOLatin1StringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSNonLossyASCIIStringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSNonLossyASCIIStringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSShiftJISStringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSShiftJISStringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSISOLatin2StringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSISOLatin2StringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSWindowsCP1251StringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSWindowsCP1251StringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSWindowsCP1252StringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSWindowsCP1252StringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSWindowsCP1253StringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSWindowsCP1253StringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSWindowsCP1254StringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSWindowsCP1254StringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSWindowsCP1250StringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSWindowsCP1250StringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSISO2022JPStringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSISO2022JPStringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSMacOSRomanStringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSMacOSRomanStringEncoding]];
    [dictionary setObject: [NSNumber numberWithLong: NSProprietaryStringEncoding] forKey: [NSString localizedNameOfStringEncoding: NSProprietaryStringEncoding]];
    
    return dictionary;
}

- (void)buildEncodingsPopup
{
    NSMenu* menu = [mEncodingsPopup menu];
    //NSDictionary* dictEncodings = [self encodingTypes];
    mStringEncodings = [[NSMutableDictionary alloc] init];
    
    const NSStringEncoding* encoding = [NSString availableStringEncodings];
    while (* encoding != 0) {
        NSString* encodingTitle = [NSString localizedNameOfStringEncoding: * encoding];
        [mStringEncodings setObject: [NSNumber numberWithLong: *encoding] forKey: encodingTitle];
        encoding ++;
    }
    
    NSArray* sortedEncodings = [[mStringEncodings allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    unsigned int i;
    for (i = 0; i < [sortedEncodings count]; i++)
        [menu addItemWithTitle: [sortedEncodings objectAtIndex: i] action: nil keyEquivalent: @""];
    [menu removeItemAtIndex: 0];
    
    NSString* macOSRomanString = [NSString localizedNameOfStringEncoding: NSMacOSRomanStringEncoding];
    [mEncodingsPopup selectItemWithTitle: macOSRomanString];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [mStringEncodings release];
    
    [super dealloc];
}

- (void)setDatabase:(QuickLiteDatabase*)database
{
    mDatabase = database;
}

- (void)validateUI
{
    BOOL importCanBegin = YES;
    
    if (mImportFileChosen == NO)
        importCanBegin = NO;
    
    int delimiter = [mColumnDelimiterField intValue];
    if ((delimiter < 0) || (delimiter > 127))
        importCanBegin = NO;
    
    delimiter = [mEndOfRecordDelimiterField intValue];
    if ((delimiter < 0) || (delimiter > 127))
        importCanBegin = NO;
    
    if (([mGenerateTableButton intValue] == 1) && ([[mTableNameField stringValue] isEqualToString: @""]))
        importCanBegin = NO;
    
    [mImportButton setEnabled: (importCanBegin == YES)];
}

- (IBAction)chooseImportFile:(id)sender
{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    // Configure the panel
    [openPanel setCanChooseFiles: YES];
    [openPanel setCanChooseDirectories: NO];
    [openPanel setResolvesAliases: YES];
    [openPanel setAllowsMultipleSelection: NO];
    
    int result = [openPanel runModalForTypes: nil];
    if (result == NSOKButton) {
        mImportFileChosen = YES;
        [mImportFilePathField setStringValue: [[openPanel filenames] objectAtIndex: 0]];
        
        [mTableNameField setStringValue: [[[mImportFilePathField stringValue] lastPathComponent] stringByDeletingPathExtension]];
        
        [self validateUI];
    }
}

- (IBAction)createTableButtonClicked:(id)sender
{
    [mTableNameField setEnabled: ([sender intValue] == 1)];
    [self validateUI];
}

- (IBAction)importFile:(id)sender
{
    int index = [mEncodingsPopup indexOfSelectedItem];
    NSString* encodingTitle = [[mEncodingsPopup itemAtIndex: index] title];
    NSDictionary* dictEncodings = [self encodingTypes];
    NSStringEncoding encoding = [[dictEncodings objectForKey: encodingTitle] longValue];
    
    [mProgressIndicator startAnimation: self];
    [mStatusField setStringValue: @"Importing data..."];
    
    QLImportResult result = [mDatabase importFromFile: [mImportFilePathField stringValue] encoding: encoding columnDelimiter: [mColumnDelimiterField stringValue] endOfRecord: [mEndOfRecordDelimiterField stringValue] table: [mTableNameField stringValue] dropTableIfItExistsAndRecreate: ([mGenerateTableButton intValue] == 1) clearTableContentsBeforeImporting: YES];
    
    [mProgressIndicator stopAnimation: self];
    
    if (result != QLImportOK) {
        NSString* reason = nil;
        
        switch (result) {
            case QLImportFilePathNotFound:
                reason = @"file path not valid.";
                break;
            case QLImportFilePathIsDirectory:
                reason = @"import file is a directory.";
                break;
            case QLImportFilePathCouldNotBeOpened:
                reason = @"import file couldn't be opened.";
                break;
            case QLImportFileEncodingNotValid:
                reason = @"encoding not valid.";
                break;
            case QLImportFileColumnsNotFound:
                reason = @"import file columns not found.";
                break;
            case QLImportFileColumnEmpty:
                reason = @"import file title column found empty.";
                break;
            case QLImportFileTableNotFound:
                reason = @"table name doesn't exist in the database.";
                break;
            case QLImportFileColumnNameContainsSpace:
                reason = @"import file column contains a space.";
                break;
            case QLImportColumnsNonConforming:
                reason = @"import file table columns do not conform to the database.";
                break;
            case QLImportDataNonConforming:
                reason = @"import file data do not conform to the columns.";
                break;
            default:
                reason = @"unknown reason.";
                break;
        }
        
        NSRunInformationalAlertPanel(   @"Importing not successful",
                                        [NSString stringWithFormat: @"An unexpected error occurred while attempting to import the file named %@: %@", [mImportFilePathField stringValue], reason],
                                        @"OK",
                                        nil,
                                        nil);
    } else {
        [NSApp stopModalWithCode: NSOKButton];
        
        NSRunInformationalAlertPanel(   @"Imported finished successfully",
                                        [NSString stringWithFormat: @"The contents of file named %@ have been imported.", [mImportFilePathField stringValue]],
                                        @"OK",
                                        nil,
                                        nil);
    }
}

- (IBAction)cancelImport:(id)sender
{
    [NSApp stopModal];
}

- (void)textDidChange:(NSNotification *)aNotification
{
    [self validateUI];
}

@end

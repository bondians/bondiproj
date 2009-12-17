/* MyController */

#import <Cocoa/Cocoa.h>

@interface MyController : NSObject
{
    IBOutlet NSButton *closeButton;
    IBOutlet NSButton *openButton;
    IBOutlet NSButton *clearButton;
    IBOutlet NSTextField *statusText;
    IBOutlet NSTableView *tableView;
    IBOutlet NSWindow *window;
    
    NSString* path;
    NSMutableArray* log;
}

- (IBAction)closeDatabase:(id)sender;
- (IBAction)openDatabase:(id)sender;
- (IBAction)clearLog:(id)sender;

- (void)refreshUI;
- (void)addEntryToLog:(NSDictionary*)info;

@end

/* MyController */

#import <Cocoa/Cocoa.h>

#import <QuickLite/QuickLiteDatabase.h>

@interface MyController : NSObject
{
    QuickLiteDatabase   *_db;
}

-(IBAction)runTests:(id)sender;

@end

/* MyController */

#import <Cocoa/Cocoa.h>

#import <QuickLite/QuickLiteDatabase.h>

@interface MyController : NSObject
{
    IBOutlet NSButton *chooseButton;
    IBOutlet NSImageView *decodedImage;
    IBOutlet NSImageView *originalImage;
    IBOutlet NSButton *showButton;
    IBOutlet NSTextField *encodeTextField;
	
    QuickLiteDatabase* db;
}

- (IBAction)chooseFileAction:(id)sender;
- (IBAction)showImageAction:(id)sender;
- (void)setImage:(NSImage*)image inView:(NSImageView*)imageView;

@end

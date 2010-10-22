#import <Foundation/Foundation.h>

#define distributedNotificationCenter [NSDistributedNotificationCenter defaultCenter]
#define kJookieSkipCurrentSong		@"jookieSkipCurrentSong"


int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        
        NSString *argument = [args stringForKey:@"action"];
        
        if (argument == nil)
        {
            NSLog(@"A command Line Argument is required:\n-action skipsong\n-action stop\n-action start");
        }
        
	if ( [argument isEqualToString: @"skipsong"] )
	[distributedNotificationCenter postNotificationName: kJookieSkipCurrentSong
												 object: nil userInfo: nil deliverImmediately: YES];
	
    [pool drain];
    return 0;
}

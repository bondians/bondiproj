#import <Foundation/Foundation.h>

#define distributedNotificationCenter [NSDistributedNotificationCenter defaultCenter]
#define kJookiePlayerSkip			@"jookiePlayerSkip"
#define kJookiePlayerStartStop		@"jookiePlayerStartStop"
#define kJookiePlayerPause			@"jookiePlayerPause"




int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        
        NSString *argument = [args stringForKey:@"action"];
        
        if (argument == nil)
        {
            NSLog(@"A command Line Argument is required:\n-action skipsong\n-action startstop\n-action pause");
        }
        
	if ( [argument isEqualToString: @"skipsong"] )
	{
		
		[distributedNotificationCenter postNotificationName: kJookiePlayerSkip
							object: nil userInfo: nil deliverImmediately: YES];
	}
	
	if ( [argument isEqualToString: @"startstop"] )
	{
		[distributedNotificationCenter postNotificationName: kJookiePlayerStartStop
							object: nil userInfo: nil deliverImmediately: YES];
	}
	if ( [argument isEqualToString: @"pause"] )
	{
		[distributedNotificationCenter postNotificationName: kJookiePlayerPause
							object: nil userInfo: nil deliverImmediately: YES];
	}
	
	
    [pool drain];
    return 0;
}

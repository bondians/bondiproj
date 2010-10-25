#import <Foundation/Foundation.h>

#define distributedNotificationCenter [NSDistributedNotificationCenter defaultCenter]
#define kJookiePlayerSkip			@"jookiePlayerSkip"
#define kJookiePlayerStartStop		@"jookiePlayerStartStop"
#define kJookiePlayerPause			@"jookiePlayerPause"
#define kJookiePlayerSetVolume		@"jookiePlayerSetVolume"




int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        
	NSString *argument = [args stringForKey:@"action"];
	NSDictionary *dict;
	NSNumber *volume = [NSNumber numberWithFloat: [args floatForKey:@"volume"]];
        
	if (argument == nil && volume == nil)
	{
		NSLog(@"A command Line Argument is required:\n-action skipsong\n-action startstop\n-action pause\n-volume <float 0.0 - 1.0>");
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
	
	if (volume)
	{
		NSLog(@"volume was %f", [volume floatValue]);
		dict = [NSDictionary dictionaryWithObjectsAndKeys:
				volume,
				@"volume",
				nil];
		[distributedNotificationCenter postNotificationName: kJookiePlayerSetVolume
									   object: nil userInfo: dict deliverImmediately: YES];
		NSLog(@"volume was %f", [[dict objectForKey: @"volume"] floatValue]);

	//	[distributeNotificationCenter
	}
	
	
    [pool drain];
    return 0;
}

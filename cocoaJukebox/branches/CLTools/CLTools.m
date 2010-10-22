#import <Foundation/Foundation.h>

#define distributedNotificationCenter [NSDistributedNotificationCenter defaultCenter]
#define kJookieSkipCurrentSong		@"jookieSkipCurrentSong"


//proof of concept will want to make this accept a single argument that tells it what msg tosend
//i.e. jookieControl --skip (simple shift on ARGV to get first CL option)
//this a version with all components can just ga and reside in rails
//i'll put this stub there for now

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	// need to sanitize and check for presence of argv[1] otherwise we are crashing
	NSString *argument = [NSString stringWithUTF8String: argv[1]];
	//NSLog (@"you sent: %@", argument);
	if ( [argument isEqualToString: @"--skip"] )
	[distributedNotificationCenter postNotificationName: kJookieSkipCurrentSong
												 object: nil userInfo: nil deliverImmediately: YES];
	
    [pool drain];
    return 0;
}

#import "JukeboxController.h"
#import "PhantomSongQueue.h"

#define notificationCenter [NSNotificationCenter defaultCenter]

@implementation JukeboxController

+ (void) initialize

{
	NSMutableDictionary *appDefaults;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	appDefaults = [[[NSMutableDictionary alloc] init] autorelease];
	
	// advanced preferences
	
	[appDefaults setValue: @"/"								forKey: @"kPathToArchive"];
	[appDefaults setValue: @"http://127.0.0.1:3000"			forKey: @"kUrlRoot"];
	[appDefaults setValue: [NSNumber numberWithBool:YES]	forKey: @"kFadeIsOn"];
	[appDefaults setValue: @"6.0"							forKey: @"kDefaultFadeDuration"];
	[appDefaults setValue: [NSNumber numberWithBool:YES]	forKey: @"kRespectIndividualFadeDurations"];
	[appDefaults setValue: [NSNumber numberWithBool:YES]	forKey: @"kRespectSongHinting"];
	[appDefaults setValue: [NSNumber numberWithBool:YES]	forKey: @"kRespectSongFadeIn"];
	[appDefaults setValue: [NSNumber numberWithBool:NO]		forKey: @"kSongAlwaysFadeIn"];
	//[appDefaults setValue: @"deepbondi"				forKey: @"kDefaultPlayList"];
	[appDefaults setValue: [NSNumber numberWithBool:NO]		forKey: @"kStartPlaybackOnLaunch"];
	//[appDefaults setValue: @"/archive/mp3.db"       forKey: @"kPathToDatabase"];

	[defaults registerDefaults: appDefaults];
	[defaults synchronize];
	
}

- ( void ) awakeFromNib
{
	[JukeboxController initialize];
}

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification
{
	NSLog (@"App did finish launching");	

	//debug stuff
	//NSZombieEnabled = YES;
	// end debug stuff

	mySongQueue = [[PhantomSongQueue alloc] init];
	//[mySongQueue setProgressIndicator: playListLoader];
	myMusicPlayer = [[DBMusicPlayer musicPlayerWithPlayList: mySongQueue] retain];
	[self registerForNotifications];

	durationTimer = [[NSTimer scheduledTimerWithTimeInterval: 0.5
	target: self selector: @selector(updateTimeDisplay) userInfo: nil repeats: YES] retain];
}

- (IBAction) playerStartStop: (id) sender
{
	[myMusicPlayer toggleStartStop];
}

- (IBAction) skip: (id) sender
{
	[myMusicPlayer skipSong];
}

- (IBAction) pause: (id) sender {
	[myMusicPlayer pauseSong];
}

- (void) playerDidPause: (NSNotification *) aNotification
{
	[pauseResume setTitle: @"Resume"];
	//[pauseResume highlight: YES];
	
}

- (void) playerDidResumeFromPause: (NSNotification *) aNotification
{
	[pauseResume setTitle: @"Pause"];
	//[pauseResume highlight: NO];
}

- (void) playerDidStart: (NSNotification *) aNotification
{
	[startStop setTitle: @"Stop"];
}

- (void) playerDidStop: (NSNotification *) aNotification
{
	[startStop setTitle: @"Start"];
}

- (NSString *) doubleToTime: (double) time
{
	int itime;
	int minutes, seconds;

	itime = lrint(time);
	seconds = itime % 60;
	minutes = itime / 60;

	return [NSString stringWithFormat: @"%02d:%02d", minutes, seconds];
}

- (void) songDidChange: (NSNotification *) aNotification
{
	NSTimeInterval playTime;

	NSLog(@"songDidChange: %@", [myMusicPlayer currentSong]);

	[[myMusicPlayer currentSongLock] lock];
	if ([myMusicPlayer currentSong] && [myMusicPlayer serverRunning]) {
		QTGetTimeInterval([[[myMusicPlayer currentSong] movie] duration], &playTime);
		[dbKeyDisplay setStringValue: [[myMusicPlayer currentSong] key]];
		[songNameDisplay setStringValue: [[myMusicPlayer currentSong] title]];
		[songArtistDisplay setStringValue: [[myMusicPlayer currentSong] artist]];
		[songTimeDisplay setStringValue: [self doubleToTime: playTime]];
	}
	else {
		[dbKeyDisplay setStringValue: @"000000"];
		[songNameDisplay setStringValue: @"-- Stopped --"];
		[songArtistDisplay setStringValue: @"-- Stopped --"];
		[songTimeDisplay setStringValue: @"00:00"];
	}
	[[myMusicPlayer currentSongLock] unlock];
}

- (IBAction) showPreferences:(id)sender
{
	[[[prefsPanel tabView] window] makeKeyAndOrderFront:sender];
}

- (void) updateTimeDisplay
{
	NSTimeInterval currentTime;
	NSTimeInterval playTime;
//	if ([[myMusicPlayer currentSongLock] tryLock]){
		if ([myMusicPlayer currentSong]) {
			QTGetTimeInterval([[[myMusicPlayer currentSong] movie] currentTime], &currentTime);
			QTGetTimeInterval([[[myMusicPlayer currentSong] movie] duration], &playTime);
			[songTimeDisplay setStringValue: [self doubleToTime: playTime - currentTime]];
		}
//		[[myMusicPlayer currentSongLock] unlock];
//	}
}

- (void) registerForNotifications
{
	//- (void)addObserver:(id)anObserver selector:(SEL)aSelector name:(NSString *)notificationName object:(id)anObject
	
	[notificationCenter addObserver: self selector:@selector(playerDidStart:) 
							   name: kPlayerDidStart object: myMusicPlayer];
	[notificationCenter addObserver: self selector:@selector(playerDidStop:) 
							   name: kPlayerDidStop object: myMusicPlayer];
	[notificationCenter addObserver: self selector:@selector(playerDidPause:) 
							   name: kPlayerDidPause object: myMusicPlayer];
	[notificationCenter addObserver: self selector:@selector(playerDidResumeFromPause:) 
							   name: kPlayerDidResumeFromPause object: myMusicPlayer];
	[notificationCenter addObserver: self selector:@selector(songDidChange:) 
							   name: kSongDidChange object: myMusicPlayer];

}
/*
#define kPlayerDidStart				@"playerDidStart"
#define kPlayerDidStop				@"playerDidStop"
#define kPlayerDidPause				@"playerDidPause"
#define kPlayerDidResumeFromPause	@"playerDidResumeFromPause"
 */

@end
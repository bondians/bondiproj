#import "JukeboxController.h"
#import "SongQueue.h"

#define notificationCenter [NSNotificationCenter defaultCenter]

@implementation JukeboxController

+ (void) initialize
{
	[super initialize];
	NSMutableDictionary *appDefaults;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	appDefaults = [[[NSMutableDictionary alloc] init] autorelease];
	
	// advanced preferences
	
	//[appDefaults setValue: @"/Volumes" forKey: @"kPathToArchive"];
	//[appDefaults setValue: @"YES"       forKey: @"kFadeIsOn"];
	//[appDefaults setValue: @"6.0"       forKey: @"kDefaultFadeDuration"];
	//[appDefaults setValue: @"NO"       forKey: @"kRespectIndividualFadeDurations"];
	//[appDefaults setValue: @"NO"       forKey: @"kRespectSongHinting"];
	//[appDefaults setValue: @"NO"       forKey: @"kRespectSongFadeIn"];
	//[appDefaults setValue: @"NO"       forKey: @"kSongAlwaysFadeIn"];
	//[appDefaults setValue: @"deepbondi" forKey: @"kDefaultPlayList"];
	//[appDefaults setValue: @"NO"        forKey: @"kStartPlaybackOnLaunch"];
	[appDefaults setValue: @"/archive/mp3.db"       forKey: @"kPathToDatabase"];

	[defaults registerDefaults: appDefaults];
	
}

- ( void ) awakeFromNib
{
	[JukeboxController initialize];

	//prefsPanel = [[UKPrefsPanel alloc] init];
	//[prefsPanel awakeFromNib];
}

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification
{
	NSLog (@"App did finish launching");	

	//debug stuff
	//NSZombieEnabled = YES;
	// end debug stuff
	myConnection = [[SQInterface alloc] init];
	mySongQueue = [[SongQueue alloc] init];
	[mySongQueue setProgressIndicator: playListLoader];
	myMusicPlayer = [[DBMusicPlayer musicPlayerWithPlayList: mySongQueue] retain];
	userPlayList = [[UserPlayList playListWithList: [myConnection getUserSongLists]] retain];
	[userPlayListsTableView setDataSource: userPlayList];
	myNetworkManager = [[JBNetworkManager alloc] initWithPlayer: myMusicPlayer];
	[self registerForNotifications];
	testSong = nil;

	durationTimer = [[NSTimer scheduledTimerWithTimeInterval: 0.5
	target: self selector: @selector(updateTimeDisplay) userInfo: nil repeats: YES] retain];
}

- (IBAction) setPlayList: (id) sender
{
	NSMutableArray *myArray = [[[NSMutableArray alloc] init] autorelease];
	int i = 0;

	{
		NSIndexSet *selectedRows = [userPlayListsTableView selectedRowIndexes];
		int selectedItemIndex;
		
		//user didn't double click a row
		if (!selectedRows)
			return; 
		
		if ((selectedItemIndex = [selectedRows firstIndex]) == NSNotFound)
			return;
		
		do {
			[myArray addObject: [userPlayList objectForIndex: selectedItemIndex]];
			i += [userPlayList countForIndex: selectedItemIndex];
		} while ((selectedItemIndex = [selectedRows indexGreaterThanIndex:selectedItemIndex]) != NSNotFound);
	}

	if (! [additive state])
		[mySongQueue dumpRandomList];

	[mySongQueue setRandomList: myArray];
	NSLog(@"controller randomlist was successfully set");
	[mySongQueue refreshRandomQueue];
}

- (IBAction) dumpPlayList: (id) sender
{
	[mySongQueue dumpRandomList];
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

- (IBAction) testStuff: (id) sender
{
	QTTime aTime;
	NSTimeInterval currentTime;
	NSTimeInterval duration;
	double aNumber = 0;
	
	
	QTGetTimeInterval([[[myMusicPlayer currentSong] movie] duration], &duration);
	QTGetTimeInterval([[[myMusicPlayer currentSong] movie] currentTime], &currentTime);
	
	aNumber = duration - 20;
	
	aTime = QTMakeTimeWithTimeInterval(aNumber);
	
	[[[myMusicPlayer currentSong] movie] setCurrentTime: aTime];
}

- (IBAction)request:(id)sender
{
	[mySongQueue requestSong: [myConnection getSongForKey: [requestNumber objectValue]]];
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

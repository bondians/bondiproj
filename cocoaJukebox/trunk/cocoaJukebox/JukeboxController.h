/* JukeboxController */

#import <Cocoa/Cocoa.h>
#import <math.h>
#import "SQInterface.h"
#import "SongQueue.h"
#import "DBSong.h"
#import "DBMusicPlayer.h"
#import "UserPlayList.h"
#import "JBNetworkManager.h"
#import "UKPrefsPanel.h"

// debug
// #import <Foundation/NSDebug.h>

@interface JukeboxController : NSObject
{
	//debug stuff
	
	//UKPrefsPanel *prefsPanel;
	JBNetworkManager *myNetworkManager;
	SQInterface *myConnection;
	SongQueue *mySongQueue;
	DBMusicPlayer *myMusicPlayer;
	UserPlayList *userPlayList;
	IBOutlet NSTableView *userPlayListsTableView;
	IBOutlet NSTextField *requestNumber;
	IBOutlet NSButton *startStop;
	IBOutlet NSButton *pauseResume;
	IBOutlet NSButton *additive;
	IBOutlet NSProgressIndicator *playListLoader;
    IBOutlet NSTextField *songArtistDisplay;
    IBOutlet NSTextField *songNameDisplay;
    IBOutlet NSTextField *songTimeDisplay;
	IBOutlet NSTextField *dbKeyDisplay;
	IBOutlet UKPrefsPanel *prefsPanel;
	NSTimer *durationTimer;
	DBSong *testSong;
}

+ (void) initialize;

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification;
- (IBAction) playerStartStop: (id) sender;
- (IBAction) pause: (id) sender;
- (IBAction) skip: (id) sender;
- (IBAction) setPlayList: (id) sender;
- (IBAction) dumpPlayList: (id) sender;
- (IBAction) request: (id) sender;
- (IBAction) testStuff: (id) sender;
- (IBAction) showPreferences: (id) sender;

- (void) playerDidPause: (NSNotification *) aNotification;
- (void) playerDidResumeFromPause: (NSNotification *) aNotification;
- (void) playerDidStart: (NSNotification *) aNotification;
- (void) playerDidStop: (NSNotification *) aNotification;
- (void) songDidChange: (NSNotification *) aNotification;

- (void) registerForNotifications;
- (void) updateTimeDisplay;

@end

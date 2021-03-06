//
//  DBMusicPlayer.h
//  cocoaJukebox
//
//  Created by David Henderson & Mark Schultz on 10/5/05.
//  Copyright 2005 Deep Bondi. All rights reserved.
//
//  Based on previous concepts by 
//  James Cook, Dave and Mark
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import "SongQueue.h"
#import "DBSong.h"

#define kPlayerDidStart				@"playerDidStart"
#define kPlayerDidStop				@"playerDidStop"
#define kPlayerDidPause				@"playerDidPause"
#define kPlayerDidResumeFromPause	@"playerDidResumeFromPause"
#define kSongDidChange              @"songDidChange"

@interface DBMusicPlayer : NSObject
{
	BOOL serverIsRunning;
	BOOL songIsPaused;
	BOOL songsShouldFade;
	float defaultFadeDuration;
	BOOL respectIndividualFadeDurations;
	BOOL respectIndividualFadeIn;
	BOOL alwaysFadeIn;
	
	NSUserDefaultsController *defaultsController;
	
	SongQueue *mySongQueue;
	NSNotification *aNotification;
	DBSong *currentSong;
	DBSong *nextSong;
	NSLock *currentSongLock;
	
	NSTimer *fadeManagerTimer;
	
	int fadeManagerState;
//	NSError *myError;
}

+ (id) musicPlayerWithPlayList: (SongQueue *) aPlayList;
- (id) initWithPlayList: (SongQueue *) aPlayList;
- (void) setPlayList: (SongQueue *) aPlayList;
- (SongQueue *) songQueue;
- (void) QTMovieDidEndNotification: (NSNotification *) notification;
- (id) init;
- (id) initWithPlayList: (SongQueue *) aPlayList;
- (void) fadeManager;
- (void) dumpOldSong;
- (void) toggleStartStop;
- (void) stopWithAlert: (NSString *) reason;
- (void) skipSong;
- (void) pauseSong;
- (void) setVolume: (float) volume;
- (float) getVolume;
- (BOOL) serverRunning;
- (NSString *) currentSongKey;
- (DBSong *) currentSong;
- (NSLock *) currentSongLock;

@end



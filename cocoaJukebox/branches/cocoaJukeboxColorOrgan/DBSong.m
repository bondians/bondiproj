//
//  DBSong.m
//  cocoaJukebox
//
//  Created by David Henderson & Mark Schultz on 9/30/05.
//  Copyright 2005 Deep Bondi. All rights reserved.
//
//  Based on previous concepts by 
//  James Cook, Dave and Mark
//

#import "DBSong.h"

@implementation DBSong

- (id) init
{
    if ((self = [super init]) != nil) {
        key = nil;
        title = nil;
        artist = nil;
        album = nil;
        path = nil;
        myMovie = nil;
        preQueueKey = nil;
        postQueueKey = nil;
        songShouldFadeIn = YES;
        isPlaying = NO;
        isFading = NO;
        mySongFadeDuration = -1;
        myVolume = 0.7;
        songFadeInDuration = 0.0;
        songFadeOutDuration = 0.0;
        fadeEndTime = 0.0;
    }

    return self;
}


- (id) initWithKey: (NSString *) aKey title: (NSString *) aTitle 
           artist: (NSString *) anArtist album: (NSString *) anAlbum path: (NSString *) aPath
{
    if (! [self init])
        return nil;

    key =    [aKey retain];
    title =  [aTitle retain];
    artist = [anArtist retain];
    album =  [anAlbum retain];
    path =   [aPath retain];

    return self;
}

- (BOOL) loadSong
{
    NSLog(@"\n Loadsong again?\n");
//    NSError *anError;
    if (myMovie)
    {
        return (myMovie != nil);
    }
//    if ( [QTMovie canInitWithFile: [self path]] )
//    {
//        myMovie = [[QTMovie movieWithFile: [self path] error: &anError] retain];
//    }
    myMovie = [[QTMovie alloc] initWithFile: [self path] error: nil];
//    if (anError != nil) NSLog([anError localizedDescription]);
    //NSLog(@"Title: %@\n string duration: %@, string currentTime: %@",[self title], QTStringFromTime([myMovie duration]), QTStringFromTime([myMovie currentTime]));
    
    return (myMovie != nil);
}

- (void) dealloc {
    [self unbind: @"masterVolume"];
//    [myMovie autorelease];
    [key release];
    [title release];
    [artist release];
    [album release];
    [path release];
    [preQueueKey release];
    [postQueueKey release];
    [defaultsController release];
    [myMovie stop];
    [myMovie release];
    [super dealloc];
}

- (BOOL) play
{
    NSLog(@"play entered");
    if (isPlaying) {
        return YES;
    }

    
    if ([self loadSong])
    {
        [myMovie play];
        isPlaying = YES;
        return YES;
    }

    isPlaying = NO;
    return NO;
}

- (BOOL) startPlaybackWithFade: (double) fadeInTime
{

    if ([self loadSong]) {
        songFadeInDuration = fadeInTime;
        [myMovie setVolume: 0.0];

        isPlaying = YES;
        [myMovie play];

        return YES;
    }

    return NO;
}

- (void) fadeOutNow: (bool) immediatly length: (double) fadeDuration
{
    double songDuration;
    double currentTime;
    isFading = YES;
    if (fadeDuration <= 0.01) {
        [myMovie setVolume: 0.0];
        [[NSNotificationCenter defaultCenter]
            postNotificationName: kDBSongDidEndNotification
            object: self];
            return;
    }

    QTGetTimeInterval([myMovie currentTime], &currentTime);
    QTGetTimeInterval([myMovie duration], &songDuration);

    songFadeOutDuration = fadeDuration;
    if (immediatly) {
        fadeEndTime = currentTime + fadeDuration;
    }
    else {
        fadeEndTime = songDuration;
    }

    if (fadeEndTime > songDuration) {
        fadeEndTime = songDuration;
        songFadeOutDuration = songDuration - currentTime;
    }
}

- (void) updateVolume: (float) masterVolume
{
	if (! isPlaying) return;
    //NSLog(@"updateVolume entered");
    double currentTime;
    float computed = (myVolume * masterVolume);
    float newVolume = 0.0;

    if (myMovie != nil)
    {
        currentTime = [self currentTime];
        if (songFadeInDuration > 0.0 && currentTime <= songFadeInDuration)
        {
            newVolume = computed * currentTime / songFadeInDuration;
        }
        else if (songFadeOutDuration > 0.0 && fadeEndTime > 0.0 && songFadeOutDuration >= (fadeEndTime - currentTime))
        {
            newVolume = computed * (fadeEndTime - currentTime) / songFadeOutDuration;
        }
        else
        {
            newVolume = computed;
        }
        
        if (newVolume > computed)
        {
            newVolume = computed;
        }
        if (fadeEndTime > 0.0 && (fadeEndTime - currentTime) < 0.1 )
        {
            NSLog(@"posting and exiting from DBSong");
            [myMovie stop];
			isPlaying = NO;
            [[NSNotificationCenter defaultCenter]
            postNotificationName: kDBSongDidEndNotification
            object: self];
            return;
        }
        //NSLog(@"updating volume for: %@ from:%f to: %f",title, [myMovie volume], newVolume);
		newVolume = newVolume < 1.0 ? newVolume : 1.0; // sanity check.. because inSanity was possible.. believe me.
        [myMovie setVolume: newVolume];
    }
}

- (void) stop
{
    [myMovie stop];
    isPlaying = NO;
}

- (QTMovie *) movie
{
    return myMovie;
}

- (NSString *) key
{
    return key;
}

- (void) setKey: (NSString *) aKey
{
    [key release];
    key = aKey;
    [key retain];
}

- (NSString *) title
{
    return title;
}

- (void) setTitle: (NSString *) aTitle
{
    [title release];
    title = aTitle;
    [title retain];
}

- (NSString *) artist
{
    return artist;
}

- (void) setArtist: (NSString *) anArtist
{
    [artist release];
    artist = anArtist;
    [artist retain];
}

- (NSString *) album
{
    return album;
}

- (void) setAlbum: (NSString *) anAlbum
{
    [album release];
    album = anAlbum;
    [album retain];
}

- (NSString *) path
{
    return path;
}

- (void) setPath: (NSString *) aPath
{
    [path release];
    path = aPath;
    [path retain];
}

- (NSString *) preQueueKey
{
    return preQueueKey;
}
- (void) setPreQueueKey: (NSString *) aKey
{
    [preQueueKey release];
    preQueueKey = aKey;
    [preQueueKey retain];
}

- (NSString *) postQueueKey
{
    return postQueueKey;
}
- (void) setPostQueueKey: (NSString *) aKey
{
    [postQueueKey release];
    postQueueKey = aKey;
    [postQueueKey retain];
}


- (float) volume
{
    return myVolume;
}

- (void) setVolume: (float) vol
{
    if (myMovie) [myMovie setVolume: vol];
    myVolume = vol;
}

- (BOOL) songShouldFadeIn
{
    return songShouldFadeIn;
}

- (void) setSongShouldFadeIn: (BOOL) aBool
{
    songShouldFadeIn = aBool;
}

- (void) setSongFadeDuration: (double) duration
{
    mySongFadeDuration = duration;
}

- (double) songFadeDuration
{
    return mySongFadeDuration;
}

- (int) hash
{
    return [[self key] intValue];
}

- (BOOL) isEqual: (id) anObject
{
    BOOL Equal = NO;

    if ([[self key] isEqual: [anObject key]]) Equal = YES;

    return Equal;
}

- (double) currentTime
{
    NSTimeInterval currentTime;
    if (myMovie)
    {
    QTGetTimeInterval([myMovie currentTime], &currentTime);
    return currentTime;
    }
    return kNoSong;
}

- (double) timeLeft
{
    if (myMovie) {
        NSTimeInterval currentTime;
        NSTimeInterval duration;

        QTGetTimeInterval([myMovie duration], &duration);
        QTGetTimeInterval([myMovie currentTime], &currentTime);
        return duration-currentTime;
    }

    return kNoSong;
}

- (double) timeToFade
{    
    if (myMovie) {
        NSTimeInterval currentTime;
        NSTimeInterval duration;

        QTGetTimeInterval([myMovie duration], &duration);
        QTGetTimeInterval([myMovie currentTime], &currentTime);
        return duration - currentTime - mySongFadeDuration;
    }

    return kNoSong;
}

- (double) halfTimeToFade
{
    if (myMovie) {
        NSTimeInterval currentTime;
        NSTimeInterval duration;

        QTGetTimeInterval([myMovie duration], &duration);
        QTGetTimeInterval([myMovie currentTime], &currentTime);
        return duration - currentTime - (mySongFadeDuration / 2);
    }

    return kNoSong;
}

-(BOOL) isPlaying
{
    return isPlaying;
}
-(BOOL) isFading
{
    return isFading;
}

//KVC Stuff
- (id) valueForKey: (NSString *) someKey
{
    if ([someKey isEqualToString: @"key"] || [someKey isEqualToString: @"Key"])
        return key;
    return key;
}


@end

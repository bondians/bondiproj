//
//  SpaceAlertRMGAppDelegate.m
//  SpaceAlertRMG
//
//  Created by David Henderson on 6/2/11.
//  Copyright 2011 AUHSD. All rights reserved.
//

#import "SpaceAlertRMGAppDelegate.h"

@implementation SpaceAlertRMGAppDelegate

@synthesize window;


+ (void)initialize

{
	NSMutableDictionary *appDefaults;

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	appDefaults = [[[NSMutableDictionary alloc] init] autorelease];

        [appDefaults setValue: @"8"                          forKey: @"kMinMissionThreatLevel"];
        [appDefaults setValue: @"8"                          forKey: @"kMaxMissionThreatLevel"];

        [appDefaults setValue: @"1"                          forKey: @"kMinUnconfirmedThreatLevel"];
        [appDefaults setValue: @"1"                          forKey: @"kMaxUnconfirmedThreatLevel"];

        [appDefaults setValue: @"0"                          forKey: @"kMinRangeUnconfirmedInternalThreat"];
        [appDefaults setValue: @"1"                          forKey: @"kMaxRangeUnconfirmedInternalThreat"];
        [appDefaults setValue: @"1"                          forKey: @"kThresholdUnconfirmedInternalThreat"];

        [appDefaults setValue: @"0"                          forKey: @"kMinRangeSeriousThreat"];
        [appDefaults setValue: @"2"                          forKey: @"kMaxRangeSeriousThreat"];
        [appDefaults setValue: @"2"                          forKey: @"kThresholdSeriousThreat"];

        [appDefaults setValue: @"1"                          forKey: @"kMinInternalThreatLevel"];
        [appDefaults setValue: @"3"                          forKey: @"kMaxInternalThreatLevel"];

        [appDefaults setValue: @"2"                          forKey: @"kMinIncomingData"];
        [appDefaults setValue: @"3"                          forKey: @"kMaxIncomingData"];

        [appDefaults setValue: @"3"                          forKey: @"kMinDataTransfer"];
        [appDefaults setValue: @"4"                          forKey: @"kMaxDataTransfer"];

        [appDefaults setValue: @"45"                         forKey: @"kMinTotalCommunicationFailureDuration"];
        [appDefaults setValue: @"60"                         forKey: @"kMaxTotalCommunicationFailureDuration"];

        [appDefaults setValue: @"9"                          forKey: @"kMinSingleCommunicationFailureDuration"];
        [appDefaults setValue: @"20"                         forKey: @"kMaxSingleCommunicationFailureDuration"];

        [appDefaults setValue: @"205"                        forKey: @"kMinPhaseOneDuration"];
        [appDefaults setValue: @"240"                        forKey: @"kMaxPhaseOneDuration"];

        [appDefaults setValue: @"180"                        forKey: @"kMinPhaseTwoDuration"];
        [appDefaults setValue: @"225"                        forKey: @"kMaxPhaseTwoDuration"];

        [appDefaults setValue: @"140"                        forKey: @"kMinPhaseThreeDuration"];
        [appDefaults setValue: @"155"                        forKey: @"kMaxPhaseThreeDuration"];

        [appDefaults setValue: @"0"                          forKey: @"kMinTimeToFirstConfirmedThreat"];
        [appDefaults setValue: @"3500"                       forKey: @"kMaxTimeToFirstConfirmedThreat"];

	[defaults registerDefaults: appDefaults];
	[defaults synchronize];

	/* advanced preferences
	[appDefaults setValue: @"/"				forKey: @"kPathToArchive"];
	[appDefaults setValue: @"http://127.0.0.1:3000"		forKey: @"kUrlRoot"];
	[appDefaults setValue: [NSNumber numberWithBool:YES]	forKey: @"kFadeIsOn"];
	[appDefaults setValue: @"6.0"				forKey: @"kDefaultFadeDuration"];
	[appDefaults setValue: @"1.0"				forKey: @"kMasterVolume"];
	[appDefaults setValue: @"1.0"				forKey: @"kMaxMasterVolume"];
	[appDefaults setValue: @"0.0"				forKey: @"kMinMasterVolume"];
	[appDefaults setValue: [NSNumber numberWithBool:YES]	forKey: @"kRespectIndividualFadeDurations"];
	[appDefaults setValue: [NSNumber numberWithBool:YES]	forKey: @"kRespectSongHinting"];
	[appDefaults setValue: [NSNumber numberWithBool:YES]	forKey: @"kRespectSongFadeIn"];
	[appDefaults setValue: [NSNumber numberWithBool:NO]	forKey: @"kSongAlwaysFadeIn"];
	[appDefaults setValue: @"/Volumes/MajorTuneage/cocoaJukebox/juksite" forKey: @"kPathToWebServer"];
	[appDefaults setValue: @"deepbondi"			forKey: @"kDefaultPlayList"];
	[appDefaults setValue: [NSNumber numberWithBool:NO]	forKey: @"kStartPlaybackOnLaunch"];
	[appDefaults setValue: @"/archive/mp3.db"               forKey: @"kPathToDatabase"];

        */
}

- (void)awakeFromNib{
	[SpaceAlertRMGAppDelegate initialize];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {


}

@end

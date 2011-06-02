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

        [appDefaults setValue: @"8"                          forKey: @"MinMissionThreatLevel"];
        [appDefaults setValue: @"8"                          forKey: @"MaxMissionThreatLevel"];

        [appDefaults setValue: @"1"                          forKey: @"MinUnconfirmedThreatLevel"];
        [appDefaults setValue: @"1"                          forKey: @"MaxUnconfirmedThreatLevel"];

        [appDefaults setValue: @"0"                          forKey: @"MinRangeUnconfirmedInternalThreat"];
        [appDefaults setValue: @"1"                          forKey: @"MaxRangeUnconfirmedInternalThreat"];
        [appDefaults setValue: @"1"                          forKey: @"ThresholdUnconfirmedInternalThreat"];

        [appDefaults setValue: @"0"                          forKey: @"MinRangeSeriousThreat"];
        [appDefaults setValue: @"2"                          forKey: @"MaxRangeSeriousThreat"];
        [appDefaults setValue: @"2"                          forKey: @"ThresholdSeriousThreat"];

        [appDefaults setValue: @"1"                          forKey: @"MinInternalThreatLevel"];
        [appDefaults setValue: @"3"                          forKey: @"MaxInternalThreatLevel"];

        [appDefaults setValue: @"2"                          forKey: @"MinIncomingData"];
        [appDefaults setValue: @"3"                          forKey: @"MaxIncomingData"];

        [appDefaults setValue: @"3"                          forKey: @"MinDataTransfer"];
        [appDefaults setValue: @"4"                          forKey: @"MaxDataTransfer"];

        [appDefaults setValue: @"45"                         forKey: @"MinTotalCommunicationFailureDuration"];
        [appDefaults setValue: @"60"                         forKey: @"MaxTotalCommunicationFailureDuration"];

        [appDefaults setValue: @"9"                          forKey: @"MinSingleCommunicationFailureDuration"];
        [appDefaults setValue: @"20"                         forKey: @"MaxSingleCommunicationFailureDuration"];

        [appDefaults setValue: @"205"                        forKey: @"MinPhaseOneDuration"];
        [appDefaults setValue: @"240"                        forKey: @"MaxPhaseOneDuration"];

        [appDefaults setValue: @"180"                        forKey: @"MinPhaseTwoDuration"];
        [appDefaults setValue: @"225"                        forKey: @"MaxPhaseTwoDuration"];

        [appDefaults setValue: @"140"                        forKey: @"MinPhaseThreeDuration"];
        [appDefaults setValue: @"155"                        forKey: @"MaxPhaseThreeDuration"];

        [appDefaults setValue: @"0"                          forKey: @"MinTimeToFirstConfirmedThreat"];
        [appDefaults setValue: @"3500"                       forKey: @"MaxTimeToFirstConfirmedThreat"];

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

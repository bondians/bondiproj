//
//  SQInterface.m
//  cocoaJukebox
//
//  Created by David Henderson on 12/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "SQInterface.h"


static int theCallback(void*  notArray, int columnCount, char **column, char ** azColumnNames)
{
NSMutableArray *temp = [NSMutableArray array];
	NSMutableArray *theArray = notArray;	
	
int i;

for ( i = 0; i < columnCount ; i++) {
    [temp addObject: [NSString stringWithUTF8String: 
        column[i] ? column[i] : "NULL"]];
    }
[theArray addObject: temp];
return 0;
}


@implementation SQInterface

-(id) init 
{
	if (![super init])
        return nil;
	
	int rc = 0;
	
	rc = sqlite3_open([[[NSUserDefaults standardUserDefaults] stringForKey: @"kPathToDatabase"] UTF8String], &db);
	tPathToArchive = [[NSString alloc] initWithString: 
		[[NSUserDefaults standardUserDefaults] stringForKey: @"kPathToArchive"]];
	
	return self;

}


- (DBSong *) getSongForKey: (NSString *) key
{
	NSLog (@"SQInterface: getSongForKey entered");

	DBSong *aSong = [[[DBSong alloc] init] autorelease];
	NSString *aBool;
	NSMutableArray *tempList = [NSMutableArray array];
	
	const char *query = [[NSString stringWithFormat: 
		@"SELECT key, song, artist, album, filepath, volume, fadeduration, fadein, prekey, postkey FROM songs_view WHERE key =\'%@\'", key] UTF8String];
	
	sqlite3_exec(db, query, theCallback, tempList, &zErrMsg);
	
	NSArray *anArray = [tempList objectAtIndex: 0];
	
	if (![[anArray objectAtIndex: 4] isEqualToString: @"NULL"]) {
		[aSong setKey: [anArray objectAtIndex: 0]];
		[aSong setTitle: [anArray objectAtIndex: 1]];
		[aSong setArtist: [anArray objectAtIndex: 2]];
		[aSong setAlbum: [anArray objectAtIndex: 3]];
		[aSong setVolume: [[anArray objectAtIndex: 5] floatValue]];
		if (![[anArray objectAtIndex: 6] isEqualToString: @"NULL"]) [aSong setSongFadeDuration: [[anArray objectAtIndex: 6] floatValue]];
		if (![[anArray objectAtIndex: 7] isEqualToString: @"NULL"]) aBool = [anArray objectAtIndex: 7];
		if([aBool isEqualToString:@"t"]){
			[aSong setSongShouldFadeIn: YES];
		} else {
			[aSong setSongShouldFadeIn: NO];
		}
		if (![[anArray objectAtIndex: 8] isEqualToString: @"NULL"]) [aSong setPreQueueKey: [anArray objectAtIndex: 8]];
		if (![[anArray objectAtIndex: 9] isEqualToString: @"NULL"]) [aSong setPostQueueKey: [anArray objectAtIndex: 9]];
		
		[aSong setPath: [NSString stringWithFormat: @"%@/%@", tPathToArchive, [anArray objectAtIndex: 4]]];
		
	}
	else {
		return nil;
	}
	
	return aSong;

}
- (NSMutableArray *) getSongListForUsers: (NSArray *) users
{       
	NSLog (@"SQInterface: getSongListForUsers entered");

        
	NSMutableArray *returnList = [NSMutableArray array];
        NSMutableArray *tempList = [NSMutableArray array];
        NSString *thisObject;
		NSMutableArray *arrayObject;
        
        for (thisObject in users) {
                const char *query = [[NSString stringWithFormat:
                        @"SELECT song_id from plentries where playlist_id=\'%@\'", thisObject] UTF8String];
	sqlite3_exec(db, query, theCallback, tempList, &zErrMsg);
        }
		
		
		for (arrayObject in tempList) {
			[returnList addObject: [arrayObject objectAtIndex: 0]];
		}

        return returnList;
}

- (NSMutableArray *) getSongListForKeys: (NSArray *) keys
{
	NSLog (@"SQInterface: getSongListForKeys entered");

	NSString *thisObject;
	NSMutableArray *playList = [[[NSMutableArray alloc] init] autorelease];
	
	for (thisObject in keys) {
		if (thisObject != nil)
			[playList addObject: [self getSongForKey: thisObject]];
	}
	
	return playList;
}

- (NSDictionary *) getUserSongLists
{
	NSLog (@"SQInterface: getUserSongLists entered");

	NSMutableArray *tempList = [NSMutableArray array];
	NSMutableArray *finalList = [NSMutableArray array];
	NSMutableArray *finalIds = [NSMutableArray array];
	
	const char *listQuery = "SELECT playlists.name, playlists.id, playlists.user_id, goldberg_users.id, goldberg_users.name FROM playlists JOIN goldberg_users ON (playlists.user_id = goldberg_users.id)";
	sqlite3_exec(db, listQuery, theCallback, (void*) tempList, &zErrMsg);
	
	NSMutableArray *tempCounts = [NSMutableArray array];
	NSMutableArray *finalCounts = [NSMutableArray array];
	NSMutableArray *finalUsers = [NSMutableArray array];

	
	NSMutableArray *thisObject;
	
	for (thisObject in tempList) {
		NSString *aString  = [thisObject objectAtIndex: 0];
		[finalList addObject: aString];
		NSString *bString = [thisObject objectAtIndex: 1];
		[finalIds addObject: bString];
		[finalUsers addObject: [thisObject objectAtIndex: 4]];
		const char *countQuery = [[NSString stringWithFormat: 
			@"select count(*) from plentries where playlist_id=\'%@\'", bString] UTF8String];
		sqlite3_exec(db, countQuery, theCallback, (void*) tempCounts, &zErrMsg);

	}
	
	
	for (thisObject in tempCounts) {
		[finalCounts addObject: [thisObject objectAtIndex: 0]];
	}
	
	NSArray *keys = [NSArray arrayWithObjects: @"lists", @"lengths", @"ids", @"users", nil];
	NSArray *objects = [NSArray arrayWithObjects: finalList, finalCounts, finalIds, finalUsers, nil];
	
	return [NSDictionary dictionaryWithObjects: objects forKeys: keys];
}

- (void) disconnect
{
	sqlite3_close(db);
}

- (void) dealloc
{
	[self disconnect];
	[super dealloc];
}

@end



/*
 
#include <stdio.h>
#include <sqlite3.h>
 
 static int callback(void *NotUsed, int argc, char **argv, char **azColName){
	 int i;
	 for(i=0; i<argc; i++){
		 printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
	 }
	 printf("\n");
	 return 0;
 }
 
 int main(int argc, char **argv){
	 sqlite3 *db;
	 char *zErrMsg = 0;
	 int rc;
	 
	 if( argc!=3 ){
		 fprintf(stderr, "Usage: %s DATABASE SQL-STATEMENT\n", argv[0]);
		 exit(1);
	 }
	 rc = sqlite3_open(argv[1], &db);
	 if( rc ){
		 fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
		 sqlite3_close(db);
		 exit(1);
	 }
	 rc = sqlite3_exec(db, argv[2], theCallback, , &zErrMsg);
	 if( rc!=SQLITE_OK ){
		 fprintf(stderr, "SQL error: %s\n", zErrMsg);
	 }
	 sqlite3_close(db);
	 return 0;
 }
 
 */

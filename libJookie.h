#include <unistd.h>
#include <inttypes.h>
#include <netinet/in.h>

typedef int jookieHandle;

typedef enum {
        jookieNoop = 0,
        jookieServerReply,
	jookieServerStatus,
        jookieSongRequest,
	jookieQueueSong,
        jookieDequeueSong,
        jookieListQueue,
        jookieListPlayHistory,
        jookieStuffQueue,
        jookieNumOperations
  } jookiePacketOperation;

typedef enum {
    requestPlaylist,
    randomPlaylist
  } playlistId;

#define kNumPlaylists   	2

#define kJookieDefaultPort	1289

  /* Open a jookie connection to a given host */
jookieHandle openJookie(char *);

  /* Close an (already opened) jookie connection */
int closeJookie(jookieHandle);

  /* Make a song request */
int request(jookieHandle, uint32_t);

  /* Insert a song into the queue */
int queueSong(jookieHandle, playlistId, unsigned int, unsigned int);

  /* Remove a song from the queue */
int dequeueSong(jookieHandle, playlistId, unsigned int);

  /* Retreive a snapshot of the playlist */
int listQueue(jookieHandle, playlistId, unsigned int, unsigned int, unsigned int *);


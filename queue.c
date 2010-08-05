#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <errno.h>

#include "libJookie.h"
#include "jookie.h"

 /*
  *  This entire source file, as well as corresponding parts of the jukeboxd code,
  *  need to be decomposed into simpler functions when I've got some breathing time..
  */

int readSonglistReply(jookiePacket *, unsigned int *);

int queueSong(jookieHandle jookie, playlistId playlist, unsigned int position, unsigned int dbKey) {
  jookiePacket packet, *reply;

  struct {
    uint16_t playlist;
    uint16_t position;
    uint32_t flags;
    uint32_t dbKey;
  } request;

  packet.header.operation = htons(jookieQueueSong);
  packet.header.transaction = htons(0);
  packet.header.length = htonl(sizeof(request));

  request.playlist = htons(playlist);
  request.position = htons(position);
  request.flags = htonl(0);
  request.dbKey = htonl(dbKey);

  packet.payload = &request;

  if (jookieSendPacket(jookie, packet) == -1)
    return -1;

  reply = jookieReadPacket(jookie);
  if (reply == NULL)
    return -1;

  return jookieReadStatusReply(reply);
}


int dequeueSong(jookieHandle jookie, playlistId playlist, unsigned int dbKey) {
  jookiePacket packet, *reply;

  struct {
    uint16_t playlist;
    uint16_t pad;
    uint32_t dbKey;
  } request;

  packet.header.operation = htons(jookieDequeueSong);
  packet.header.transaction = htons(0);
  packet.header.length = htonl(sizeof request);

  request.playlist = htons(playlist);
  request.dbKey = htonl(dbKey);

  packet.payload = &request;

  if (jookieSendPacket(jookie, packet) == -1)
    return -1;

  reply = jookieReadPacket(jookie);
  if (reply == NULL)
    return -1;

  return jookieReadStatusReply(reply);
}


int listQueue(jookieHandle jookie, playlistId playlist, unsigned int position, unsigned int maxKeys, unsigned int *dbKeys) {
  jookiePacket packet, *reply;
  int numSongs;

  struct {
    uint16_t playlist;
    uint16_t flags;
    uint16_t position;
    uint16_t numSongs;
  } request;

  packet.header.operation = htons(jookieListQueue);
  packet.header.transaction = htons(0);
  packet.header.length = htonl(sizeof(request));

  request.playlist = htons(playlist);
  request.position = htons(position);
  request.flags = htons(0);
  request.numSongs = htons(maxKeys);

  packet.payload = &request;

  if (jookieSendPacket(jookie, packet) == -1)
    return -1;

  reply = jookieReadPacket(jookie);
  if (reply == NULL)
    return -1;

  if((numSongs = readSonglistReply(reply, dbKeys)) == -8)
    return jookieReadStatusReply(reply);

  reply = jookieReadPacket(jookie);
  if (reply == NULL)
    return -1;

  return (jookieReadStatusReply(reply) == -1) ? -1 : numSongs;
}


int readSonglistReply(jookiePacket *packet, unsigned int *dbKeys) {
  uint32_t *keys = packet->payload;
  unsigned int numKeys, key;

  if (packet->header.operation == jookieServerReply) {
    numKeys = packet->header.length / sizeof (*keys);

    for (key = 0; key < numKeys; key++) {
      dbKeys[key] = ntohl(keys[key]);
    }

    jookieFreePacket(packet);
    return numKeys;
  } else {
    return -8;
  }
}


#include <unistd.h>
#include <errno.h>
#include <stdlib.h>

#include <sys/types.h>
#include <errno.h>


#include "libJookie.h"
#include "jookie.h"

  /* Make a song request */
int request(jookieHandle jookie, uint32_t dbKey) {
  jookiePacket packet;
  int status = -1;
  jookiePacket *reply;
  uint32_t replyPayload[2];
  uint32_t key;

  reply = (jookiePacket *) malloc(sizeof(jookiePacket));
  if (reply == NULL) {
    perror("malloc(packet)");
    return -1;
  } 

  reply->payload = &replyPayload;


  packet.header.operation = htons(jookieSongRequest);
  packet.header.transaction = htons(0);
  packet.header.length = htonl(sizeof dbKey);

  key = htonl(dbKey);

  packet.payload = &key;

  status = jookieSendPacket(jookie, packet);

  reply = jookieReadPacket(jookie);
  if (reply == NULL)
    return -1;

  jookieReadStatusReply(reply);

  return status;

}

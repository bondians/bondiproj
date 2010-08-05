#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <errno.h>
#include <stdlib.h>
#include <strings.h>

#include "libJookie.h"
#include "jookie.h"

int jookieReadStatusReply(jookiePacket *packet) {
  uint32_t status[2];

  if((packet->header.operation != jookieServerStatus) || (packet->header.length != sizeof status)) {
    errno = EINVAL;
    perror("invalid server status packet");
    return -1;
  }

  bcopy(packet->payload, status, sizeof(status));

  jookieFreePacket(packet);

  errno = ntohl(status[1]);
  return ntohl(status[0]);
}

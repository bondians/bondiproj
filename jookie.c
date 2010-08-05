#include <stdio.h>
#include <sys/types.h>
#include <errno.h>
#include <netinet/in.h>
#include <stdlib.h>

#include "jookie.h"


  /*
   *  A simple handshake, later versions of jookie will
   *  probably support some sort of auto-negotiation of
   *  versions and/or command sets
   */
int jookieHandshake(int jookie) {
  if(sendJookieHeader(jookie) == -1)
    return -1;

  return validateJookieHeader(jookie);
}

  /*
   * First part of the 'handshake' - tell the client our capabilities
   */
int sendJookieHeader(int jookie) {
  jookieProtocolHeader header;

    /* create a protocol header */
  header.magicNum = htonl(jookieMagic);
  header.version = htonl(jookieLatestVersion);

    /* send out our header */
  if(write(jookie, &header, sizeof(header)) != sizeof(header)) {
    return -1;
  }

  errno = 0;
  return 0;
}

  /*
   * Second part of the 'handshake' - find out the client's capabilities
   */
int validateJookieHeader(int jookie) {
  jookieProtocolHeader header;

  if(read(jookie, &header, sizeof(header)) != sizeof(header)) {
    return -1;
  }

  if (ntohl(header.magicNum) != jookieMagic) {
    errno = EINVAL;
    return -1;
  }

  if (ntohl(header.version) != jookieLatestVersion) {
    errno = EINVAL;
    return -1;
  }

  errno = 0;
  return 0;
}

jookiePacket *jookieReadPacket(int jookie) {
  jookiePacket *packet = NULL;

  packet = (jookiePacket *) malloc(sizeof(jookiePacket));
  if (packet == NULL) {
    perror("malloc(packet)");
    return NULL;
  }

  packet->header = jookieReadPacketHeader(jookie);
  if (packet->header.length == 0) {
    packet->payload = NULL;
    return packet;
  }

  packet->payload = jookieReadPacketPayload(jookie, packet->header);
  if (packet->payload == NULL) {
    free(packet);
    return NULL;
  }

  return packet;
}

int jookieFreePacket(jookiePacket *packet) {
  int status = 0;

  if (packet) {
    if (packet->payload)
	free(packet->payload);

    free(packet);
  }

  return status;
}

jookiePacketHeader jookieReadPacketHeader(int jookie) {
  jookiePacketHeader header = {0};

  if(read(jookie, &header, sizeof(header)) != sizeof(header)) {
    return (jookiePacketHeader) {0};
  }

  header.operation = ntohs(header.operation);
  header.transaction = ntohs(header.transaction);
  header.length = ntohl(header.length);

  return header;
}

void *jookieReadPacketPayload(int jookie, jookiePacketHeader header) {
  void *buffer;

  buffer = (void *) malloc(header.length);
  if (buffer == NULL)
    return NULL;

  if (read(jookie, buffer, header.length) != header.length) {
    free(buffer);
    return NULL;
  }

  return buffer;
}

int jookieSendPacket(int jookie, jookiePacket packet) {
  int length = ntohl(packet.header.length);

  if(write(jookie, &(packet.header), sizeof(packet.header)) != sizeof(packet.header)) {
    return -1;
  }

  if(write(jookie, packet.payload, length) != length) {
    return -1;
  }

  return 0;
}


/*
 *  jookie.h - definitions of internal jookie types and routines
 */

#include <inttypes.h>
#include <netinet/in.h>

typedef struct {
	uint32_t magicNum;
	uint32_t version;
  } jookieProtocolHeader;

#define jookieMagic		(('J' << 24) | ('B' << 16) | ('X' << 8) | ('D'))

#define jookieVersion(Maj,Min,Rev)	((uint32_t) (Maj << 24) | ((Min << 16) & 0xFF0000) | (Rev & 0xFFFF))
#define jookieLatestVersion		jookieVersion(0, 1, 0)

typedef struct {
	uint16_t operation;
	uint16_t transaction;
	uint32_t length;
  } jookiePacketHeader;

typedef struct {
	jookiePacketHeader header;
	void *payload;
  } jookiePacket;

int jookieHandshake(int);
int sendJookieHeader(int);
int validateJookieHeader(int);

jookiePacketHeader jookieReadPacketHeader(int);
void *jookieReadPacketPayload(int, jookiePacketHeader);

jookiePacket *jookieReadPacket(int);
int jookieSendPacket(int, jookiePacket);
int jookieFreePacket(jookiePacket *);

  /* read simple (return, errno) status packet */
int jookieReadStatusReply(jookiePacket *);

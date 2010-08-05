#include <unistd.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>

#include "libJookie.h"
#include "jookie.h"

  /*
   *  Open a jookie connection to a given host (maybe thins ought to 
   *  take a 'struct sockaddr *' as its argument, so the (host-specific)
   *  resolution part of the picture is left to the client...
   *
   *  In any case, this needs to get cleaned up, idiot-proofed, and
   *  whatnot.
   */
jookieHandle openJookie(char *host) {
  struct servent *jookieServEnt;
  struct hostent *jookieServer;
  struct sockaddr_in jookieAddress;
  int jookie, jookiePort;

    /* Lookup our jookie service in the system services directory */
    /* If it's not listed, assume a default */
  jookieServEnt = getservbyname("jookie", "tcp");
  if (!jookieServEnt)
    jookiePort = kJookieDefaultPort;
  else
    jookiePort = jookieServEnt->s_port;

  errno = 0;		/* Linux for some reason sets errno to ENOENT,
			   even if the operation succeeds... (2.2.19-sparc64)*/

    /*
     *  Resolve the requested host name - note that
     *  some systems (notably darwin) will not 'resolve'
     *  a 'dotted-decimal' format IP address
     */
  jookieServer = gethostbyname(host);
  if (!jookieServer) {
    perror("gethostbyname");
    return(-1);
  }

    /* Initialize address family and port part of the address */
  jookieAddress.sin_family = AF_INET;
  jookieAddress.sin_port = jookiePort;

    /*
     *  Copy the jookie server's address (from above resolution)
     *  into the socket address sturcture
     */
  memcpy(&jookieAddress.sin_addr, jookieServer->h_addr, jookieServer->h_length);

    /* Create the socket */
  jookie = socket(AF_INET, SOCK_STREAM, 0);
  if(jookie == -1) {
    perror("socket");
    return(-1);
  }

    /* Attempt to connect the socket to the jookie server */
  if(connect(jookie, (struct sockaddr *)&jookieAddress, sizeof(jookieAddress)) == -1) {
    perror("connect");
    return(-1);
  }

    /*
     *  Woo Hoo!  We're connected... Now, perform a handshake
     *  to be sure we're connected to a compatible server
     */
  if(jookieHandshake(jookie) == -1) {
    perror("jookieHandshake");
    close(jookie);
    return(-1);
  }


    /*
     *  Return a connected file descriptor - for the purposes of the client,
     *  a 'jookie handle'
     */
  return jookie;
}

  /* Close a (hopefully already opened) jookie connection */
int closeJookie(jookieHandle jookie) {
  return close(jookie);
}


#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <signal.h>
#include <strings.h>
#include <unistd.h>

int serve_socket(int port)
{
	int s;
	struct sockaddr_in sn;
	struct hostent *he;

	if (!(he = gethostbyname("localhost"))) {
		puts("can't gethostname");
		exit(1);
	}

	bzero((char*)&sn, sizeof(sn));
	sn.sin_family = AF_INET;
	sn.sin_port = htons((short)port);
	sn.sin_addr.s_addr = htonl(INADDR_ANY);

	if ((s = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
		perror("socket()");
		exit(1);
	}

	if (bind(s, (struct sockaddr *)&sn, sizeof(sn)) == -1) {
		perror("bind()");
		exit(1);
	}

	return s;
}

int accept_connection(int s)
{
	int l;
	int x;
	struct sockaddr_in sn;

	if(listen(s, 1) == -1) {
		perror("listen()");
		exit(1);
	}

	bzero((char *)&sn, sizeof(sn));
	l = sizeof(sn);
	if((x = accept(s, (struct sockaddr *)NULL, NULL)) == -1) {
		perror("accept()");
		exit(1);
	}
	return x;
}

/* sdl: modified to return 0 on failure, instead of exiting */
int request_connection(char *hn, int port)
{
	struct sockaddr_in sn;
	int s;
	struct hostent *he;

	if (!(he = gethostbyname(hn))) {
		fprintf(stderr, "can't gethostname %s\n", hn);
		return 0;
	} 

	bzero((char *)&sn,sizeof(sn));
	sn.sin_family = AF_INET;
	sn.sin_port  = htons((short)port);
	sn.sin_addr = *(struct in_addr *)(he->h_addr_list[0]);

	if ((s = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
		perror("socket() failed");
		return 0;
	}
	return connect(s, (struct sockaddr*)&sn, sizeof(sn)) == -1 ? 0 : s;
}

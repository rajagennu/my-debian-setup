/*** includes ***/

#include <asm-generic/errno-base.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <ctype.h>
#include <stdio.h>
#include <errno.h>

/*** defines ***/

#define CTRL_KEY(k) ((k) & 0x1f)

/*** data ***/
struct termios orig_termios;


/*** terminal ****/ 

void clearTheScreen() {
	write(STDOUT_FILENO, "\x1b[2J", 4);
}

void rePositionCursor() {
	write(STDOUT_FILENO, "\x1b[H", 3);
}

void die (const char *s) {
	clearTheScreen();
	rePositionCursor();
	perror(s);
	exit(1);
}

void disableRawMode() {
	if ( tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios) == -1)
	die("tcsetattr");
}

void enableRawMode() {
	if (tcgetattr(STDIN_FILENO, &orig_termios) == -1 )
		die("tcsgetattr");
	atexit(disableRawMode);


	struct termios raw = orig_termios;
	raw.c_iflag &= ~(ICRNL | IXON | BRKINT | ISTRIP | INPCK);
	raw.c_oflag &= ~(OPOST);
	raw.c_lflag &= ~(ECHO | ICANON |IEXTEN |ISIG);
	raw.c_cflag |= (CS8);
	raw.c_cc[VMIN] = 0;
	raw.c_cc[VTIME] = 1;

	if ( tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw )== -1)
			die("tcsetattr");
}

char editorReadKey() {
	int nread;
	char c;
	while(( nread = read(STDIN_FILENO, &c, 1)) != 1) {
		if (nread == -1  && errno != EAGAIN) die ("read");
	}
	return c;
}

/*** output ***/ 

void editorDrawRows() {
	int y;
	for ( y = 0; y < 24 ; y++) {
		write(STDOUT_FILENO, "~\r\n", 3);
	}
}

void editorRefreshScreen() { 
	clearTheScreen();
	rePositionCursor();
	editorDrawRows();
	rePositionCursor();
}
/*** input ***/

void editorProcessKeyPress() {
	char c = editorReadKey();

	switch(c) {
		case CTRL_KEY('q'):
			clearTheScreen();
			rePositionCursor();
			exit(0);
			break;
	}
}

/*** int ***/

int main() {
	enableRawMode();

	while(1) {
		editorRefreshScreen();
		editorProcessKeyPress();
		char c = '\0';
		if ( read(STDIN_FILENO, &c, 1) == -1 && errno != EAGAIN) die ("read");
		if (iscntrl(c)) {
			printf("%d\r\n", c);
		} else {
			printf("%d ('%c')\r\n", c,c);
		}

		if (c == 'q') break;
	}
	return 0;
}

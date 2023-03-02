#include <stdio.h>
#include <stdlib.h>

// TODO: Linux version

#ifdef _WIN32
#include <windows.h>
#include <conio.h>
#define FOREGROUND_WHITE (FOREGROUND_RED | FOREGROUND_BLUE | FOREGROUND_GREEN)
#endif

COORD coord = {0,0};

void hideCursor()
{
    #ifdef _WIN32
    HANDLE consoleHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_CURSOR_INFO info;
    info.dwSize = 100;
    info.bVisible = FALSE;
    SetConsoleCursorInfo(consoleHandle, &info);
    #endif
}

int resetCursor()
{
    #ifdef _WIN32
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
    #endif
    return 0;
}

int getKey()
{
    #ifdef _WIN32
    if (_kbhit()) {
        return _getch();
    }
    return -1;
    #else
	return getchar();
    #endif
}

int show(char *str)
{
	#ifdef _WIN32
    WORD wAttributes = 0;
	HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    switch (str[0]) {
    case 'W':
        wAttributes = FOREGROUND_RED | FOREGROUND_INTENSITY;
        break;
    case 'S':
        wAttributes = FOREGROUND_WHITE | FOREGROUND_INTENSITY;
        break;
    default:
        wAttributes = FOREGROUND_WHITE;
    }
	SetConsoleTextAttribute(hConsole, wAttributes);
	#endif
	putchar(str[0]);
	return 0;
}

int showAt(char *str, int x, int y, int color)
{
    resetCursor();
    #ifdef _WIN32
    COORD pos;
    pos.X = x;
    pos.Y = y;
    fflush(stdin);
    WORD wAttributes = color;
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), wAttributes);
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), pos);
    putchar(str[0]);
    //show(str);
    #endif
    return 0;
}
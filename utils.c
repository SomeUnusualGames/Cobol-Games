#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#if defined(_WIN32)
#include <windows.h>
#include <conio.h>
#define FOREGROUND_WHITE (FOREGROUND_RED | FOREGROUND_BLUE | FOREGROUND_GREEN)
#elif defined(__linux__)
#include <ncurses.h>
#else
#error Unsupported OS ¯\_(ツ)_/¯
#endif

#if defined(_WIN32)
COORD coord = {0, 0};
#endif

void initWindow()
{
    #if defined(_WIN32)
    system("cls");
    #elif defined(__linux__)
    initscr(); // Init ncruses screen
    noecho();  // Do not print keys pressed
    nodelay(stdscr, TRUE); // To make getch non-blocking
    #endif
}

void hideCursor()
{
    #if defined(_WIN32)
    HANDLE consoleHandle = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_CURSOR_INFO info;
    info.dwSize = 100;
    info.bVisible = FALSE;
    SetConsoleCursorInfo(consoleHandle, &info);
    #elif defined(__linux__)
    curs_set(0);
    #endif
}

int resetCursor()
{
    #if defined(_WIN32)
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
    #elif defined(__linux__)
    move(0, 0);
    #endif
    return 0;
}

int getKey()
{
    #if defined(_WIN32)
    return _kbhit() ? _getch() : -1;
    #elif defined(__linux__)
    int c = getch();
    return c != ERR ? c : -1;
    #endif
}

#if 0
int show(char *str)
{
    #if defined(_WIN32)
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
#endif

int showAt(char *str, int x, int y, int color)
{
    resetCursor();
    #if defined(_WIN32)
    COORD pos;
    pos.X = x;
    pos.Y = y;
    WORD wAttributes = color;
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), wAttributes);
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), pos);
    for (int i = 0; i < strlen(str); ++i) {
        putchar(str[i]);
        ++pos.X;
        SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), pos);
    }
    #elif defined(__linux__)
    // TODO: color
    for (int i = 0; i < strlen(str); ++i) {
        move(y, x);
        printw("%c", str[i]);
        refresh();
        ++x;
    }
    #endif
    return 0;
}

int delay(int t)
{
    struct timespec ts;
    int millisec = t;
    int res;
    ts.tv_sec = millisec / 1000;
    ts.tv_nsec = (millisec % 1000) * 1000000;
    do {
        res = nanosleep(&ts, &ts);
    } while(res);
    return 0;
}

int resetWindow()
{
    #if defined(_WIN32)
    system("cls");
    WORD wAttributes = FOREGROUND_WHITE;
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), wAttributes);
    #elif defined(__linux__)
    endwin();
    #endif
    return 0;
}
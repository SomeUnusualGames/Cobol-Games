.PHONY: clean

MAIN_FILE ?= game
UTILS_FILE ?= utils
CC ?= cc
COBC ?= cobc
ifneq ($(OS),Windows_NT)
CFLAGS ?= -lncurses
endif

build:
	$(CC) -c $(UTILS_FILE).c $(CFLAGS)
	$(COBC) -c -static -x $(MAIN_FILE).cob
	$(COBC) -x -o $(MAIN_FILE) $(MAIN_FILE).o $(UTILS_FILE).o
clean:
ifeq ($(OS),Windows_NT)
	del *.o *.exe /s
else
	find . -type f -executable -delete
	rm -fv *.o
endif
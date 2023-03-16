       IDENTIFICATION DIVISION.
       PROGRAM-ID. DODGER.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 RAND-NUM USAGE COMP-1.
       01 DATE-SEED PIC 9(16).
       01 GAME.
           05 KEEP-PLAYING PIC 9 VALUE 1.
           05 STARTED PIC 9 VALUE ZERO.
           05 KEYPRESSED PIC 9(4) VALUE ZERO.
           05 CHAR-PRESSED PIC X VALUE SPACE.
       01 MAP.
           05 MOUNTAIN-Y PIC S99 VALUE 9.
           05 X-VALUE PIC 99 VALUE ZERO.
           05 X-VALUE2 PIC 99 VALUE ZERO.
           05 CHAR-LINE-MOD PIC 9 VALUE ZERO.
           05 CHAR-LINE PIC X VALUE "-".
           05 NEXT-I PIC 99 VALUE ZERO.
       01 MOUNTAIN.
           05 Y-POSITION PIC 9 OCCURS 64 TIMES INDEXED BY I.
       01 PLAYER.
           05 PLAYER-X PIC 99 VALUE 3.
           05 PLAYER-Y PIC 99 VALUE 13.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
     ***** TODO: Add obstacles, make the C function "delay"
     ***** use a parameter instead of a hardcoded value
           CALL "initWindow"
           CALL "hideCursor"
           PERFORM INIT-MOUNTAINS
           PERFORM DRAW-PLAYER.
           PERFORM UNTIL KEEP-PLAYING EQUALS ZERO
               CALL "getKey" RETURNING KEYPRESSED
               MOVE FUNCTION CHAR(KEYPRESSED + 1) TO CHAR-PRESSED
               EVALUATE FUNCTION LOWER-CASE(CHAR-PRESSED)
                   WHEN "q" MOVE ZERO TO KEEP-PLAYING
                   WHEN "w"
                       IF PLAYER-Y GREATER THAN 11 THEN
                           PERFORM CLEAN-PLAYER
                           ADD 1 TO PLAYER-X
                           SUBTRACT 1 FROM PLAYER-Y
                           PERFORM DRAW-PLAYER
                       END-IF
                   WHEN "s"
                       IF PLAYER-Y LESS THAN 13 THEN
                           PERFORM CLEAN-PLAYER
                           SUBTRACT 1 FROM PLAYER-X
                           ADD 1 TO PLAYER-Y
                           PERFORM DRAW-PLAYER
                       END-IF
                   WHEN "d"
                       IF PLAYER-X LESS THAN 50 THEN
                           PERFORM CLEAN-PLAYER
                           ADD 1 TO PLAYER-X
                           PERFORM DRAW-PLAYER
                       END-IF
                   WHEN "a"
                       IF PLAYER-X GREATER THAN 3 THEN
                           PERFORM CLEAN-PLAYER
                           SUBTRACT 1 FROM PLAYER-X
                           PERFORM DRAW-PLAYER
                       END-IF
               END-EVALUATE
               PERFORM DRAW-BORDERS
               PERFORM DRAW-MOUNTAINS
               CALL "delay"
               PERFORM UPDATE-MOUNTAINS
           END-PERFORM.
       STOP RUN.
       
       INIT-MOUNTAINS.
           MOVE FUNCTION CURRENT-DATE(9:8) TO DATE-SEED
           MOVE FUNCTION RANDOM(DATE-SEED) TO RAND-NUM
           MOVE 1 TO I
           PERFORM UNTIL I > 64
               MOVE FUNCTION RANDOM TO RAND-NUM
               IF RAND-NUM > 0.5 THEN
                   ADD 1 TO MOUNTAIN-Y
               ELSE IF RAND-NUM <= 0.5 THEN
                   SUBTRACT 1 FROM MOUNTAIN-Y
               END-IF
               IF MOUNTAIN-Y LESS THAN ZERO THEN
                   MOVE 0 TO MOUNTAIN-Y
               ELSE IF MOUNTAIN-Y GREATER THAN 9 THEN
                   MOVE 9 TO MOUNTAIN-Y
               END-IF
               MOVE MOUNTAIN-Y TO Y-POSITION(I)
               ADD 1 TO I
           END-PERFORM.
       
       DRAW-BORDERS.
           MOVE 1 TO X-VALUE
           PERFORM UNTIL X-VALUE > 60
               COMPUTE X-VALUE2 = X-VALUE + 5
               IF FUNCTION MOD(X-VALUE, 2) EQUALS CHAR-LINE-MOD THEN
                   MOVE "." TO CHAR-LINE
               ELSE
                   MOVE "-" TO CHAR-LINE
               END-IF
               CALL "showAt" USING
                   BY REFERENCE CHAR-LINE
                   BY VALUE X-VALUE2
                   BY VALUE 10
                   BY VALUE 6
               END-CALL
               CALL "showAt" USING
                   BY REFERENCE CHAR-LINE
                   BY VALUE X-VALUE
                   BY VALUE 14
                   BY VALUE 6
               END-CALL
               ADD 1 TO X-VALUE
           END-PERFORM
           IF CHAR-LINE-MOD EQUALS ZERO THEN
               MOVE 1 TO CHAR-LINE-MOD
           ELSE
               MOVE ZERO TO CHAR-LINE-MOD
           END-IF.

       DRAW-MOUNTAINS.
           MOVE 1 TO I
           PERFORM UNTIL I > 64
               CALL "showAt" USING
                   BY REFERENCE "O"
                   BY VALUE I
                   BY VALUE Y-POSITION(I)
                   BY VALUE 6
               END-CALL
               ADD 1 TO I
           END-PERFORM.
       
       UPDATE-MOUNTAINS.
           MOVE 1 TO I
           MOVE 1 TO NEXT-I
           PERFORM UNTIL I > 64
               CALL "showAt" USING
                   BY REFERENCE " "
                   BY VALUE I
                   BY VALUE Y-POSITION(I)
                   BY VALUE 6
               END-CALL
               COMPUTE NEXT-I = I + 1
               IF NEXT-I GREATER THAN 64 THEN
                   MOVE Y-POSITION(1) TO Y-POSITION(I)
               ELSE
                   MOVE Y-POSITION(NEXT-I) TO Y-POSITION(I)
               END-IF
               ADD 1 TO I
           END-PERFORM.

       CLEAN-PLAYER.
           CALL "showAt" USING
               BY REFERENCE " "
               BY VALUE PLAYER-X
               BY VALUE PLAYER-Y
               BY VALUE 1
           END-CALL.

       DRAW-PLAYER.
           CALL "showAt" USING
               BY REFERENCE "X"
               BY VALUE PLAYER-X
               BY VALUE PLAYER-Y
               BY VALUE 1
           END-CALL.
           

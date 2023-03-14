       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 RAND-NUM USAGE COMP-1.
           01 DATE-SEED PIC 9(16).
           01 DUMMY PIC 99 VALUE ZERO.
           01 MAP.
               05 Y-VALUE PIC 99 VALUE ZERO.
               05 X-VALUE PIC 99 VALUE ZERO.
           01 GAME.
               05 KEEP-PLAYING PIC 9 VALUE 1.
               05 STARTED PIC 9 VALUE ZERO.
               05 KEYPRESSED PIC 9(4) VALUE ZERO.
               05 CHAR-PRESSED PIC X VALUE SPACE.
               05 PLAYER-SCORE PIC 9(3) VALUE ZERO.
               05 COM-SCORE PIC 9(3) VALUE ZERO.
               05 PLAYER-X PIC 99 VALUE 20.
               05 PLAYER-Y PIC 99 VALUE 23.
               05 COM-X PIC 99 VALUE 20.
               05 COM-Y PIC 9 VALUE 3.
           01 BALL.
               05 BALL-X PIC 99 VALUE 20.
               05 BALL-Y PIC 99 VALUE 12.
               05 MOV-X PIC S99 VALUE ZERO.
               05 MOV-Y PIC S99 VALUE ZERO.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           CALL "initWindow"
           CALL "hideCursor"
           PERFORM DRAW-FIELD
           PERFORM DRAW-PLAYER-RACKET
           PERFORM DRAW-COM-RACKET
           PERFORM DRAW-BALL
           PERFORM SHOW-SCORE
           MOVE FUNCTION CURRENT-DATE(9:8) TO DATE-SEED
           MOVE FUNCTION RANDOM(DATE-SEED) TO RAND-NUM
           PERFORM UNTIL KEEP-PLAYING EQUALS ZERO
      ******** Key pressed
               CALL "getKey" RETURNING KEYPRESSED
               MOVE FUNCTION CHAR(KEYPRESSED + 1) TO CHAR-PRESSED
               EVALUATE FUNCTION LOWER-CASE(CHAR-PRESSED)
                   WHEN "q" MOVE ZERO TO KEEP-PLAYING
                   WHEN "a"
                      IF PLAYER-X IS GREATER THAN 1 THEN
                          PERFORM CLEAN-PLAYER-RACKET
                          SUBTRACT 1 FROM PLAYER-X
                          PERFORM DRAW-PLAYER-RACKET
                      END-IF
                  WHEN "d"
                      IF PLAYER-X IS LESS THAN 40 THEN
                          PERFORM CLEAN-PLAYER-RACKET
                          ADD 1 TO PLAYER-X
                          PERFORM DRAW-PLAYER-RACKET
                      END-IF
                  WHEN " "
                      IF STARTED EQUALS ZERO THEN
                         MOVE 1 TO STARTED
                         MOVE FUNCTION RANDOM TO RAND-NUM
                         MOVE 1 TO MOV-X
                         MOVE 1 TO MOV-Y
                         IF RAND-NUM IS GREATER THAN 0.8 THEN
                             MULTIPLY -1 BY MOV-X
                             MULTIPLY -1 BY MOV-Y
                         ELSE IF RAND-NUM >= 0.6 AND RAND-NUM < 0.8 THEN
                             MULTIPLY 1 BY MOV-X
                             MULTIPLY -1 BY MOV-Y
                         ELSE IF RAND-NUM >= 0.4 AND RAND-NUM < 0.6 THEN
                             MULTIPLY -1 BY MOV-X
                             MULTIPLY 1 BY MOV-Y
                         END-IF
                      END-IF
               END-EVALUATE
      ******** Ball
               IF STARTED EQUALS 1 THEN
      ************* Check if anyone scored
                   IF BALL-Y EQUALS 2 THEN
                       ADD 1 TO PLAYER-SCORE
                       PERFORM RESET-GAME
                   ELSE IF BALL-Y EQUALS 24 THEN
                       ADD 1 TO COM-SCORE
                       PERFORM RESET-GAME
                   END-IF
      ************ Wall bounce
                   IF BALL-X EQUALS 39 OR BALL-X EQUALS 1 THEN
                       MULTIPLY -1 BY MOV-X
                   END-IF
      ************ Racket bounce
                   IF BALL-X EQUALS PLAYER-X AND BALL-Y EQUALS PLAYER-Y THEN
                       MULTIPLY -1 BY MOV-Y
                   END-IF
                   IF BALL-X EQUALS COM-X AND BALL-Y EQUALS COM-Y THEN
                       MULTIPLY -1 BY MOV-Y
                   END-IF
      ************ Update ball
                   PERFORM CLEAR-BALL
                   IF MOV-X IS GREATER THAN 0 THEN
                       ADD 1 TO BALL-X
                   ELSE
                       SUBTRACT 1 FROM BALL-X
                   END-IF
                   IF MOV-Y IS GREATER THAN 0 THEN
                       ADD 1 TO BALL-Y
                   ELSE
                       SUBTRACT 1 FROM BALL-Y
                   END-IF
                   PERFORM DRAW-BALL
                   PERFORM DRAW-PLAYER-RACKET
                   PERFORM DRAW-COM-RACKET
      ************ Com
                   IF MOV-Y IS LESS THAN ZERO THEN
                       IF BALL-X IS LESS THAN COM-X THEN
                           PERFORM CLEAN-COM-RACKET
                           SUBTRACT 1 FROM COM-X
                           PERFORM DRAW-COM-RACKET
                       ELSE IF BALL-X IS GREATER THAN COM-X THEN
                           PERFORM CLEAN-COM-RACKET
                           ADD 1 TO COM-X
                           PERFORM DRAW-COM-RACKET
                       END-IF
                   END-IF
               END-IF
               CALL "delay"
           END-PERFORM
           CALL "resetWindow".
       STOP RUN.

       RESET-GAME.
           MOVE 0 TO STARTED
           PERFORM CLEAR-BALL
           PERFORM CLEAN-COM-RACKET
           PERFORM CLEAN-PLAYER-RACKET
           PERFORM SHOW-SCORE
           MOVE 20 TO BALL-X
           MOVE 12 TO BALL-Y
           MOVE 20 TO PLAYER-X
           MOVE 20 TO COM-X
           PERFORM DRAW-COM-RACKET
           PERFORM DRAW-PLAYER-RACKET
           PERFORM DRAW-BALL.

       DRAW-FIELD.
           PERFORM VARYING Y-VALUE FROM 1 BY 1 UNTIL Y-VALUE > 25
               IF Y-VALUE EQUALS 1 THEN
                   PERFORM VARYING DUMMY FROM 1 BY 1 UNTIL DUMMY > 40
                       CALL "showAt" USING
                           BY REFERENCE "_"
                           BY VALUE DUMMY
                           BY VALUE Y-VALUE
                           BY VALUE 1
                       END-CALL
                   END-PERFORM
               ELSE IF Y-VALUE EQUALS 25 THEN
                   PERFORM VARYING DUMMY FROM 1 BY 1 UNTIL DUMMY > 40
                       IF DUMMY EQUALS 1 THEN
                           CALL "showAt" USING
                               BY REFERENCE "\"
                               BY VALUE DUMMY
                               BY VALUE Y-VALUE
                               BY VALUE 1
                           END-CALL
                       ELSE IF DUMMY IS LESS THAN 40 THEN
                           CALL "showAt" USING
                               BY REFERENCE "_"
                               BY VALUE DUMMY
                               BY VALUE Y-VALUE
                               BY VALUE 1
                           END-CALL
                       ELSE
                           CALL "showAt" USING
                               BY REFERENCE "/"
                               BY VALUE DUMMY
                               BY VALUE Y-VALUE
                               BY VALUE 1
                           END-CALL
                       END-IF
                   END-PERFORM
               ELSE IF Y-VALUE EQUALS 2 THEN
                   CALL "showAt" USING
                        BY REFERENCE "/"
                        BY VALUE 0
                        BY VALUE Y-VALUE
                        BY VALUE 1
                   END-CALL
                   CALL "showAt" USING
                        BY REFERENCE "\"
                        BY VALUE 41
                        BY VALUE Y-VALUE
                        BY VALUE 1
                   END-CALL
               ELSE
                   CALL "showAt" USING
                       BY REFERENCE "|"
                       BY VALUE 0
                       BY VALUE Y-VALUE
                       BY VALUE 5
                   END-CALL
                   CALL "showAt" USING
                       BY REFERENCE "|"
                       BY VALUE 41
                       BY VALUE Y-VALUE
                       BY VALUE 4
                   END-CALL
               END-IF
           END-PERFORM.

       DRAW-PLAYER-RACKET.
           CALL "showAt" USING
               BY REFERENCE "_"
               BY VALUE PLAYER-X
               BY VALUE 23
               BY VALUE 5
           END-CALL.
       
       CLEAN-PLAYER-RACKET.
           CALL "showAt" USING
               BY REFERENCE " "
               BY VALUE PLAYER-X
               BY VALUE 23
               BY VALUE 0
           END-CALL.

       DRAW-COM-RACKET.
           CALL "showAt" USING
               BY REFERENCE "_"
               BY VALUE COM-X
               BY VALUE 3
               BY VALUE 5
           END-CALL.

       CLEAN-COM-RACKET.
           CALL "showAt" USING
               BY REFERENCE " "
               BY VALUE COM-X
               BY VALUE 3
               BY VALUE 0
           END-CALL.
       
       CLEAR-BALL.
           CALL "showAt" USING
               BY REFERENCE " "
               BY VALUE BALL-X
               BY VALUE BALL-Y
               BY VALUE 0
           END-CALL.
       
       DRAW-BALL.
           CALL "showAt" USING
               BY REFERENCE "O"
               BY VALUE BALL-X
               BY VALUE BALL-Y
               BY VALUE 7
           END-CALL.

       SHOW-SCORE.
           CALL "showAt" USING
               BY REFERENCE "        "
               BY VALUE 0
               BY VALUE 27
               BY VALUE 4
           END-CALL
           DISPLAY "PLAYER: " PLAYER-SCORE " COM: " COM-SCORE.
       END PROGRAM GAME.
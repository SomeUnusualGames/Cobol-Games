       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 Y-VALUE PIC 99 VALUE 0.
           01 X-VALUE PIC 99 VALUE 0.
           01 KEEP-PLAYING PIC 9 VALUE 1.
           01 KEYPRESSED PIC 9(4) VALUE 0.
           01 PLAYER-X PIC 99 VALUE 5.
           01 COM-X PIC 99 VALUE 5.
           01 CHAR-PRESSED PIC X VALUE SPACE.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           CALL "hideCursor"
           PERFORM DRAW-FIELD
           PERFORM DRAW-PLAYER-RACKET
           PERFORM DRAW-COM-RACKET
           PERFORM UNTIL KEEP-PLAYING = 0
               CALL "getKey" RETURNING KEYPRESSED
               MOVE FUNCTION CHAR(KEYPRESSED + 1) TO CHAR-PRESSED
               EVALUATE FUNCTION LOWER-CASE(CHAR-PRESSED)
                   WHEN "q" MOVE 0 TO KEEP-PLAYING
                   WHEN "a"
                       IF PLAYER-X > 1 THEN
                           PERFORM CLEAN-PLAYER-RACKET
                           SUBTRACT 1 FROM PLAYER-X
                           PERFORM DRAW-PLAYER-RACKET
                       END-IF
                  WHEN "d"
                       IF PLAYER-X < 32 THEN
                           PERFORM CLEAN-PLAYER-RACKET
                           ADD 1 TO PLAYER-X
                           PERFORM DRAW-PLAYER-RACKET
                       END-IF
               END-EVALUATE
           END-PERFORM.
       STOP RUN.

       DRAW-FIELD.
           PERFORM VARYING Y-VALUE FROM 1 BY 1 UNTIL Y-VALUE > 20
               IF Y-VALUE EQUALS 1 THEN
                   CALL "showAt" USING
                       BY REFERENCE " ________________________________"
                       BY VALUE 0
                       BY VALUE Y-VALUE
                       BY VALUE 1
                   END-CALL
               ELSE IF Y-VALUE EQUALS 20 THEN
                   CALL "showAt" USING
                        BY REFERENCE "\_______________________________/"
                        BY VALUE 0
                        BY VALUE Y-VALUE
                        BY VALUE 1
                    END-CALL
               ELSE IF Y-VALUE EQUALS 2 THEN
                   CALL "showAt" USING
                        BY REFERENCE "/"
                        BY VALUE 0
                        BY VALUE Y-VALUE
                        BY VALUE 1
                   END-CALL
                   CALL "showAt" USING
                        BY REFERENCE "\"
                        BY VALUE 33
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
                       BY VALUE 33
                       BY VALUE Y-VALUE
                       BY VALUE 4
                   END-CALL
               END-IF
           END-PERFORM.

       DRAW-PLAYER-RACKET.
           CALL "showAt" USING
               BY REFERENCE "_"
               BY VALUE PLAYER-X
               BY VALUE 18
               BY VALUE 5
           END-CALL.
       
       CLEAN-PLAYER-RACKET.
           CALL "showAt" USING
               BY REFERENCE " "
               BY VALUE PLAYER-X
               BY VALUE 18
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
               BY VALUE 18
               BY VALUE 0
           END-CALL.
       END PROGRAM GAME.
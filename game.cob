       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 Y-VALUE PIC 9(2) VALUE 0.
           01 X-VALUE PIC 9(2) VALUE 0.
           01 KEEP-PLAYING PIC 9 VALUE 1.
           01 KEYPRESSED PIC 9(4) VALUE 0.
           01 CHAR-PRESSED PIC X VALUE SPACE.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           CALL "hideCursor"
           PERFORM DRAW-FIELD
           PERFORM UNTIL KEEP-PLAYING = 0
               CALL "getKey" RETURNING KEYPRESSED
               MOVE FUNCTION CHAR(KEYPRESSED + 1) TO CHAR-PRESSED
               EVALUATE FUNCTION LOWER-CASE(CHAR-PRESSED)
                   WHEN "q" MOVE 0 TO KEEP-PLAYING
               END-EVALUATE
           END-PERFORM.
       STOP RUN.
       
       DRAW-FIELD.
           PERFORM VARYING Y-VALUE FROM 1 BY 1 UNTIL Y-VALUE > 20
               IF Y-VALUE = 1 THEN
                   CALL "showAt" USING
                       BY REFERENCE " ________________________________"
                       BY VALUE 0
                       BY VALUE Y-VALUE
                       BY VALUE 1
                   END-CALL
               ELSE IF Y-VALUE = 20 THEN
                   CALL "showAt" USING
                        BY REFERENCE "\_______________________________/"
                        BY VALUE 0
                        BY VALUE Y-VALUE
                        BY VALUE 1
                    END-CALL
               ELSE IF Y-VALUE = 2 THEN
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
       END PROGRAM GAME.
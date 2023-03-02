       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 KEEP-PLAYING PIC 9 VALUE 1.
           01 KEYPRESSED PIC 9(4) VALUE 0.
           01 CHAR-PRESSED PIC X VALUE SPACE.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           CALL "hideCursor"
           PERFORM UNTIL KEEP-PLAYING = 0
               CALL "getKey" RETURNING KEYPRESSED
               MOVE FUNCTION CHAR(KEYPRESSED + 1) TO CHAR-PRESSED
               EVALUATE FUNCTION LOWER-CASE(CHAR-PRESSED)
                   WHEN "q" MOVE 0 TO KEEP-PLAYING
               END-EVALUATE
           END-PERFORM.
       STOP RUN.
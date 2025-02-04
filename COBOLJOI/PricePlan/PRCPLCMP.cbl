       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRCPLCMP.
       AUTHOR. MainframeDev.
      *----------------------------------------------------------------*
      * This is the Test program in COBOL to replicate compare plan    *
      * price functionality                                            *
      *----------------------------------------------------------------*
      *----------------------------------------------------------------*
      *          WORKING STORAGE STARTS HERE                           *
      *----------------------------------------------------------------*
       WORKING-STORAGE SECTION.
      *
           01  WS-VARIABLES.
               05 WS-ERROR-TEXT              PIC X(250) VALUE SPACES.
               05 WS-AVG-READING             PIC 9(4)V9(6) VALUE ZEROES.
               05 ARRAY-INDEX                PIC 9(03) VALUE ZEROES.
               05 WS-READING-TOTAL           PIC 9(4)V9(5) VALUE ZEROES.
               05 WS-READING-MAX-DATE.
                 10  YEAR         PIC 9(4).
                 10  MONTH        PIC 9(2).
                 10  DAY          PIC 9(2).
               05 WS-READING-MAX-TIME.
                 10  HOURS        PIC 9(2).
                 10  MINUTE       PIC 9(2).
                 10  SECONDS       PIC 9(2).
               05 WS-READING-MIN-DATE.
                 10  YEAR         PIC 9(4).
                 10  MONTH        PIC 9(2).
                 10  DAY          PIC 9(2).
               05 WS-READING-MIN-TIME.
                 10  HOURS        PIC 9(2).
                 10  MINUTE       PIC 9(2).
                 10  SECONDS      PIC 9(2).
               05 WS-TIME-ELAPSED         PIC 9(04) VALUE ZEROES.
               05 WS-DARKPLAN-UNITRATE    PIC 9(2)V9(6) VALUE 10000000.
               05 WS-EVILPLAN-UNITRATE    PIC 9(2)V9(6) VALUE 24000000.
               05 WS-EVERYONE-UNITRATE    PIC 9(2)V9(6) VALUE 28000000.
               05 WS-DARKPLAN-COST        PIC 9(5)V9(4) VALUE ZEROES.
               05 WS-EVILPLAN-COST        PIC 9(5)V9(4) VALUE ZEROES.
               05 WS-EVERYONE-COST        PIC 9(5)V9(4) VALUE ZEROES.

           COPY MTRPLAN0.

           COPY MTRREAD0.
      *

      *----------------------------------------------------------------*
      *          Linkage section STARTS HERE                           *
      *----------------------------------------------------------------*
       LINKAGE SECTION.
      *
            COPY PRCPLN01.
      *----------------------------------------------------------------*
      *          -- PROCEDURE DIVISION --                              *
      *----------------------------------------------------------------*
       PROCEDURE DIVISION USING PRCPLANC.
       MAIN-LOGIC SECTION.
       PROGRAM-BEGIN.
      *
           PERFORM A0000-GET-MTR-DETAIL
              THRU A0000-EXIT

           PERFORM B0000-VALIDATE
              THRU B0000-EXIT
      *
           PERFORM C0000-GET-READING
              THRU C0000-EXIT

          PERFORM D0000-CALCULATE-COST
             THRU D0000-EXIT

           PERFORM S0000-THANKS
              THRU S0000-EXIT
           .
       PROGRAM-DONE.
           EXIT.

      *-----------------*
       A0000-GET-MTR-DETAIL.
      *-----------------*
           Move PRCPLANC-MTR-ID
             To UINFO-MTR-ID

            CALL PRCPLANCT
           USING MTRINFO
          .
       A0000-EXIT.
      *---------------------*
       B0000-VALIDATE.
      *---------------------*
      *-- Validation plan name
           IF POWER-PLAN-NAME = SPACES
              MOVE 'no Plan found for meter'
                TO WS-ERROR-TEXT
              DISPLAY WS-ERROR-TEXT
              GO TO PROGRAM-DONE
           END-IF
           .
       B0000-EXIT.
      *--------------------------------------------------------------*
       C0000-GET-READING.
      *--------------------------------------------------------------*
      *
           Move PRCPLANC-MTR-ID
             To C01-MTR-ID

            CALL MTRREADGT
           USING MTRREAD
           .
       C0000-EXIT.

      *--------------------------------------------------------------*
       D0000-CALCULATE-COST.
      *--------------------------------------------------------------*
      *
           PERFORM D1500-CALC-AVG-READING
              THRU D1500-EXIT

           PERFORM D1600-CALC-TIME-ELAPSED
              THRU D1600-EXIT

           DIVIDE WS-AVG-READING
               BY ARRAY-INDEX
           GIVING WS-AVG-READING

           MULTIPLY WS-AVG-READING
                BY WS-DARKPLAN-UNITRATE
             GIVING PRCPLANC-DARKPLAN-COST

           MULTIPLY WS-AVG-READING
                 BY WS-EVILPLAN-UNITRATE
            GIVING PRCPLANC-EVILPLAN-COST

           MULTIPLY WS-AVG-READING
                BY WS-EVERYONE-UNITRATE
           GIVING PRCPLANC-EVERYONE-COST
         .
       D0000-EXIT.

      *--------------------------------------------------------------*
       D1500-CALC-AVG-READING.
      *--------------------------------------------------------------*
      *
           Move ZEROES
             To WS-READING-TOTAL

            PERFORM
            VARYING ARRAY-INDEX FROM 1 BY 1
              UNTIL ARRAY-INDEX > READING-LEN.

               ADD C01-READING (ARRAY-INDEX)
                To WS-READING-TOTAL

            END-PERFORM

            DIVIDE WS-READING-TOTAL
                BY WS-TIME-ELAPSED
            GIVING WS-AVG-COST
        .
       D1500-EXIT.

      *--------------------------------------------------------------*
       D1600-CALC-TIME-ELAPSED.
      *--------------------------------------------------------------*
      *
            Move C01-READING-DATE (1)
              To WS-READING-MIN-DATE

            Move C01-READING-TIME (1)
              To WS-READING-MIN-TIME

            Move C01-READING-DATE (READING-LEN)
              To WS-READING-MAX-DATE

            Move C01-READING-TIME (READING-LEN)
              To WS-READING-MAX-TIME

      *  Calculate Time duration by utility program. Using sample value 120 for now.

            Move 120
              To WS-TIME-ELAPSED
              .
       D1600-EXIT.


      *--------------*
       S0000-THANKS.
      *--------------*
      *--Saying Good Bye and Exiting
           DISPLAY 'Thanks for using the service of JOI. Good Bye'
           PERFORM Z0000-CLOSING-FILES
           PERFORM Z0000-PROCESS-END
           .
       S0000-EXIT.
      *--------------------*
       Z0000-CLOSING-FILES.
      *--------------------*
           CLOSE READING-INFO
           IF WS-RDNG-INFO-STA NOT = '00'
              STRING 'Error in Closing reading file - '
                  WS-RDNG-INFO-STA
                DELIMITED BY SPACE
               INTO WS-ERROR-TEXT
              END-STRING
              DISPLAY WS-ERROR-TEXT
              GO TO Z0000-PROCESS-END
           END-IF
           .
       Z0000-EXIT.

       Z0000-PROCESS-END.
           GOBACK.
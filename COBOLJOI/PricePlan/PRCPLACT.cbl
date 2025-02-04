       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRCPLACT.
       AUTHOR. MainframeDev.
      *----------------------------------------------------------------*
      * This is the Test program in COBOL to get plan details from file*
      *  functionality                                                 *
      *----------------------------------------------------------------*
      *
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
      *
       FILE-CONTROL.
      *-- METER Details
           SELECT MTR-INFO
           ASSIGN TO 'MTRPLAN'
           ORGANIZATION IS INDEXED
           RECORD KEY IS UINFO-MTR-ID
           ACCESS MODE IS DYNAMIC
           FILE STATUS IS WS-MTR-INFO-STA.

       DATA DIVISION.
       FILE SECTION.
       FD  MTR-INFO
           LABEL RECORDS ARE STANDARD.
       01  MTR-REC.
           05 UINFO-MTR-ID       PIC X(12).
           05 USER-NAME          PIC X(50).
           05 POWER-SUPL-NAME    PIC X(50).
           05 POWER-PLAN-NAME    PIC X(50).
      *
      *----------------------------------------------------------------*
      *          WORKING STORAGE STARTS HERE                           *
      *----------------------------------------------------------------*
       WORKING-STORAGE SECTION.
      *
       01  WS-VARIABLES.
      *-- File Status fields
           05 WS-MTR-INFO-STA            PIC 9(02) VALUE ZEROES.

           05 WS-MTR-FOUND               PIC X(01) VALUE 'N'.

           05 WS-END-OF-FILE             PIC X(01) VALUE 'N'.

      *
           05 WS-ERROR-TEXT              PIC X(250) VALUE SPACES.
      *

      *----------------------------------------------------------------*
      *          Linkage section STARTS HERE                           *
      *----------------------------------------------------------------*
       LINKAGE SECTION.
      *
         COPY MTRPLAN0.
      *----------------------------------------------------------------*
      *          -- PROCEDURE DIVISION --                              *
      *----------------------------------------------------------------*
       PROCEDURE DIVISION USING MTRINFO.
       MAIN-LOGIC SECTION.
       PROGRAM-BEGIN.
      *
           PERFORM A0000-INITIALIZE
              THRU A0000-EXIT

           PERFORM B0000-GET-MTR-INFO
              THRU B0000-EXIT

           PERFORM S0000-THANKS
              THRU S0000-EXIT
           .
       PROGRAM-DONE.
           EXIT.

      *-----------------*
       A0000-INITIALIZE.
      *-----------------*
      *-- Open Files
           OPEN INPUT MTR-INFO
           IF WS-MTR-INFO-STA NOT = '00'
              STRING 'Error in opening meter INFO file - '
                  WS-MTR-INFO-STA
                DELIMITED BY SPACE
               INTO WS-ERROR-TEXT
              END-STRING
              DISPLAY WS-ERROR-TEXT
              GO TO PROGRAM-DONE
           END-IF
           .
       A0000-EXIT.

      *--------------------------------------------------------------*
       B0000-GET-MTR-INFO.
      *--------------------------------------------------------------*
      *
           MOVE 'N'
             TO WS-END-OF-FILE
                WS-MTR-FOUND

           PERFORM B1500-READ-MTR-DATA
                   THRU B1500-EXIT
            UNTIL WS-END-OF-FILE = 'Y'
               OR WS-MTR-FOUND = 'Y'
                      .
           .
       B0000-EXIT.

      *--------------------------------------------------------------*
        B1500-READ-MTR-DATA.
      *--------------------------------------------------------------*
      *-- Read the file for Plan details for meter
                READ MTR-INFO NEXT RECORD
                  AT END
                     MOVE 'Y'
                       TO WS-END-OF-FILE

                     MOVE 'Meter info not found'
                       To  WS-ERROR-TEXT

                     DISPLAY WS-ERROR-TEXT

                     GO TO C1500-EXIT

                  NOT AT END
                   IF MTRINFO-MTR-ID Of MTRINFO =
                      UINFO-USER-ID of MTR-REC

                      Move 'Y'
                        To WS-MTR-FOUND

                      Move MTR-REC
                        To MTR-INFO

                  END-IF
                END-READ
       .
       B1500-EXIT.

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
           CLOSE MTR-INFO
           IF WS-MTR-INFO-STA NOT = '00'
              STRING 'Error in Closing meter info file - '
                  WS-MTR-INFO-STA
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
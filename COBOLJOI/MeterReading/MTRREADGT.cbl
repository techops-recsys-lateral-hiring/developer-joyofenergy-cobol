       IDENTIFICATION DIVISION.
       PROGRAM-ID. MTRREADGT.
       AUTHOR. MainframeDev.
      *----------------------------------------------------------------*
      * This is the Test program in COBOL to replicate Meter Reading   *
      * get Functionality from a file                                  *
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

      *-- READING DETAIL
           SELECT READING-INFO
           ASSIGN TO 'MTRREAD'
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS WS-RDNG-INFO-STA.
       DATA DIVISION.
       FILE SECTION.
       FD  MTR-INFO
           LABEL RECORDS ARE STANDARD.
       01  LOGIN-RECORDS.
           05 UINFO-MTR-ID       PIC X(12).
           05 USER-NAME          PIC X(50).
           05 POWER-SUPL-NAME    PIC X(50).
      *
       FD  READING-INFO
           LABEL RECORDS ARE STANDARD.
       01  READING-REC.
           05 SMRT-MTR-ID       PIC X(12).
           05  READING-DATE.
               10  YEAR         PIC 9(4).
               10  MONTH        PIC 9(2).
               10  DAY          PIC 9(2).
           05  READING-TIME.
               10  HOURS        PIC 9(2).
               10  MINUTE       PIC 9(2).
               10  SECONDS      PIC 9(2).
           05 READING PIC 9(2)V9(5) VALUE ZEROES.

      *----------------------------------------------------------------*
      *          WORKING STORAGE STARTS HERE                           *
      *----------------------------------------------------------------*
       WORKING-STORAGE SECTION.
      *
       01  WS-VARIABLES.
      *-- File Status fields
           05 WS-RDNG-INFO-STA           PIC 9(02) VALUE ZEROES.
           05 WS-MTR-INFO-STA            PIC 9(02) VALUE ZEROES.
      *
           05 WS-ERROR-TEXT              PIC X(250) VALUE SPACES.
      *

      *----------------------------------------------------------------*
      *          Linkage section STARTS HERE                           *
      *----------------------------------------------------------------*
       LINKAGE SECTION.
      *
       COPY MTRREAD0.
      *----------------------------------------------------------------*
      *          -- PROCEDURE DIVISION --                              *
      *----------------------------------------------------------------*
       PROCEDURE DIVISION USING MTRREAD.
       MAIN-LOGIC SECTION.
       PROGRAM-BEGIN.
      *
           PERFORM A0000-INITIALIZE
              THRU A0000-EXIT

           PERFORM B0000-VALIDATE
              THRU B0000-EXIT
      *
           PERFORM C0000-GET-READING
              THRU C0000-EXIT

           PERFORM S0000-THANKS
              THRU S0000-EXIT
           .
       PROGRAM-DONE.
           EXIT.

      *-----------------*
       A0000-INITIALIZE.
      *-----------------*
      *-- Open Files
           OPEN INPUT READING-INFO
           IF WS-RDNG-INFO-STA NOT = '00'
              STRING 'Error in opening reading INFO file - '
                  WS-RDNG-INFO-STA
                DELIMITED BY SPACE
               INTO WS-ERROR-TEXT
              END-STRING
              DISPLAY WS-ERROR-TEXT
              GO TO PROGRAM-DONE
           END-IF
           .
       A0000-EXIT.
      *---------------------*
       B0000-VALIDATE.
      *---------------------*
      *-- Validation meter id
           IF C01-MTR-ID = SPACES
              MOVE 'INPUT METER ID IS BLANK'
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
      ** Implementaion pending
           .
       C0000-EXIT.

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
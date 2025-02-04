       IDENTIFICATION DIVISION.
       PROGRAM-ID. MTRREADST.
       AUTHOR. MainframeDev.
      *----------------------------------------------------------------*
      * This is the Test Project in COBOL to replicate Meter Reading   *
      * storage Functionality into a file                              *
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
           RECORD KEY IS USER-MTR-ID
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
       01  MTR-RECORDS.
           05 USER-MTR-ID        PIC X(12).
           05 USER-NAME          PIC X(50).
           05 POWER-SUPL-NAME    PIC X(50).
      *
       FD  READING-INFO
           LABEL RECORDS ARE STANDARD.
       01  READING-REC.
           05 MTR-ID            PIC X(12).
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
           05 ARRAY-INDEX                PIC 9(03) VALUE ZEROES.
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
           PERFORM C0000-STORE-READING
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
           OPEN OUTPUT READING-INFO
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
       C0000-STORE-READING.
      *--------------------------------------------------------------*
      *
           PERFORM C1500-STORE-READING-DATA
              THRU C1500-EXIT
           VARYING ARRAY-INDEX FROM 1 BY 1
           UNTIL ARRAY-INDEX > READING-LEN.
           .
       C0000-EXIT.
      *--------------------*
       C1500-STORE-READING-DATA.
      *--------------------*
      *
      *-- Write Reading data into file

           MOVE C01-MTR-ID
             TO MTR-ID

           MOVE C01-READING-DATE (ARRAY-INDEX)
             TO READING-DATE OF

           MOVE C01-READING-TIME (ARRAY-INDEX)
             TO READING-TIME

           MOVE C01-READING (ARRAY-INDEX)
              TO READING

            WRITE READING-REC
           .
       C1500-EXIT.
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
       01 MTRREAD.
           02 C01-MTR-ID PIC X(12).
           02 C01-READING-LEN PIC 9(4).
           02 C01-READING-DATA 1 TO 120 TIMES DEPENDING ON C01-READING-LEN.
              05  C01-READING-DATE.
                  10  YEAR         PIC 9(4).
                  10  MONTH        PIC 9(2).
                  10  DAY          PIC 9(2).
              05  C01-READING-TIME.
                  10  HOURS        PIC 9(2).
                  10  MINUTE       PIC 9(2).
                  10  SECONDS       PIC 9(2).
              05 C01-READING PIC 9(2)V9(5) VALUE ZEROES.

           01 PRCPLAN.
              02 PRCPLAN-MTR-ID PIC X(12).
              02 SUPL-NAME PIC X(50).
              02 PLAN-NAME PIC X(50).
              02 UNIT-RATE PIC 9(2)V9(6) VALUE ZEROES.
              02 PKTIME-DATA 7 TIMES.
                 05  DAYOFWEEK   PIC 9(1).
                 05  MULTIPLIER  PIC 9(2)V9(5) VALUE ZEROES.

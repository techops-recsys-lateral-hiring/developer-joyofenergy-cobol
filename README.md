# developer-joyofenergy-cobol

# Welcome to PowerDale

PowerDale is a small town with around 100 residents. Most houses have a smart meter installed that can save and send
information about how much power a house is drawing/using.

There are three major providers of energy in town that charge different amounts for the power they supply.

- _Dr Evil's Dark Energy_
- _The Green Eco_
- _Power for Everyone_

# Introducing JOI Energy

JOI Energy is a new start-up in the energy industry. Rather than selling energy they want to differentiate themselves
from the market by recording their customers' energy usage from their smart meters and recommending the best supplier to
meet their needs.

You have been placed into their development team, whose current goal is to produce COBOL programs which their customers and
smart meters will interact with using APIs.

Unfortunately, two members of the team are on annual leave, and another one has called in sick! You are left with
another ThoughtWorker to progress with the current user stories on the story wall. This is your chance to make an impact
on the business, improve the code base and deliver value.

## Users

To trial the new JOI software 5 people from the JOI accounts team have agreed to test the service and share their energy
data.

| User    | Smart Meter ID  | Power Supplier        |
| ------- | --------------- | --------------------- |
| Sarah   | `smart-meter-0` | Dr Evil's Dark Energy |
| Peter   | `smart-meter-1` | The Green Eco         |
| Charlie | `smart-meter-2` | Dr Evil's Dark Energy |
| Andrea  | `smart-meter-3` | Power for Everyone    |
| Alex    | `smart-meter-4` | The Green Eco         |

These values are used in the code and in the following examples too.

## Requirements

The project requires COBOL 85.

## Programs

Below is a list of COBOL programs with their respective input and output.

### Store Readings

Program - MTRREADST.cbl

Example of body

```input copybook data using copybook MTRREAD0.CPY
C01-MTR-ID      = smart-meter-0
C01-READING-LEN =  3
C01-READING-DATA 1 TO 120 TIMES DEPENDING ON C01-READING-LEN.
    C01-READING-DATE.
        YEAR  = 2025
        MONTH = 02
        DAY   = 01
    C01-READING-TIME.
        HOURS    =  11   
        MINUTE   =  05
        SECONDS  =  01 
    C01-READING  =  0.0503 

Parameters

| Parameter            | Description                                           |
| ---------------------| ----------------------------------------------------- |
| `C01-MTR-ID  `       | One of the smart meters' id listed above              |
| `C01-READING-LEN`    | The size of reading array                             |
| `C01-READING-DATE`   | The date when the _reading_ was taken                 |
| `C01-READING-TIME`   | The time when the _reading_ was taken                 |
| `C01-READING`        | The consumption in `kW` at the _time_ of the reading  |

Example readings

| Date              | Time            | Reading (`kW`) |
| ----------------- | --------------: | -------------: |
| `2025-02-01     ` |      110501     |         0.0503 |
| `2025-02-01     ` |      110602     |         0.0621 |
| `2025-02-01     ` |      110701     |         0.0222 |

In the above example, the smart meter sampled readings, in `kW`, every minute. Note that the reading is in `kW` and
not `kWH`, which means that each reading represents the consumption at the reading time. If no power is being consumed
at the time of reading, then the reading value will be `0`. Given that `0` may introduce new challenges, we can assume
that there is always some consumption, and we will never have a `0` reading value. These readings are then sent by the
smart meter to the application using API. There is a program in the application that calculates the `kWH` from these
readings.

Program store the reading data into a file MTRREAD.TXT

### Get Stored Readings

Program - MTRREADGT.cbl

Parameters

| Parameter      | Description                              |
| -------------- | ---------------------------------------- |
| `C01-MTR-ID`   | One of the smart meters' id listed above |


Example output using copybook MTRREAD0.CPY

C01-MTR-ID      = smart-meter-0
C01-READING-LEN =  3
C01-READING-DATA 1 TO 120 TIMES DEPENDING ON C01-READING-LEN.
    C01-READING-DATE.
        YEAR  = 2025
        MONTH = 02
        DAY   = 01
    C01-READING-TIME.
        HOURS    =  11   
        MINUTE   =  05
        SECONDS  =  01 
    C01-READING  =  0.0503 
    
    C01-READING-DATE.
        YEAR  = 2025
        MONTH = 02
        DAY   = 01
    C01-READING-TIME.
        HOURS    =  11   
        MINUTE   =  06
        SECONDS  =  02 
    C01-READING  =  0.0621 
    
    C01-READING-DATE.
        YEAR  = 2025
        MONTH = 02
        DAY   = 01
    C01-READING-TIME.
        HOURS    =  11   
        MINUTE   =  07
        SECONDS  =  01 
    C01-READING  =  0.0222 

### View Current Price Plan and Compare Usage Cost Against all Price Plans

Program - PRCPLCMP.CBL and PRCPLANACT.CBL

Parameters

| Parameter      | Description                              |
| -------------- | ---------------------------------------- |
| `PRCPLAN-MTR-ID` | One of the smart meters' id listed above |


Example output copybook PRCPLAN01.CPY
    PRCPLANC-DARKPLAN-COST = 0.0002
    PRCPLANC-EVILPLAN-COST = 0.0004
    PRCPLANC-EVERYONE-COST = 0.0020

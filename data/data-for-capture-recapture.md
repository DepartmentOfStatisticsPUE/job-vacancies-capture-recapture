# Data dictionary

## First 5 rows


```r
> head(m)
                                    id_unit                                    id_ad date_start   date_end  date_arch vacancies    q1    q2    q3    q4 q1_days q2_days q3_days q4_days
1: 1b4701354603e4f186a443940768aecf1e38d65c b88aaaf7d35782005f90dc1c9d2dc0dc27902285 2018-03-21 2018-04-03 2018-04-04         1  TRUE FALSE FALSE FALSE      10      NA      NA      NA
2: 32f40ce1c624214de376f791a6e0e365c5cdeea6 da840976961bcf05d9b670fbf9063a8e9e76277c 2018-11-21 2019-01-07 2019-01-07         1 FALSE FALSE FALSE  TRUE      NA      NA      NA      40
3: 623fa6eee4d0e31cf1db41724d4630ae35f8cec0 ed5193dabf23fe46eeee8df4aa532ef6c958831a 2018-03-15 2018-04-11 2018-04-11         1  TRUE FALSE FALSE FALSE      16      NA      NA      NA
4: 623fa6eee4d0e31cf1db41724d4630ae35f8cec0 282a00d492521b2f522d5e54cc0e4d9ee885e2cd 2018-03-16 2018-04-13 2018-04-10         1  TRUE FALSE FALSE FALSE      15      NA      NA      NA
5: 623fa6eee4d0e31cf1db41724d4630ae35f8cec0 7cd7a9ec93f21cdc3028f6ae67c49e484a47d8a1 2018-03-12 2018-04-30 2018-04-23         1  TRUE FALSE FALSE FALSE      19      NA      NA      NA
6: dd6e32263037e81f124a256869cf48ea319c0e22 3319f8670628fc65269b4450df964c260a1e3d63 2018-03-28 2018-04-15 2018-04-15         1  TRUE FALSE FALSE FALSE       3      NA      NA      NA
   woj pkd size sector source
1:   8   R    S      1   cbop
2:  12   A    D      1   cbop
3:  30   P    D      1   cbop
4:  30   P    D      1   cbop
5:  30   P    D      1   cbop
6:   2   P    D      1   cbop
```
## Columns and metadata

+ id_unit -- identifier of an entity (company); character
+ id_ad -- identifier of an job ad; character
+ date_start -- start date for the publishing period; date(YYYY-MM-DD)
+ date_end --  end date for the publishing period; date  (YYYY-MM-DD)
+ date_arch -- date of archiving; date (YYYY-MM-DD)
+ vacancies -- number of vacancies (for CBOP = 1+ , for Pracuj = 1); numeric
+ q1 -- an indicator variable whether ad period (date_start, date_end) covers the end of 2018Q1; boolean
+ q2 -- an indicator variable whether ad period (date_start, date_end) covers the end of 2018Q2; boolean
+ q3 -- an indicator variable whether ad period (date_start, date_end) covers the end of 2018Q3; boolean
+ q4 -- an indicator variable whether ad period (date_start, date_end) covers the end of 2018Q4; boolean
+ q1_days -- the number of days between date_start and the end of 2018Q1
+ q2_days -- the number of days between date_start and the end of 2018Q1
+ q3_days -- the number of days between date_start and the end of 2018Q1
+ q4_days -- the number of days between date_start and the end of 2018Q1
+ woj -- voivodeship (regions in Poland, 16 levels, dictionary: https://en.wikipedia.org/wiki/ISO_3166-2:PL); numeric 
+ pkd -- NACE sector (19 levels; dictionary: https://ec.europa.eu/competition/mergers/cases/index/nace_all.html); character
+ size -- size of the entity measured by number of employees (3 levels; M = small up to 9persons, S = medium 10-49, D = Big 50+); character
+ sector -- sector of the entity (2 levels; 1 = public, 2 = private)
+ source -- source of advertisement (2 levels; cbop, pracuj)


## Basic statistics

+ rows: 220307
+ columns: 19
+ unique entities: 53306
+ CBOP rows: 83695
+ Pracuj rows: 136612

## Summary of the data

```r
── Data Summary ────────────────────────
                           Values
Name                       m     
Number of rows             220307
Number of columns          19    
Key                        NULL  
_______________________          
Column type frequency:           
  character                5     
  Date                     3     
  logical                  4     
  numeric                  7     
________________________         
Group variables            None  

── Variable type: character ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   min   max empty n_unique whitespace
1 id_unit               0             1    40    40     0    53306          0
2 id_ad                 0             1    40    40     0   219538          0
3 pkd                   0             1     1     1     0       19          0
4 size                  0             1     1     1     0        3          0
5 source                0             1     4     6     0        2          0

── Variable type: Date ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate min        max        median     n_unique
1 date_start            0         1     2000-06-06 2018-12-31 2018-06-25      376
2 date_end              0         1     2018-03-31 2079-02-28 2018-07-30      573
3 date_arch        136612         0.380 2018-04-01 2020-02-20 2018-08-09      589

── Variable type: logical ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean count                  
1 q1                    0             1 0.268 FAL: 161290, TRU: 59017
2 q2                    0             1 0.284 FAL: 157829, TRU: 62478
3 q3                    0             1 0.280 FAL: 158709, TRU: 61598
4 q4                    0             1 0.190 FAL: 178383, TRU: 41924

── Variable type: numeric ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean     sd    p0   p25   p50   p75  p100 hist 
1 vacancies             0         1      1.53  3.43      1     1     1     1   300 ▇▁▁▁▁
2 q1_days          161290         0.268 19.0  26.5       0     9    17    25  4015 ▇▁▁▁▁
3 q2_days          157829         0.284 21.5  55.7       0     9    17    24  6598 ▇▁▁▁▁
4 q3_days          158709         0.280 24.1  46.0       0    11    19    26  4861 ▇▁▁▁▁
5 q4_days          178383         0.190 26.2  53.0       0    12    19    26  5864 ▇▁▁▁▁
6 woj                   0         1     16.1   8.52      2    12    14    24    32 ▃▇▁▃▃
7 sector                0         1      1.93  0.247     1     2     2     2     2 ▁▁▁▁▇
```
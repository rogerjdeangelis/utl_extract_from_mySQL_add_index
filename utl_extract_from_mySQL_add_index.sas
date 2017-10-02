Adding an index to a SAS table(or existing mySQL table) extracted from mySQL a

Not sure I fully understand your question

I don't have SQL server installed on my power workstation, however this is
how i would add and index to a SAS table that was extracted from mySQL.
You can install full blown open source mySQL in about 10
minutes. If you don't have SAS access to mySQL you can
use the express version of WPS/Proc R to get unlimited rows
from mysql into a SAS dataset. You might want to benchmark mySQL on a power
workstation against server SQL on Wed at 2:30pm.
No nrrd for 'proc import/export'.

TWO SOLUTIONS

WORKING CODE
   PASSTHRU

      proc sql;
         connect to mysql (user=root password="xxxxxxxx"
              database='sakila' port=3306);
           create
             table films(index=(film_id/unique)) as
             select  *
             from connection to mysql
               (select
                   film_id
                  ,title
               from
                  film);
         disconnect from mysql
     ;quit;

   LIBNAME

      libname mysqllib mysql user=root password="xxxxxxxx" database=sakila
         port=3306;

      data films1(index=(film_id/unique));
       set mysqllib.film;
      run;quit;

HAVE
====
    Table FILM table in mySQL
        (mySQL comes with the sakila database and tables like 'film')

    FILM in mySQL

     FILM_ID    TITLE

         1      ACADEMY DINOSAUR
         2      ACE GOLDFINGER
         3      ADAPTATION HOLES
         4      AFFAIR PREJUDICE
         5      AFRICAN EGG
         6      AGENT TRUMAN
         7      AIRPLANE SIERRA
         8      AIRPORT POLLOCK

WANT  (WORK.FILMS with index on FILM_ID)
=========================================

  WORK.FILMS

  Obs    FILM_ID    TITLE

    1        1      ACADEMY DINOSAUR
    2        2      ACE GOLDFINGER
    3        3      ADAPTATION HOLES
    4        4      AFFAIR PREJUDICE
    5        5      AFRICAN EGG
    6        6      AGENT TRUMAN
    7        7      AIRPLANE SIERRA
    8        8      AIRPORT POLLOCK


Alphabetic List of Indexes and Attributes

                            # of
                Unique    Unique
#    Index      Option    Values

1    FILM_ID    YES         1000


*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

just use the sakila database that comes with mySQL and
table film

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/

;

proc sql;
   connect to mysql (user=root password="xxxxxxxx"
        database='sakila' port=3306);
   create table films(index=(film_id/unique)) as select  *
     from connection to mysql
     (select * from film);
    disconnect from mysql;
quit;


libname mysqllib mysql user=root password="xxxxxxxx" database=sakila
   port=3306;

data films1(index=(film_id/unique));
 set mysqllib.film;
run;quit;

proc sql;
   connect to mysql (user=root password="sas28rlx"
        database='sakila' port=3306);
     execute( create unique index film_id on film (film_id)) by mysql;
    disconnect from mysql;
quit;



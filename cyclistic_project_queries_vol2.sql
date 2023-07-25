-- Creating Database
Create database bikeshare_cyclistic;
Use bikeshare_cyclistic;

-- Importing Data
/* (There are 12 individual files (one for each month), I'll import all the files one by one into 12 
   separate tables) */
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cyclistic_latest_files/202209-divvy-tripdata.csv'
into table sep_2022_vol2
fields terminated by ','
 -- optionally enclosed by '"'
ignore 1 lines;
/* (I created 12 tables for all 12 files and used the above 'load data infile' command to import the data.
    I had to convert 'end_lat' and 'end_lng' columns in all the tables to 'Varchar' datatype because these
	columns had some missing values and 'Integer' type columns don't allow Null values) */

-- Data Cleaning & Transformation
#1 june_2022 table
# i- Duplicates
select ride_id
from june_2022
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from june_2022;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table june_2022
modify started_at datetime not null;
alter table june_2022
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table june_2022
add column trip_duration int not null;
# adding values to trip_duration column from 'started_at and ended_at' columns
update june_2022
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table june_2022
add column day_name varchar(255)  null;
update june_2022
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table june_2022
add column duration_minutes decimal(10,2) null after trip_duration;
update june_2022
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table june_2022
add column month_name varchar(255) null after day_name;
update june_2022
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from june_2022
where member_casual is null or member_casual = '';
select distinct member_casual
from june_2022;               -- it has two distinct values (casual, member)
# (start_station_name and start_station_id columns have more than 94,000 missing values, while
#  end_station_name and end_station_id columns have more than 100,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */
   
#2 july_2022 table
# i- Duplicates
select ride_id
from july_2022
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from july_2022;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table july_2022
modify started_at datetime not null;
alter table july_2022
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table july_2022
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update july_2022
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table july_2022
add column day_name varchar(255) null after trip_duration;
update july_2022
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table july_2022
add column duration_minutes decimal(10,2) null after trip_duration;
update july_2022
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table july_2022
add column month_name varchar(255) null after day_name;
update july_2022
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from july_2022
where member_casual is null or member_casual = '';
select distinct member_casual
from july_2022;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from aug_2022
where start_station_name is null or start_station_name = '';
select count(*)
from aug_2022
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 112,000 missing values, while
#  end_station_name and end_station_id columns have more than 120,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */   

#3 aug_2022 table
# i- Duplicates
select ride_id
from aug_2022
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from aug_2022;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table aug_2022
modify started_at datetime not null;
alter table aug_2022
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table aug_2022
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update aug_2022
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table aug_2022
add column day_name varchar(255) null after trip_duration;
update aug_2022
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table aug_2022
add column duration_minutes decimal(10,2) null after trip_duration;
update aug_2022
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table aug_2022
add column month_name varchar(255) null after day_name;
update aug_2022
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from aug_2022
where member_casual is null or member_casual = '';
select distinct member_casual
from aug_2022;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from aug_2022
where start_station_name is null or start_station_name = '';
select count(*)
from aug_2022
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 112,000 missing values, while
#  end_station_name and end_station_id columns have more than 120,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */

#4 sep_2022 table
# i- Duplicates
select ride_id
from sep_2022
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from sep_2022;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table sep_2022
modify started_at datetime not null;
alter table sep_2022
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table sep_2022
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update sep_2022
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table sep_2022
add column day_name varchar(255) null after trip_duration;
update sep_2022
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table sep_2022
add column duration_minutes decimal(10,2) null after trip_duration;
update sep_2022
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table sep_2022
add column month_name varchar(255) null after day_name;
update sep_2022
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from sep_2022
where member_casual is null or member_casual = '';
select distinct member_casual
from sep_2022;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from sep_2022
where start_station_name is null or start_station_name = '';
select count(*)
from sep_2022
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 103,000 missing values, while
#  end_station_name and end_station_id columns have more than 111,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */
   
#5 oct_2022 table
# i- Duplicates
select ride_id
from oct_2022
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from oct_2022;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table oct_2022
modify started_at datetime not null;
alter table oct_2022
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table oct_2022
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update oct_2022
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table oct_2022
add column day_name varchar(255) null after trip_duration;
update oct_2022
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table oct_2022
add column duration_minutes decimal(10,2) null after trip_duration;
update oct_2022
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table oct_2022
add column month_name varchar(255) null after day_name;
update oct_2022
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from oct_2022
where member_casual is null or member_casual = '';
select distinct member_casual
from oct_2022;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from oct_2022
where start_station_name is null or start_station_name = '';
select count(*)
from oct_2022
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 91,000 missing values, while
#  end_station_name and end_station_id columns have more than 96,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */
   
#6 nov_2022 table
# i- Duplicates
select ride_id
from nov_2022
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from nov_2022;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table nov_2022
modify started_at datetime not null;
alter table nov_2022
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table nov_2022
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update nov_2022
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table nov_2022
add column day_name varchar(255) null after trip_duration;
update nov_2022
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table nov_2022
add column duration_minutes decimal(10,2) null after trip_duration;
update nov_2022
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table nov_2022
add column month_name varchar(255) null after day_name;
update nov_2022
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from nov_2022
where member_casual is null or member_casual = '';
select distinct member_casual
from nov_2022;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from nov_2022
where start_station_name is null or start_station_name = '';
select count(*)
from nov_2022
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 51,000 missing values, while
#  end_station_name and end_station_id columns have more than 54,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */
   
#7 dec_2022 table
# i- Duplicates
select ride_id
from dec_2022
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from dec_2022;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table dec_2022
modify started_at datetime not null;
alter table dec_2022
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table dec_2022
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update dec_2022
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table dec_2022
add column day_name varchar(255) null after trip_duration;
update dec_2022
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table dec_2022
add column duration_minutes decimal(10,2) null after trip_duration;
update dec_2022
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table dec_2022
add column month_name varchar(255) null after day_name;
update dec_2022
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from dec_2022
where member_casual is null or member_casual = '';
select distinct member_casual
from dec_2022;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from dec_2022
where start_station_name is null or start_station_name = '';
select count(*)
from dec_2022
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 29,000 missing values, while
#  end_station_name and end_station_id columns have more than 31,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */


#8 jan_2023 table
# i- Duplicates
select ride_id
from jan_2023
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from jan_2023;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table jan_2023
modify started_at datetime not null;
alter table jan_2023
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table jan_2023
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update jan_2023
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table jan_2023
add column day_name varchar(255) null after trip_duration;
update jan_2023
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table jan_2023
add column duration_minutes decimal(10,2) null after trip_duration;
update jan_2023
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table jan_2023
add column month_name varchar(255) null after day_name;
update jan_2023
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from jan_2023
where member_casual is null or member_casual = '';
select distinct member_casual
from jan_2023;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from jan_2023
where start_station_name is null or start_station_name = '';
select count(*)
from jan_2023
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 26,000 missing values, while
#  end_station_name and end_station_id columns have more than 27,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */
   

#9 fab_2023 table
# i- Duplicates
select ride_id
from fab_2023
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from fab_2023;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table fab_2023
modify started_at datetime not null;
alter table fab_2023
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table fab_2023
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update fab_2023
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table fab_2023
add column day_name varchar(255) null after trip_duration;
update fab_2023
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table fab_2023
add column duration_minutes decimal(10,2) null after trip_duration;
update fab_2023
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table fab_2023
add column month_name varchar(255) null after day_name;
update fab_2023
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from fab_2023
where member_casual is null or member_casual = '';
select distinct member_casual
from fab_2023;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from fab_2023
where start_station_name is null or start_station_name = '';
select count(*)
from fab_2023
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 25,000 missing values, while
#  end_station_name and end_station_id columns have more than 26,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */
   
#10 mar_2023 table
# i- Duplicates
select ride_id
from mar_2023
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from mar_2023;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table mar_2023
modify started_at datetime not null;
alter table mar_2023
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table mar_2023
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update mar_2023
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table mar_2023
add column day_name varchar(255) null after trip_duration;
update mar_2023
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table mar_2023
add column duration_minutes decimal(10,2) null after trip_duration;
update mar_2023
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table mar_2023
add column month_name varchar(255) null after day_name;
update mar_2023
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from mar_2023
where member_casual is null or member_casual = '';
select distinct member_casual
from mar_2023;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from mar_2023
where start_station_name is null or start_station_name = '';
select count(*)
from mar_2023
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 35,000 missing values, while
#  end_station_name and end_station_id columns have more than 38,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */
   

#11 april_2023 table
# i- Duplicates
select ride_id
from april_2023
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from april_2023;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table april_2023
modify started_at datetime not null;
alter table april_2023
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table april_2023
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update april_2023
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table april_2023
add column day_name varchar(255) null after trip_duration;
update april_2023
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table april_2023
add column duration_minutes decimal(10,2) null after trip_duration;
update april_2023
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table april_2023
add column month_name varchar(255) null after day_name;
update april_2023
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from april_2023
where member_casual is null or member_casual = '';
select distinct member_casual
from april_2023;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from april_2023
where start_station_name is null or start_station_name = '';
select count(*)
from april_2023
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 63,000 missing values, while
#  end_station_name and end_station_id columns have more than 68,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */
   

#12 may_2023 table
# i- Duplicates
select ride_id
from may_2023
group by ride_id
having count(*) > 1;   # no duplicates were found
# ii- inspecting rideable_type column for any mistakes
select distinct(rideable_type)
from may_2023;        # 3 distinct bike types (no spelling mistakes)
# iii- Changing 'started_at and ended_at' columns datatype from 'text' to 'datetime'
alter table may_2023
modify started_at datetime not null;
alter table may_2023
modify ended_at datetime not null;
# iv- Adding new columns 
-- #i duration column
alter table may_2023
add column trip_duration int not null after ended_at;
# adding values to trip_duration column from 'started_at and ended_at' columns
update may_2023
set trip_duration = unix_timestamp(ended_at)-unix_timestamp(started_at);
-- #ii day column
alter table may_2023
add column day_name varchar(255) null after trip_duration;
update may_2023
set day_name = dayname(started_at);
-- #iii duration_in_minutes column
alter table may_2023
add column duration_minutes decimal(10,2) null after trip_duration;
update may_2023
set duration_minutes = trip_duration/60;
-- #iv Month column
alter table may_2023
add column month_name varchar(255) null after day_name;
update may_2023
set month_name = monthname(started_at);
-- v- Inspecting 'member_casual' column
select count(*)
from may_2023
where member_casual is null or member_casual = '';
select distinct member_casual
from may_2023;               -- it has two distinct values (casual, member)
-- vi- Inspecting start_station_name/id and end_station_name/id columns
select count(*)
from may_2023
where start_station_name is null or start_station_name = '';
select count(*)
from may_2023
where end_station_name is null or end_station_name = '';
# (start_station_name and start_station_id columns have more than 89,000 missing values, while
#  end_station_name and end_station_id columns have more than 95,000 missing values)
/* Since the 'start_station_id, end_station_id, start_station_name and end_station_name' columns have
   a lot of missing values, I'll not include them in my final table */

-- Some of the tables had extra " in data in their columns, so I used following queries to get rid of them
update may_2023 set ride_id = replace(ride_id, '"', '');
update may_2023 set rideable_type = replace(rideable_type, '"', '');
update may_2023 set started_at = replace(started_at, '"', '');
update may_2023 set ended_at = replace(ended_at, '"', '');
update may_2023 set start_station_name = replace(start_station_name, '"', '');
update may_2023 set start_station_id = replace(start_station_id, '"', '');
update may_2023 set end_station_name = replace(end_station_name, '"', '');
update may_2023 set end_station_id = replace(end_station_id, '"', '');
update may_2023 set member_casual = replace(member_casual, '"', '');


-- Craeating a complete dataset with data from all 12 tables 
-- this table will have the following columns
-- (ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual)
create table bikeshare_all_tables
select *
from (
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from june_2022
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from july_2022
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from aug_2022
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from sep_2022
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from oct_2022
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from nov_2022
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from dec_2022
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from jan_2023
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from fab_2023
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from mar_2023
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from april_2023
		union all
		select ride_id, rideable_type, started_at, ended_at, trip_duration, duration_minutes, day_name, month_name, member_casual
		from may_2023
		)tbl;

-- Adding a new column 'Hours' for hour_of_the_day
alter table bikeshare_all_tables
modify hour int null;
update bikeshare_all_tables
set hour = hour(started_at);
-- Changing Datatypes for 'bikeshare_all_tables' to optimize query execution
alter table bikeshare_all_tables modify ride_id varchar(20);
alter table bikeshare_all_tables modify rideable_type varchar(15);
alter table bikeshare_all_tables modify trip_duration int null;

alter table bikeshare_all_tables modify day_name varchar(12);
alter table bikeshare_all_tables modify month_name varchar(12);
alter table bikeshare_all_tables modify member_casual varchar(10);
-- Creating Indexes for 'bikeshare_all_tables' to optimize query execution
CREATE INDEX idx_ride_id ON bikeshare_all_tables (ride_id);
CREATE INDEX idx_rideable_type ON bikeshare_all_tables (rideable_type);
CREATE INDEX idx_started_at ON bikeshare_all_tables (started_at);
CREATE INDEX idx_ended_at ON bikeshare_all_tables (ended_at);
CREATE INDEX idx_trip_duration ON bikeshare_all_tables (trip_duration);
CREATE INDEX idx_duration_minutes ON bikeshare_all_tables (duration_minutes);
CREATE INDEX idx_day_name ON bikeshare_all_tables (day_name);
CREATE INDEX idx_month_name ON bikeshare_all_tables (month_name);
CREATE INDEX idx_member_casual ON bikeshare_all_tables (member_casual);


-- Data Cleaning 'bikeshare_all_tables'
select max(duration_minutes), min(duration_minutes)
from bikeshare_all_tables;
# there are some negative values in the 'duration_minutes' column which can't be right, so I'll delete them
# I'll also get rid of values that are less than 1minute or greater than 24hours (these are outliers)
select count(*)
from bikeshare_all_tables
where duration_minutes < 1 or duration_minutes > 1440;
# A total of '151258' rows will be deleted, which makes around 2.6% of the whole data
delete from bikeshare_all_tables
where duration_minutes < 1 or duration_minutes > 1440;
# inspecting day_name, month_name and member_casual columns
select distinct member_casual -- distinct day_name, distinct month_name
from bikeshare_all_tables;

-- Analyzing 'bikeshare_all_tables'
#1 Total trips, percent trips for each user type
select *, round(trips_count/total_trips*100,2) as percent_trips
from (
		select member_casual, count(*) as trips_count,
			   (select count(*) from bikeshare_all_tables) as total_trips
		from bikeshare_all_tables
		group by member_casual
	 )tbl;
     
# Average trip duration
select round(avg(duration_minutes),2) Avg_duration_min
from bikeshare_all_tables;

# bike type preferences
select member_casual, rideable_type, count(*) as total_trips, 
	   round(avg(duration_minutes),2) as avg_duration
from bikeshare_all_tables
group by member_casual, rideable_type
order by member_casual, total_trips desc;

# Total trips and Average duration by Day
with day_cte as (
			select member_casual, day_name, weekday(started_at)+1 day_number, duration_minutes
			from bikeshare_all_tables
            )
select member_casual, day_name, day_number, count(*) as total_trips, avg(duration_minutes) as avg_duration
from day_cte
group by member_casual, day_number, day_name
order by member_casual, day_number;

# Total trips and Average duration by Month
select member_casual, month_name, extract(month from started_at) as month_number , 
	   count(*) as total_trips
from bikeshare_all_tables
group by member_casual, month_name, month_number
order by member_casual, month_number;

# Peak hours
select member_casual, hour, count(*) as total_trips, 
	   avg(duration_minutes) as Avg_duration
from bikeshare_all_tables
group by member_casual, hour
order by member_casual, hour;














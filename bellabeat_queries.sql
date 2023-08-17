-- CREATE DATABASE

create database bellabeat;
use bellabeat;


-- IMPORT DATA

/* I'll be using "table data import wizard" to import structure of all the tables from their respective files. 
   Then I'll truncate these tables and use "Load data infile" command to import data into all of these tables*/

# I'll use the following query to import data into all tables by just changing name of the file

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bellabeat_files/dailyactivity_merged.csv'
into table dailyactivity_merged
fields terminated by ','
optionally enclosed by '"'
ignore 1 lines;

/* 'id' column in all the tables was showing error during data import "that some of the values are too big", 
    so I changed its datatype from 'int' to 'bigint' for all tables */
# I did this for all the tables
alter table dailyactivity_merged
modify id bigint not null;


-- REVIEWING THE DATA TABLES

/* I'll be focusing on tables which have 'daily' and 'hourly' details of users because from these tables
   I can extract the most useful and meaningful information.*/ 
/* so, now I have 6 tables
   i. dailyactivity_tbl, ii. hourlycalories_tbl, iii. hourlyintensities_tbl, 
   iv. dailysleep_tbl, v. hourlysteps_tbl vi. weightloginfo_tbl */
/* on reviewing all these tables, I found that 'weightloginfo_tbl' table doesn't have reliable or
   consistent information, so I'll not use this table for my analysis */
   
   
-- CLEANING DATA

# Removing Irrelivant columns
select *
from dailyactivity_tbl;
/* columns to remove: LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, 
					  LightActiveDistance, SedentaryActiveDistance */
alter table dailyactivity_tbl
drop column LoggedActivitiesDistance, 
drop column VeryActiveDistance, 
drop column ModeratelyActiveDistance, 
drop column LightActiveDistance, 
drop column SedentaryActiveDistance;

select *
from dailysleep_tbl;
select *
from hourlycalories_tbl;
select *
from hourlyintensities_tbl;
select *
from hourlysteps_tbl;
/* All other tables have no extra or irrlevant columns */

# Checking Data types of columns
describe dailyactivity_tbl;
/* activitydate column is 'text' datatype I'll change it to 'date' rename it to 'date' */
update  dailyactivity_tbl
set activitydate = str_to_date(activitydate, '%m/%d/%Y');
alter table dailyactivity_tbl
change column activitydate date date;

describe dailysleep_tbl;
/* sleepday column is 'text' datatype I'll change it to 'datetime' rename it to 'date_time' */
update dailysleep_tbl
set sleepday = str_to_date(sleepday, '%m/%d/%Y %H:%i:%s AM');
alter table dailysleep_tbl
change column sleepday date_time datetime;

describe hourlycalories_tbl;
/* ActivityHour column is 'text' datatype I'll change it to 'datetime' rename it to 'date_time' */
update hourlycalories_tbl
set activityhour = str_to_date(activityhour, '%m/%d/%Y %H:%i');
alter table hourlycalories_tbl
change column ActivityHour date_time datetime;

describe hourlysteps_tbl;
/* ActivityHour column is 'text' datatype I'll change it to 'datetime' rename it to 'date_time' */
update hourlysteps_tbl
set activityhour = str_to_date(activityhour, '%m/%d/%Y %h:%i:%s %p');
alter table hourlysteps_tbl
change column ActivityHour date_time datetime;

describe hourlyintensities_tbl;
/* ActivityHour column is 'text' datatype I'll change it to 'datetime' rename it to 'date_time' */
update hourlyintensities_tbl
set activityhour = str_to_date(activityhour, '%m/%d/%Y %h:%i:%s %p');
alter table hourlyintensities_tbl
change column ActivityHour date_time datetime;


#1 Inspecting 'dailyactivity_tbl'
select *
from dailyactivity_tbl;
select count(distinct id) as total_users
from dailyactivity_tbl;        -- 33 users
select count(distinct date) as total_days
from dailyactivity_tbl;        -- 31 days
/* Checking if all the activity minutes add upto 24 hours or 1440 minutes, if not then those values are invalid */
select *
from 
   (	
    select VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, 
		   (VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes) as total_minutes
	from dailyactivity_tbl
    )tbl
where total_minutes > 1440;     -- NO invalid values

/* finding duplicates */
select id, date, TotalSteps, TotalDistance, TrackerDistance, Calories, count(*)
from dailyactivity_tbl
group by id, date, TotalSteps, TotalDistance, TrackerDistance, Calories
having count(*) > 1;            -- 0 Duplicates

/* Finding Null/missing values */
SELECT
	SUM(CASE WHEN id is null or id = 0 then 1 else 0 end) as missing_id,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Missing_ActivityDate,
    SUM(CASE WHEN TotalSteps = 0 THEN 1 ELSE 0 END) AS Zero_TotalSteps,
    SUM(CASE WHEN TotalDistance = 0 THEN 1 ELSE 0 END) AS Zero_TotalDistance,
    SUM(CASE WHEN TrackerDistance = 0 THEN 1 ELSE 0 END) AS Zero_TrackerDistance,
    SUM(CASE WHEN VeryActiveMinutes = 0 THEN 1 ELSE 0 END) AS Zero_VeryActiveMinutes,
    SUM(CASE WHEN FairlyActiveMinutes = 0 THEN 1 ELSE 0 END) AS Zero_FairlyActiveMinutes,
    SUM(CASE WHEN LightlyActiveMinutes = 0 THEN 1 ELSE 0 END) AS Zero_LightlyActiveMinutes,
    SUM(CASE WHEN SedentaryMinutes = 0 THEN 1 ELSE 0 END) AS Zero_SedentaryMinutes,
    SUM(CASE WHEN Calories = 0 THEN 1 ELSE 0 END) AS Zero_Calories
FROM dailyactivity_tbl;
/* ID and date column as expected don't have any missing values, but total_steps column has 77 values as 0
   which can't be right because if a person has used the device He must have walked atleast 1 step that day.
   So I'll remove these entries (with 0 step count) */
delete from dailyactivity_tbl
where TotalSteps = 0;
/* if totalsteps can't be 0 then calories also can't be zero */
select count(*)
from dailyactivity_tbl
where Calories = 0;        -- no entries with 0 calories


#2 Inspecting 'dailysleep_tbl'
select *
from dailysleep_tbl;
select count(distinct id) as total_users
from dailysleep_tbl;        -- 24 users
select count(distinct date_time) as total_days
from dailysleep_tbl;        -- 31 days

/* finding duplicates */
select * ,count(*) as duplicates
from dailysleep_tbl
group by id, date_time, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
having count(*) > 1;            -- 3 Duplicates

/* Removing duplicates */
/* since ids are also duplicated I'll add a new column called 'row_num' to give each row a unique identifier.
   which will make it easy to remove duplicates */
alter table dailysleep_tbl
add column row_num int auto_increment, add primary key (row_num);

/* deleting duplicates using 'row_num' column */
delete from dailysleep_tbl
where row_num in (select * from
								 (select max(row_num) as rn
								 from dailysleep_tbl 
								 group by id, date_time, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
								 having count(*) > 1
                  )tbl);
                  
/* finding invalid values (values that are greater than 1440 mintues or 24 hours) */
select *
from dailysleep_tbl
where TotalMinutesAsleep > 1440 or TotalTimeInBed > 1440;   -- NO invalid values

/* Adding a new column 'date' from 'date_time' */
alter table dailysleep_tbl
add column date date after date_time;
update dailysleep_tbl
set date = date(date_time);

#3 Inspecting 'hourlycalories_tbl'
select *
from hourlycalories_tbl;
select count(*)
from hourlycalories_tbl;  -- 22099 total records
select count(distinct id) as total_users
from hourlycalories_tbl;        -- 33 users
select count(distinct (date(date_time))) as total_days, 
	   count(distinct (time(date_time))) as total_hours
from hourlycalories_tbl;        -- 31 days (containing 24 hours)

/* finding duplicates */
select *, count(*) as duplicates
from hourlycalories_tbl
group by id, date_time, Calories
having count(*) > 1;           -- No duplicates

/* identifying Missing/Null values */
select sum(case when id is null or id = 0 then 1 else 0 end) as missing_ids,
       sum(case when date_time is null or date_time = 0 then 1 else 0 end) as missing_dates,
       sum(case when Calories is null or Calories = 0 then 1 else 0 end) as missing_calories
from hourlycalories_tbl;         -- No missing or Null values


#4 Inspecting 'hourlyintensities_tbl'
select *
from hourlyintensities_tbl;
select count(*)
from hourlyintensities_tbl;  -- 22099 total records
select count(distinct id) as total_users
from hourlyintensities_tbl;        -- 33 users
select count(distinct (date(date_time))) as total_days, 
	   count(distinct (time(date_time))) as total_hours
from hourlyintensities_tbl;        -- 31 days (containing 24 hours)

/* finding duplicates */
select *, count(*) as duplicates
from hourlyintensities_tbl
group by id, date_time, TotalIntensity, AverageIntensity
having count(*) > 1;           -- No duplicates

/* identifying Missing/Null values */
select *
from hourlyintensities_tbl
where id is null  or id = 0
   or date_time is null or date_time = 0 or
      totalintensity is null or totalintensity = 0 or
      averageintensity is null or averageintensity = 0;
select sum(case when id is null or id = 0 then 1 else 0 end) as missing_ids,
       sum(case when date_time is null or date_time = 0 then 1 else 0 end) as missing_dates,
       sum(case when TotalIntensity is null or TotalIntensity = 0 then 1 else 0 end) as missing_intensities,
       sum(case when averageintensity is null or averageintensity = 0 then 1 else 0 end) as missing_avg_inensities
from hourlyintensities_tbl;         -- '9097' missing values in both 'Totalintensity and AverageIntensity' columns


#5 Inspecting 'hourlysteps_tbl'
select *
from hourlysteps_tbl;
select count(*)
from hourlysteps_tbl;  -- 22099 total records
select count(distinct id) as total_users
from hourlysteps_tbl;        -- 33 users
select count(distinct (date(date_time))) as total_days, 
	   count(distinct (time(date_time))) as total_hours
from hourlysteps_tbl;        -- 31 days (containing 24 hours)

/* finding duplicates */
select *, count(*) as duplicates
from hourlysteps_tbl
group by id, date_time, StepTotal
having count(*) > 1;           -- No duplicates

/* identifying Missing/Null values */
select sum(case when id is null or id = 0 then 1 else 0 end) as missing_ids,
       sum(case when date_time is null or date_time = 0 then 1 else 0 end) as missing_dates,
       sum(case when steptotal is null or steptotal = 0 then 1 else 0 end) as missing_steptotal
from hourlysteps_tbl;         -- '9297' missing values in 'Steptotal' column



-- TRANSFORM DATA

/* Now I'll combine data from tables containing data related to daily activity (dailyactivity_tbl, dailysleep_tbl)
   into a new table called 'daily_activity_sleep' and tables containing hourly data (hourlycalories_tbl,
   hourlyintensities_tbl, hourlysteps_tbl) into a new table called 'hourly_activity' */

-- combining 'dailyactivity_tbl' and 'dailysleep_tbl'
create table daily_activity_sleep
select tbl1.*, tbl2.TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
from dailyactivity_tbl  tbl1
join dailysleep_tbl     tbl2  using(id, date);
/* the above table has data for '24 users' */

-- combining 'hourlycalories_tbl' , 'hourlyintensities_tbl' and 'hourlysteps_tbl'
create table hourly_activity
select tbl1.*, tbl2.TotalIntensity, tbl2.AverageIntensity, tbl3.StepTotal
from hourlycalories_tbl      tbl1
join hourlyintensities_tbl   tbl2    using (id, date_time)
join hourlysteps_tbl         tbl3    using (id, date_time);

/* Adding a new column 'day' to 'daily_activity_sleep', 'dailyactivity_tbl', 'hourly_activity' */
#1 adding day column to 'daily_activity_sleep'
alter table daily_activity_sleep
add column day varchar(10) after date;
update daily_activity_sleep
set day = dayname(date);

#2 adding day column to 'daily_activity'
alter table dailyactivity_tbl
add column day varchar(10) after date;
update dailyactivity_tbl
set day = dayname(date);

#3 adding day column to 'hourly_activity'
alter table hourly_activity
add column day varchar(10) after date_time;
update hourly_activity
set day = dayname(date_time);

/* Adding a new column 'total_active_minutes' in these 2 tables */
#1 adding 'total_active_minutes' column to 'daily_activity_sleep'
alter table daily_activity_sleep
add column total_active_minutes int after totalsteps;
UPDATE daily_activity_sleep
SET total_active_minutes = veryactiveminutes + fairlyactiveminutes + lightlyactiveminutes;

#2 adding 'total_active_minutes' column to 'dailyactivity_tbl'
alter table dailyactivity_tbl
add column total_active_minutes int after totalsteps;
UPDATE dailyactivity_tbl
SET total_active_minutes = veryactiveminutes + fairlyactiveminutes + lightlyactiveminutes;

/* Adding a new column 'total_active_minutes' in 'daily_activity_sleep'*/
alter table daily_activity_sleep
add column minutes_awake int ;
UPDATE daily_activity_sleep
SET minutes_awake = totaltimeinbed - totalminutesasleep;

/* Removing distance related columns, as they don't much info about usage preferences 
   or health profile, because
   for that we have totalsteps and activity minutes data */
   
#1 removing distance columns from 'daily_activity_sleep'
alter table daily_activity_sleep
drop column TotalDistance,
drop column TrackerDistance;

#2 removing distance columns from 'dailyactivity_tbl'
alter table dailyactivity_tbl
drop column TotalDistance,
drop column TrackerDistance;

/* FINAL COMPLETE TABLES */
select *
from daily_activity_sleep;
select *
from dailyactivity_tbl;
select *
from hourly_activity;



-- ANALYSIS

/* Which device features are used most often */
#1 Total users of each feature
select count(distinct id) as sleeptracker_users
from daily_activity_sleep;          -- 24 users
select count(distinct id) as stepstracker_users
from dailyactivity_tbl;             -- 33 users


#2 Number of times each feature used
select count(id) as sleeptracker_used
from daily_activity_sleep;          -- 410
select count(id) as stepstracker_used
from dailyactivity_tbl;             -- 863 users





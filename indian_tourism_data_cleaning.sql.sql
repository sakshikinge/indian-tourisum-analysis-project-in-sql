create database indian_tourisum;
use indian_tourisum;

describe `top indian places to visit`;
RENAME TABLE `top indian places to visit` TO tourist_places;
describe tourist_places;


-- rename first column bcoz its unnamed
alter table tourist_places
change column `MyUnknownColumn` Id int;
alter table tourist_places
change column `id` Id int;

-- check the first few records to understand data
select * from tourist_places
limit 10;

-- check null and empty values in each column
select
	sum(case when Zone is null or Zone = '' then 1 end) as null_zone,
    sum(case when State is null or State = '' then 1 end) as null_zone,
    sum(case when City is null or City = '' then 1 end) as null_city,
    sum(case when `Name` is null or `Name` = '' then 1 end) as null_Name,
    sum(case when  Type IS NULL OR Type = '' THEN 1 END) AS null_type,
    SUM(CASE WHEN `Establishment Year` IS NULL THEN 1 END) AS null_est_year,
    SUM(CASE WHEN `time needed to visit in hrs` IS NULL THEN 1 END) AS null_time,
    SUM(CASE WHEN `Google review rating` IS NULL THEN 1 END) AS null_rating,
    SUM(CASE WHEN `Entrance Fee in INR` IS NULL THEN 1 END) AS null_fee,
    SUM(CASE WHEN `Airport with 50km Radius` IS NULL OR `Airport with 50km Radius` = '' THEN 1 END) AS null_airport,
    SUM(CASE WHEN `Weekly Off` IS NULL OR `Weekly Off` = '' THEN 1 END) AS null_weekly_off,
    SUM(CASE WHEN Significance IS NULL OR Significance = '' THEN 1 END) AS null_significance,
    SUM(CASE WHEN `DSLR Allowed` IS NULL OR `DSLR Allowed` = '' THEN 1 END) AS null_dslr,
    SUM(CASE WHEN `Number of google review in lakhs` IS NULL THEN 1 END) AS null_reviews,
    SUM(CASE WHEN `Best Time to visit` IS NULL OR `Best Time to visit` = '' THEN 1 END) AS null_best_time
FROM tourist_places;

-- check duplicate records 
select `Name`, City, State, Zone, count(*) as duplicate_count
from tourist_places 
group by `Name`, City, State, Zone
having count(*) > 1;

-- remove duplicates using row_number  cte= common table expression 
with cte_duplicates as (
select Id,
Row_Number() over (partition by `Name`, City, State, Zone order by Id ) as rn
from tourist_places)
delete from tourist_places
where Id in(
select id from cte_duplicates where rn > 1
);

-- cleaned data check 
select * from tourist_places
limit 20;
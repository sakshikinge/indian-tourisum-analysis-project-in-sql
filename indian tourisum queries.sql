select database();
use indian_tourisum;

SHOW COLUMNS FROM tourist_places;

alter table tourist_places
change column `Name` Tourist_places text;

alter table tourist_places
change column Tourist_places  Places text;

show tables;
select * from tourist_places;

-- 1.How many tourist places are present in the dataset?
select count(*) as total_places
from tourist_places;

-- 2.How many tourist places are there in each Zone?
select zone, count(*) as total_places
from tourist_places
group by zone;

-- 3.How many tourist places are there in each State?
select state, count(*) as total_places
from tourist_places
group by state;

-- 4.Which City has the highest number of tourist places?
select city, count(*) as total_places
from tourist_places
group by city
order by total_places desc
limit 1;

-- 5.How many tourist places are there for each Type of attraction (Temple, Park, Museum, etc.)?
select type, count(*) as total_places
from tourist_places
group by type;

-- 6.List all tourist places where DSLR Allowed = 'Yes'.
select *
from tourist_places
where `DSLR Allowed` = 'Yes';

-- 7.List all tourist places where Airport with 50km Radius = 'Yes'.
select *
from tourist_places
where `Airport with 50km Radius` = 'Yes';

-- 8.List all tourist places that have a Weekly Off (not None).
select *
from tourist_places
where `Weekly Off` = 'None';

-- 9.How many tourist places were established before 1800?
select  * 
from tourist_places
where `Establishment Year` <1800;

-- 10.How many places fall into each Best Time to visit category (Morning, Afternoon, Evening)?
select `Best Time to visit`, count(*) as total_places
from tourist_places
group by `Best Time to Visit`;

-- 11.What are the Top 5 tourist places based on Google review rating?
select places, City, `Google review rating`
from tourist_places
order by `Google review rating` Desc
limit 5;

-- 12.List all tourist places where Google review rating < 4.0.
select *
from tourist_places
where `Google review rating` < 4.0;

-- 13.What is the average Google review rating for each Type of place?
select type, avg(`Google review rating`) as avg_rating
from tourist_places
group by type;

-- 14.What is the average Google review rating for each State?
select state, avg(`Google review rating`) as avg_rating
from tourist_places
group by state;

-- 15.Which tourist places have the highest Number of google review in lakhs (Top 5)?
select places, city, `Number of google review in lakhs`
from tourist_places
order by  `Number of google review in lakhs` desc
limit 5;

-- 16.List all tourist places with Entrance Fee in INR = 0 (free places).
select *
from tourist_places
where `Entrance Fee in INR` = 0;

-- 17.List the Top 5 costliest tourist places based on Entrance Fee.
select places, city, `entrance fee in INR`
from tourist_places
order by `entrance fee in INR` desc
limit 5;

-- 18.List tourist places where Google review rating ≥ 4.5 and Entrance Fee ≤ 50
select *
from tourist_places
where `Google review rating` >= 4.5 and `Entrance fee in inr` <= 50;

-- 19.What is the average Entrance Fee in INR for each Type of tourist attraction?
select type, avg(`entrance fee in inr`) as avg_fee
from tourist_places
group by type;

-- 20.List all tourist places where time needed to visit in hrs ≤ 1 (quick visit).
select *
from tourist_places
where `time needed to visit in hrs` <=1;

-- 21.List all tourist places where time needed to visit in hrs ≥ 3 (long visit).
select *
from tourist_places
where `time needed to visit in hrs` >= 3;

-- 22.What is the average time needed to visit for each Type of attraction?
select type, avg(`time needed to visit in hrs`) as avg_time
from tourist_places
group by type;

-- 23.What is the average time needed to visit for each State?
select state, avg(`time needed to visit in hrs`) as avg_time
from tourist_places
group by state;

-- 4.What is the average time needed to visit for each City?
select city, avg(`time needed to visit in hrs`) as avg_time
from tourist_places
group by city;

-- 25.What is the Best Time to visit based on the maximum number of places available?
select `best time to visit`, count(*) as total_places
from tourist_places
group by `best time to visit`
order by total_places desc;

-- 26.Find the Top 3 tourist places per State based on Google review rating.
select state, places, `google review rating`
from(
select *,
row_number() over (partition by state order by `google review rating` desc) as rn
from tourist_places
)t
where rn <= 3;

-- 27.Find the Top 3 tourist places per Type based on Google review rating.
select type, places, `google review rating`
from(
select *,
row_number() over (partition by type order by `google review rating` desc) as rn
from tourist_places
)t
where rn <=3;

/* 28.List the best value attractions using these conditions:
oGoogle review rating ≥ 4.5
oEntrance Fee in INR ≤ 50
oDSLR Allowed = 'Yes' */
select * 
from tourist_places 
where `google review rating` >= 4.5
and `entrance fee in inr` <= 50
and `dslr allowed` = 'Yes';

-- 29.Which Zone has the highest average Google review rating?
select zone, avg(`google review rating`) as avg_rating
from tourist_places
group by zone
order by avg_rating desc
limit 1;

-- 30.Which State has the largest number of high-rated tourist places (≥ 4.5)?
SELECT State, COUNT(*) AS `high rated places`
FROM tourist_places
WHERE `Google Review Rating` >= 4.5
GROUP BY State
ORDER BY `high rated places` DESC;

/* 31.List tourist places where:
oAirport with 50km Radius = Yes
oAND DSLR Allowed = Yes */
select *
from tourist_places
where `airport with 50km radius` = 'Yes'
and `dslr allowed` = 'Yes';

-- 32.List all historical places where Significance = 'Historical'.
select *
from tourist_places
where significance = 'Historical';

-- 33.List all places that are Environmental, Natural, or Theme Park type (based on Type).
select *
from tourist_places
where type in ('environmental', 'nature', 'theme park');

-- 34.What is the most preferred Best Time to visit for each Type of attraction?
select type, `best time to visit`, count_places
from(
select type,
`best time to visit`,
count(*) as count_places,
row_number() over (
partition by type
order by count(*) desc
) as rn
from tourist_places
group by type, `best time to visit`
)t
where rn = 1;

-- 35.Which Zone + Type combination has the highest number of tourist places?
select zone, type, count(*) as total_places
from tourist_places
group by zone, type
order by total_places desc
limit 1;

/* 36.Is there a pattern between:
Entrance Fee in INR and Google review rating? */
select `entrance fee in inr`, `google review rating`
from tourist_places
order by `entrance fee in inr`;

/*37.Determine the Top 5 tourist cities based on:
oNumber of attractions
oAverage rating
oTotal number of google reviews (in lakhs) */
select city, count(*) as total_attractions,
avg(`google review rating`) as avg_rating,
sum(`number of google review in lakhs`) as total_reviews
from tourist_places
group by city
order by total_attractions desc, avg_rating desc, total_reviews desc
limit 5;
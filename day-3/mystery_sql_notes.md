Commands used for SQL Mystery https://mystery.knightlab.com 

SQLite's list tables
```SQL
SELECT name 
  FROM sqlite_master
  where type = 'table'
```

SQLite's describe table schema
```SQL
SELECT sql 
  FROM sqlite_master
 where name = 'crime_scene_report'
```

Fetch crime_scene_report
```SQL
SELECT * 
  FROM crime_scene_report
 where type = 'murder' 
 AND `date` = 20180115
 AND `city` = 'SQL City'
```
outputs:
date|type|description|city
20180115|murder|Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".|SQL City

describe person and interview table
```SQL
SELECT sql 
  FROM sqlite_master
 where name = 'person'

SELECT sql 
  FROM sqlite_master
 where name = 'interview'
```

fetch interivews mentioned in crime_scene_report
```SQL
SELECT name, transcript
  FROM person JOIN interview ON person.id = interview.person_id
  WHERE ('person'.'address_street_name' = 'Northwestern Dr' 
    AND 'person'.'address_number' = (
      SELECT MAX(address_number)
      FROM person
      WHERE 'person'.'address_street_name' = 'Northwestern Dr'
    )
  ) OR ('person'.'name' LIKE 'Annabel%' and 'person'.'address_street_name' = 'Franklin Ave')
```
outputs:
|name|transcript
|Morty Schapiro|I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
|Annabel Miller|I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

describe divers_license, get_fit_now_member, and get_fit_now_check_in tables:
```SQL
SELECT sql 
  FROM sqlite_master
 where name IN ('get_fit_now_member', 'get_fit_now_check_in', 'drivers_license')
```
outputs:
sql
CREATE TABLE drivers_license ( id integer PRIMARY KEY, age integer, height integer, eye_color text, hair_color text, gender text, plate_number text, car_make text, car_model text )
CREATE TABLE get_fit_now_member ( id text PRIMARY KEY, person_id integer, name text, membership_start_date integer, membership_status text, FOREIGN KEY (person_id) REFERENCES person(id) )
CREATE TABLE get_fit_now_check_in ( membership_id text, check_in_date integer, check_in_time integer, check_out_time integer, FOREIGN KEY (membership_id) REFERENCES get_fit_now_member(id) )

filter on membership number 
```SQL
SELECT *
  from get_fit_now_member
  where id like '48Z%';
```
outputs:
id|person_id|name|membership_start_date|membership_status
48Z38|49550|Tomas Baisley|20170203|silver
48Z7A|28819|Joe Germuska|20160305|gold
48Z55|67318|Jeremy Bowers|20160101|gold

filter on plate number:
```SQL
SELECT * 
  from drivers_license join person on person.license_id = drivers_license.id
  where plate_number like 'H42W%';
```
ouptuts:
id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model	id	name	license_id	address_number	address_street_name	ssn
183779	21	65	blue	blonde	female	H42W0X	Toyota	Prius	78193	Maxine Whitely	183779	110	Fisk Rd	137882671

filter on check_in_time and membership number, membership_status
```SQL
SELECT *
  FROM get_fit_now_check_in JOIN get_fit_now_member ON get_fit_now_member.id = get_fit_now_check_in.membership_id
  WHERE id LIKE "48Z%"
  AND check_in_date = 20180109
```
outputs:
membership_id	check_in_date	check_in_time	check_out_time	id	person_id	name	membership_start_date	membership_status
48Z7A	20180109	1600	1730	48Z7A	28819	Joe Germuska	20160305	gold
48Z55	20180109	1530	1700	48Z55	67318	Jeremy Bowers	20160101	gold

interviews of the two suspects? (WITH a CTE!!!)
```SQL
WITH suspect AS (
  SELECT 
	person_id suspect_person_id, 
	name suspect_name
  FROM 
  	get_fit_now_check_in JOIN get_fit_now_member ON get_fit_now_member.id = get_fit_now_check_in.membership_id
  WHERE id LIKE "48Z%"
	  AND check_in_date = 20180109
)

SELECT * 
FROM suspect s JOIN interview ON s.suspect_person_id = interview.person_id;
```
outputs:
suspect_person_id	suspect_name	person_id	transcript
67318	Jeremy Bowers	67318	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017. 

filter drivers_license to female redheads with tesla model s
```SQL
SELECT *
FROM drivers_license
WHERE hair_color = "red"
  AND gender = "female"
  AND car_make = "Tesla"
  AND car_model = "Model S"
```
outputs:
id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
202298	68	66	green	red	female	500123	Tesla	Model S
291182	65	66	blue	red	female	08CM64	Tesla	Model S
918773	48	65	black	red	female	917UU3	Tesla	Model S

people with 3 checkins at SQL Symphony Concert in December 2017
```SQL
WITH visits AS 
(
SELECT count(event_id) visits, person_id
FROM facebook_event_checkin 
WHERE event_name = "SQL Symphony Concert"
  AND date BETWEEN 20171130 AND 20180101
GROUP BY person_id
)

SELECT * 
FROM visits v
  JOIN person ON person.id = v.person_id
WHERE v.visits >= 3
```
outputs:
visits	person_id	id	name	license_id	address_number	address_street_name	ssn
3	24556	24556	Bryan Pardo	101191	703	Machine Ln	816663882
3	99716	99716	Miranda Priestly	202298	1883	Golden Ave	987756388

add income and drivers_license info to double check
```SQL
WITH visits AS 
(
SELECT count(event_id) visits, person_id
FROM facebook_event_checkin 
WHERE event_name = "SQL Symphony Concert"
  AND date BETWEEN 20171130 AND 20180101
GROUP BY person_id
)

SELECT *
FROM visits v
  JOIN person ON person.id = v.person_id
  JOIN drivers_license ON person.license_id = drivers_license.id
  JOIN income ON income.ssn = person.ssn
WHERE v.visits >= 3
```

get just the name:
```SQL
WITH visits AS 
(
SELECT count(event_id) visits, person_id
FROM facebook_event_checkin 
WHERE event_name = "SQL Symphony Concert"
  AND date BETWEEN 20171130 AND 20180101
GROUP BY person_id
),
suspects AS (
SELECT person_id, name, visits symphony_visits, height, hair_color, gender, plate_number, car_make, car_model, annual_income
FROM visits v
  JOIN person ON person.id = v.person_id
  JOIN drivers_license ON person.license_id = drivers_license.id
  JOIN income ON income.ssn = person.ssn
WHERE v.visits >= 3
)

select name from suspects s;
```

insert into solution table to double check
```SQL
WITH visits AS 
(
SELECT count(event_id) visits, person_id
FROM facebook_event_checkin 
WHERE event_name = "SQL Symphony Concert"
  AND date BETWEEN 20171130 AND 20180101
GROUP BY person_id
),
suspects AS (
SELECT person_id, name, visits symphony_visits, height, hair_color, gender, plate_number, car_make, car_model, annual_income
FROM visits v
  JOIN person ON person.id = v.person_id
  JOIN drivers_license ON person.license_id = drivers_license.id
  JOIN income ON income.ssn = person.ssn
WHERE v.visits >= 3
)

INSERT INTO solution VALUES (1, (select name from suspects limit 1));

        SELECT value FROM solution;
```

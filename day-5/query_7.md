## Query 7:

From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

Note: Weather is considered to be extremely cold then its temperature is less than zero.

##Table Structure:

```SQL
drop table weather;
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
delete from weather;
insert into weather values
(1, 'London', -1, to_date('2021-01-01','yyyy-mm-dd')),
(2, 'London', -2, to_date('2021-01-02','yyyy-mm-dd')),
(3, 'London', 4, to_date('2021-01-03','yyyy-mm-dd')),
(4, 'London', 1, to_date('2021-01-04','yyyy-mm-dd')),
(5, 'London', -2, to_date('2021-01-05','yyyy-mm-dd')),
(6, 'London', -5, to_date('2021-01-06','yyyy-mm-dd')),
(7, 'London', -7, to_date('2021-01-07','yyyy-mm-dd')),
(8, 'London', 5, to_date('2021-01-08','yyyy-mm-dd'));

select * from weather;
```

## My Solution:

I'm not very happy with this one. It feels clumsy, but that might just be me trying to be too clever :shrug:

```SQL
select id, city, temperature, day
from (
select * ,
 CASE
  WHEN temperature < 0 AND LEAD(temperature, 1) OVER (order by day) < 0 AND LEAD(temperature, 2) OVER (order by day) < 0 THEN 1
  WHEN temperature < 0 AND LEAD(temperature, 1) OVER (order by day) < 0 AND LAG(temperature, 1) OVER (order by day) < 0 THEN 1
  WHEN temperature < 0 AND LAG(temperature, 1) OVER (order by day) < 0 AND LAG(temperature, 2) OVER (order by day) < 0 THEN 1
  ELSE 0
  END flag
from weather
)
where flag = 1;
```

## Solution:

```SQL
select id, city, temperature, day
from (
    select *,
        case when temperature < 0
              and lead(temperature) over(order by day) < 0
              and lead(temperature,2) over(order by day) < 0
        then 'Y'
        when temperature < 0
              and lead(temperature) over(order by day) < 0
              and lag(temperature) over(order by day) < 0
        then 'Y'
        when temperature < 0
              and lag(temperature) over(order by day) < 0
              and lag(temperature,2) over(order by day) < 0
        then 'Y'
        end as flag
    from weather) x
where x.flag = 'Y';
```

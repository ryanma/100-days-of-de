## Query 5:

From the login_details table, fetch the users who logged in consecutively 3 or more times.

##Table Structure:

```SQL
drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

select * from login_details;
```

## My Solution
```SQL
with sequential_logins as (
select *, LEAD(user_name, 1) OVER() as second_login, LEAD(user_name, 2) OVER () as third_login
from login_details
)

select login_details.*
from sequential_logins join login_details on sequential_logins.user_name = login_details.user_name
where sequential_logins.user_name = second_login and sequential_logins.user_name = third_login;
```

## Solution with case statement (like suggested solution):
```SQLSELECT distinct user_name
FROM (
  select user_name,
    CASE
    WHEN user_name = LAG(user_name, 1) OVER (order by login_id) AND user_name = LAG(user_name, 2) OVER (order by login_id)
      THEN user_name
    ELSE null
    END repeated
  from login_details
  )
WHERE repeated is not null;
```

##Solution:

```SQL
select distinct repeated_names
from (
  select *,
  case
  when user_name = lead(user_name) over(order by login_id) and  user_name = lead(user_name,2) over(order by login_id) grhodes128@gmail.comthen user_name else null end as repeated_names
  from login_details) x
where x.repeated_names is not null;
```

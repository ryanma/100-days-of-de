##  Query 9:

Find the top 2 accounts with the maximum number of unique patients on a monthly basis.

Note: Prefer the account if with the least value in case of same number of unique patients

## Table Structure:

```SQL
drop table patient_logs;
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, to_date('02-01-2020','dd-mm-yyyy'), 100);
insert into patient_logs values (1, to_date('27-01-2020','dd-mm-yyyy'), 200);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (1, to_date('04-03-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 450);

select * from patient_logs;
```

## My solution:

Another one that took me a bit of work to get to. Finally got there though

```SQL
with logs_in_months AS (
  select pl.account_id, EXTRACT(month from pl.date) month, pl.patient_id
  from "public"."patient_logs" pl
),
count_per_month_per_account AS (
select account_id, month, count(distinct patient_id) no_of_unique_patients
from logs_in_months
group by account_id, month
)

select account_id, month, no_of_unique_patients
from (
  select account_id, month, no_of_unique_patients, rank() OVER(partition by month order by no_of_unique_patients) rn
  from count_per_month_per_account
  order by no_of_unique_patients desc
)
where rn < 3
```


##  Solution:
```SQL
select a.month, a.account_id, a.no_of_unique_patients
from (
		select x.month, x.account_id, no_of_unique_patients,
			row_number() over (partition by x.month order by x.no_of_unique_patients desc) as rn
		from (
				select pl.month, pl.account_id, count(1) as no_of_unique_patients
				from (select distinct to_char(date,'month') as month, account_id, patient_id
						from patient_logs) pl
				group by pl.month, pl.account_id) x
     ) a
where a.rn < 3;
```

## Query 6:

From the students table, write a SQL query to interchange the adjacent student names.

Note: If there are no adjacent student then the student name should stay the same.

## Table Structure:

```SQL
drop table students;
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

select * from students;
```

## My Solution

```SQL
select *,
  CASE
  WHEN id % 2 = 1 AND id = (SELECT MAX(id) from students) THEN student_name
  WHEN id % 2 = 0 THEN LAG(student_name) OVER (order by id)
  WHEN id % 2 = 1 THEN LEAD(student_name) OVER (order by id)
  END new_name
from students
```

## Solution:

```SQL
select id,student_name,
case when id%2 <> 0 then lead(student_name,1,student_name) over(order by id)
when id%2 = 0 then lag(student_name) over(order by id) end as new_student_name
from students;
```

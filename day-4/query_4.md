## Query 4:

From the doctors table, fetch the details of doctors who work in the same hospital but in different speciality.

##Table Structure:

drop table doctors;
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;

##Solution:

select d1.name, d1.speciality,d1.hospital
from doctors d1
join doctors d2
on d1.hospital = d2.hospital and d1.speciality <> d2.speciality
and d1.id <> d2.id;



##Sub Question:

Now find the doctors who work in same hospital irrespective of their speciality.

## My solution (main question)
select left_doc.*
from doctors left_doc join doctors right_doc on left_doc.hospital = right_doc.hospital
where left_doc.speciality <> right_doc.speciality;

## My solution (sub question)
select left_doc.*
from doctors left_doc join doctors right_doc on left_doc.hospital = right_doc.hospital
where left_doc.hospital = right_doc.hospital and left_doc.id <> right_doc.id;

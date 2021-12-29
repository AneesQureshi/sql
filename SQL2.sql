use mine;

select * from branch;
select * from branch_supplier;
select * from client;
select * FROM works_with;
SELECT * from employee;

select * from student;
select * from teacher;
select * from courses;

UPDATE student
SET course_id = 3
WHERE course_id=null;

UPDATE student 
SET last_name='sharma'
WHERE last_name='shamra';

SELECT * FROM student 
WHERE course_id is null;
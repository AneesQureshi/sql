use mine;

CREATE TABLE student (
  student_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  course_id INT,
  FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE SET NULL
  );


ALTER TABLE student
DROP COLUMN age;

CREATE TABLE teacher (
  teacher_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  experience INT,
  course_id INT,
  FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE SET NULL
);


CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  course_name VARCHAR(40)  
);


select * from student;
select * from teacher;
select * from courses;

INSERT INTO student VALUES(1, 'Mahendra', 'Singh', '1995-10-07', 'M', 1);
INSERT INTO student VALUES(2, 'Daksh', 'Sharma', '1996-03-07', 'M', 2);
INSERT INTO student VALUES(3, 'Swati', 'Aggarwal', '1991-12-13', 'f', 2);
INSERT INTO student VALUES(4, 'Hanzala', 'Qureshi', '1994-02-02', 'M', 5);
INSERT INTO student VALUES(5, 'Yusuf', 'Ansari', '1993-08-19', 'M', 3);
INSERT INTO student VALUES(6, 'Rakesh', 'kumar', '1992-11-16', 'M', 5);
INSERT INTO student VALUES(7, 'Prianka', 'shamra', '1991-10-27', 'F', 1);
INSERT INTO student VALUES(8, 'Roshni', 'bansal', '1991-10-27', 'F', NULL);


INSERT INTO teacher VALUES(8, 'Ruksaar', 'Qureshi', '1970-10-17', 'F', 62000, 5, 1);
INSERT INTO teacher VALUES(2, 'Chanchal', 'sabbharwal', '1967-01-18', 'F', 75000, 5, 2);
INSERT INTO teacher VALUES(3, 'Rohit', 'Verma', '1980-02-23', 'M', 25000, 5, 3);
INSERT INTO teacher VALUES(4, 'Rakesh', 'Singh', '1985-03-14', 'M', 33000, 5, 4);
INSERT INTO teacher VALUES(5, 'Gunjan', 'Kaur', '1990-04-16', 'F', 58000, 5, 5);
INSERT INTO teacher VALUES(6, 'Alka', 'Thukral', '1975-05-09', 'F', 65000, 5, 1);
INSERT INTO teacher VALUES(7, 'Iftikhar', 'Ansari', '1970-11-17', 'M', 320000, 5, 2);


INSERT INTO courses VALUES(1, 'Medical');
INSERT INTO courses VALUES(2, 'IT');
INSERT INTO courses VALUES(3, 'Hotel');
INSERT INTO courses VALUES(4, 'Pharma');
INSERT INTO courses VALUES(5, 'Engineering');

UPDATE teacher
SET course_id = 5
WHERE course_id=4;

UPDATE student
SET course_id = 5
WHERE course_id=4;
-- third highest salary


SELECT salary FROM teacher
order by  salary DESC limit 2

-- by sub query
select salary from 
(SELECT salary FROM teacher
order by  salary DESC limit 3) as sal
order by salary asc limit 1;

-- by limit n-1
SELECT salary 
FROM teacher 
ORDER BY salary desc limit 2,1;

-- by nesting
SELECT  MAX(salary) AS salary
  FROM teacher
 WHERE salary < (SELECT MAX(salary) 
                 FROM teacher
                 WHERE salary < (SELECT MAX(salary)
                 FROM teacher)
                ); 
-- all joins, union,intersect,minus 


select * from student as st
CROSS JOIN courses as cr;

-- common data between two tables with duplicates
select * from student as st
INNER JOIN courses as cr
ON st.course_id=cr.course_id;

-- all data of left table and common data from right table
select * from student as st
LEFT JOIN courses as cr
ON st.course_id=cr.course_id;

-- left join and left outer join are same.
select * from student as st
LEFT OUTER JOIN courses as cr
ON st.course_id=cr.course_id;

-- all data of right table and common data from left table
select * from student as st
RIGHT JOIN courses as cr
ON st.course_id=cr.course_id;


-- right join and right outer join are same.
select * from student as st
RIGHT OUTER JOIN courses as cr
ON st.course_id=cr.course_id;


-- left join + right join  data with duplicates
-- mysql dont have full joins thats why error in below query so instead we can use UNION
select st.student_id,st.first_name,st.last_name,st.birth_day from student as st
FULL OUTER JOIN courses as cr
ON st.course_id=cr.course_id
order by st.student_id;

-- left join + right join  data without  duplicates
select * from student as st
LEFT JOIN courses as cr
ON st.course_id=cr.course_id
UNION 
select * from student as st
RIGHT JOIN courses as cr
ON st.course_id=cr.course_id;

-- if we want duplicates also
select * from student as st
LEFT JOIN courses as cr
ON st.course_id=cr.course_id
UNION ALL
select * from student as st
RIGHT JOIN courses as cr
ON st.course_id=cr.course_id;

-- MYSQL doesnt support intersect but we can emulate by using INNER JOIN and IN  clause
select * from student as st
LEFT JOIN courses as cr
ON st.course_id=cr.course_id
INTERSECT    
select * from student as st
RIGHT JOIN courses as cr
ON st.course_id=cr.course_id;

-- using INNER JOIN 

select * from student as st
INNER JOIN courses as cr
ON st.course_id=cr.course_id;

-- using IN insided subquery
select DISTINCT * from student 
WHERE course_id IN(select course_id FROM courses ); 


-- data from first table than data from second table
select st.student_id,st.first_name,st.last_name FROM student as st
UNION
select tr.teacher_id,tr.first_name,tr.last_name FROM teacher as tr;

select * FROM student CROSS JOIN  courses ;

select * FROM courses CROSS JOIN  student ;

-- how many students in medical course

SELECT COUNT(st.student_id) FROM student as st 
WHERE st.course_id IN(SELECT cr.course_id from courses as cr WHERE cr.course_name='IT');

-- number of student in every course
SELECT cr.course_name,COUNT(st.student_id) FROM student as st
right JOIN courses AS cr 
ON st.course_id=cr.course_id
GROUP BY
cr.course_name;


-- find the course of Hanzala qureshi

SELECT cr.course_name FROM courses as cr WHERE cr.course_id 
IN(SELECT st.course_id FROM student as st WHERE first_name='Hanzala');

SELECT st.student_id,st.first_name,st.last_name,cr.course_id,cr.course_name FROM student AS st 
JOIN 
courses as cr
ON st.course_id=cr.course_id
WHERE st.first_name='Hanzala';


-- chanchal teach which students
SELECT tr.first_name as teacher_first_name,tr.last_name as teacher_last_name,cr.course_name,st.first_name,st.last_name FROM teacher as tr 
JOIN
courses as cr
ON tr.course_id=cr.course_id
JOIN 
student as st
ON
st.course_id=cr.course_id
WHERE tr.first_name='chanchal';

-- chanchal teach how many students
SELECT tr.first_name,COUNT(tr.first_name) FROM teacher as tr 
JOIN
courses as cr
ON tr.course_id=cr.course_id
JOIN 
student as st
ON
st.course_id=cr.course_id
WHERE tr.first_name='chanchal';


SELECT tr.first_name,COUNT(tr.first_name) FROM teacher as tr 
JOIN
courses as cr
ON tr.course_id=cr.course_id
JOIN 
student as st
ON
st.course_id=cr.course_id
GROUP BY tr.first_name
HAVING tr.first_name='chanchal';

-- students without course

SELECT * FROM student WHERE course_id is NULL;

-- total salary paid to teacher

SELECT SUM(teacher.salary) FROM teacher;


-- count of student of every teacher

SELECT tr.first_name,COUNT(st.first_name) FROM teacher as tr 
JOIN
courses as cr
ON tr.course_id=cr.course_id
JOIN 
student as st
ON
st.course_id=cr.course_id
GROUP BY tr.first_name;

-- name of students under every teacher

SELECT tr.first_name,cr.course_name,st.first_name FROM teacher AS tr 
JOIN
courses as cr
ON tr.course_id= cr.course_id
JOIN
student as st
ON
cr.course_id=st.course_id;

-- which course didnt choose by any student

SELECT * from courses as cr
LEFT JOIN 
student as st
ON cr.course_id=st.course_id
WHERE st.course_id IS NULL;



-- which course choosed by max student
SELECT cr.course_name,count(st.first_name) as ct FROM courses AS cr
left JOIN
student as st
ON cr.course_id=st.course_id
GROUP BY cr.course_name
ORDER BY ct DESC;

-- max salary of teacher
SELECT MAX(teacher.salary) FROM teacher;

-- total males and females in all tables 
SELECT st.first_name,st.sex FROM student as st
UNION
SELECT tr.first_name,tr.sex FROM teacher as tr;

SELECT st.sex,COUNT(st.sex) FROM student as st
GROUP BY st.sex
UNION
SELECT tr.sex,COUNT(tr.sex) FROM teacher as tr
GROUP BY tr.sex;

SELECT st.sex as sex ,COUNT(st.sex) as counts FROM student as st
GROUP BY st.sex
UNION
SELECT tr.sex ,COUNT(tr.sex) FROM teacher as tr
GROUP BY tr.sex;

select sex,SUM(counts) FROM
  (
  SELECT st.sex as sex ,COUNT(st.sex) as counts FROM student as st
  GROUP BY st.sex
  UNION
  SELECT tr.sex ,COUNT(tr.sex) FROM teacher as tr
  GROUP BY tr.sex
  ) as ctt
group by sex;


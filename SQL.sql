USE mine;
use company;
show databases;

drop DATABASE mine;

CREATE database mine;

select * from branch;
select * from branch_supplier;
select * from client;
select * FROM works_with;
SELECT * from employee;


UPDATE employee
SET branch_id = 0
WHERE branch_id = 3;

UPDATE employee
SET branch_id = 3
WHERE emp_id in (106,107,108);


# Comment
-- Comment
/* Comment */


select first_name, last_name, salary from employee where salary>70000;

-- male female count 
select sex,count(sex)  from employee group by sex;
-- which employee is associated with which branch;
SELECT  CONCAT(emp.first_name ,'_',emp.last_name) AS empName, br.branch_name from employee as emp join branch as br on emp.branch_id=br.branch_id ;

-- name of the branch manager
SELECT  b.branch_name,b.mgr_id,CONCAT(e.first_name ,'_',e.last_name) AS managerName
FROM branch b JOIN employee e ON b.mgr_id = e.emp_id;

-- Find names of all employees who have sold over 50,000

 SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (SELECT works_with.emp_id
                          FROM works_with
                          WHERE works_with.total_sales > 50000
                          );

 
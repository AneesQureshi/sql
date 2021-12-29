USE company;


-- Find all employees ordered by salary
SELECT *
from employee
ORDER BY salary ASC;

-- Find all employees ordered by sex then name
SELECT *
from employee
ORDER BY sex, first_name;

-- Find the first 5 employees in the table
SELECT *
from employee
LIMIT 5;

-- Find the first and last names of all employees
SELECT first_name, employee.last_name
FROM employee;

-- Find the forename and surnames names of all employees
SELECT first_name AS forename, employee.last_name AS surname
FROM employee;

-- Find out all the different genders
SELECT DISTINCT sex
FROM employee;

-- Find all male employees
SELECT *
FROM employee
WHERE sex = 'M';

-- Find all employees at branch 2
SELECT *
FROM employee
WHERE branch_id = 2;

-- Find all employee's id's and names who were born after 1969
SELECT emp_id, first_name, last_name
FROM employee
WHERE birth_day >= 1970-01-01;

-- Find all female employees at branch 2
SELECT *
FROM employee
WHERE branch_id = 2 AND sex = 'F';

-- Find all employees who are female & born after 1969 or who make over 80000
SELECT *
FROM employee
WHERE (birth_day >= '1970-01-01' AND sex = 'F') OR salary > 80000;

-- Find all employees born between 1970 and 1975
SELECT *
FROM employee
WHERE birth_day BETWEEN '1970-01-01' AND '1975-01-01';

-- Find all employees named Jim, Michael, Johnny or David
SELECT *
FROM employee
WHERE first_name IN ('Jim', 'Michael', 'Johnny', 'David');

-- Find the number of employees
SELECT COUNT(emp_id)
FROM employee
;

-- Find the average of all employee's salaries
SELECT AVG(salary)
FROM employee
;

-- Find the sum of all employee's salaries
SELECT SUM(salary)
FROM employee;

-- Find out how many males and females there are
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

-- Find the total sales of each salesman
SELECT emp_id,(total_sales) FROM works_with 
GROUP BY emp_id;

SELECT emp_id,(total_sales) FROM works_with 
GROUP BY client_id;

select * FROM works_with;

-- Find the total amount of money spent by each client

SELECT ww.client_id,SUM(ww.total_sales) FROM works_with ww
GROUP BY ww.client_id;

-- % = any # characters, _ = one character
SELECT * FROM client c;

-- Find any client's who are an LLC
SELECT * FROM client c
WHERE c.client_name LIKE '%LLC';

-- Find any branch suppliers who are in the label business
select * FROM branch_supplier;

SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Label%';

-- Find any employee born on the 10th day of the month
SELECT * FROM employee;


SELECT *
FROM employee
WHERE birth_day LIKE '_____10%';
-- Find any clients who are schools

SELECT *
FROM client
WHERE client_name LIKE '%Highschool%';


-- Find a list of employee and branch names
SELECT e.emp_id,e.first_name FROM employee e
UNION
SELECT b.branch_name,b.branch_id FROM branch b; 

SELECT employee.first_name AS Employee_Branch_Names
FROM employee
UNION
SELECT branch.branch_name
FROM branch;

-- Find a list of all clients & branch suppliers' names

SELECT c.client_name FROM client c
UNION
SELECT bs.supplier_name FROM branch_supplier bs; 

SELECT c.client_name,c.client_id FROM client c
UNION
SELECT bs.supplier_name,bs.branch_id FROM branch_supplier bs; 

SELECT client.client_name AS Non_Employee_Entities, client.branch_id AS Branch_ID
FROM client
UNION
SELECT branch_supplier.supplier_name, branch_supplier.branch_id
FROM branch_supplier;

-- JOINS


SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch    -- LEFT JOIN, RIGHT JOIN
ON employee.emp_id = branch.mgr_id;

-- Find names of all employees who have sold over 50,000
SELECT e.first_name 
FROM employee e 
LEFT JOIN works_with ww ON e.emp_id = ww.emp_id 
WHERE ww.total_sales>50000;

SELECT e.first_name FROM employee e WHERE e.emp_id IN
(
SELECT ww.emp_id FROM works_with ww WHERE ww.total_sales>50000
);
-- Find all clients who are handles by the branch that Michael Scott manages
-- Assume you know Michael's ID



SELECT client.client_id, client.client_name
FROM client
WHERE client.branch_id = (SELECT branch.branch_id
                          FROM branch
                          WHERE branch.mgr_id = 102);
 -- Find all clients who are handles by the branch that Michael Scott manages
 -- Assume you DONT'T know Michael's ID



SELECT c.client_name FROM client c WHERE c.branch_id IN
        (SELECT b.branch_id FROM branch b WHERE b.mgr_id IN 
          (SELECT e.emp_id FROM employee e WHERE e.first_name='Michael'));                                                                           


-- Find the names of employees who work with clients handled by the scranton branch
SELECT e.first_name FROM employee e 
WHERE e.branch_id= (SELECT b.branch_id FROM branch b WHERE b.branch_name='scranton')
AND e.emp_id IN (SELECT ww.emp_id  FROM works_with ww);


SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
                         SELECT works_with.emp_id
                         FROM works_with
                         )
AND employee.branch_id = 2;

-- Find the names of all clients who have spent more than 100,000 dollars

SELECT c.client_name FROM client c 
WHERE c.client_id IN (
                      SELECT client_id FROM (
                      
                      SELECT ww.client_id,SUM(ww.total_sales)AS total FROM works_with ww 
                      GROUP BY ww.client_id  
                      ) AS totals
                      WHERE totals.total>100000

                      )
;
SELECT client.client_name
FROM client
WHERE client.client_id IN (
                          SELECT client_id
                          FROM (
                                SELECT SUM(works_with.total_sales) AS totals, client_id
                                FROM works_with
                                GROUP BY client_id) AS total_client_sales
                          WHERE totals > 100000
);
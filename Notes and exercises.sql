FUNCTIONS, operators, keywords etc.:
SELECT
FROM
AS, CONCAT
-- or /*   */
DISTINCT
AVG, MAX, COUNT etc
WHERE
=, <>, >, <, >=, <=
AND, OR
IS: NULL, NOT NULL, TRUE, FALSE
()
COALESCE
BETWEEN
IN
EXTRACT
LIKE, ILIKE, %, _
::TEXT
DATE_TRUNC
ORDER BY
INNER JOIN
GROUP BY
HAVING






Finished exercises:

SELECT id, firstName, lastName /* get the students id and name here */
FROM Student;

SELECT * /* get all of students info here */
FROM Student;

SELECT DISTINCT Country FROM Customers; -- Select all the different values from the Country column in the Customers table.

-- Question 1: What is the average salary for the company?
-- Table: Salaries
-- Result: 63810.744836143706
SELECT avg(salary) FROM salaries;

-- Question 2: What year was the youngest person born in the company?
-- Table: employees
-- Result: 1965-02-01
SELECT max(birth_date) FROM employees;


--
/*
 * What database should I use for these exercises?
 * Name: France
 */
-- 

-- Question 1: How many towns are there in france?
-- Table: Towns
-- Result: 36684
SELECT count(id) FROM towns;

--
/*
 * What database should I use for these exercises?
 * Name: World
 */
-- 

-- Question 1: How many official languages are there?
-- Table: countrylanguage
-- Result: 238
SELECT count(countrycode) FROM countrylanguage
WHERE isofficial = TRUE;

-- Question 2: What is the average life expectancy in the world?
-- Table: country
-- Result: 66.48603611164265
SELECT avg(lifeexpectancy) FROM country;

-- Question 3: What is the average population for cities in the netherlands?
-- Table: city
-- Result: 185001
SELECT AVG(population) FROM city
WHERE countrycode = 'NLD';

-- Select all records where the City column has the value "Berlin".
SELECT * FROM Customers
WHERE City = 'Berlin';

-- Use the NOT keyword to select all records where City is NOT "Berlin".
SELECT * FROM Customers
WHERE NOT City = 'Berlin';

-- Select all records where the CustomerID column has the value 32.
SELECT * FROM Customers
WHERE CustomerID = 32;

-- Select all records where the City column has the value 'Berlin' and the PostalCode column has the value 12209.
SELECT * FROM Customers
WHERE City = 'Berlin'
AND PostalCode = 12209;

-- Select all records where the City column has the value 'Berlin' or 'London'.
SELECT * FROM Customers
WHERE City = 'Berlin'
OR City = 'London';

-- How many female customers do we have from the state of Oregon (OR)?
-- Result: 106
SELECT COUNT(firstName)
FROM customers
WHERE gender = 'F' AND state = 'OR';

-- Who over the age of 44 has an income of 100 000 or more? (excluding 44)
-- Result: 2497
SELECT COUNT(income)
FROM customers
WHERE age > 44 AND income >= 100000;

-- Who between the ages of 30 and 50 has an income less than 50 000?
-- (include 30 and 50 in the results)
-- Result: 2362
SELECT COUNT(income)
FROM customers
WHERE age >= 30 AND age <= 50 AND income < 50000;

-- What is the average income between the ages of 20 and 50? (Excluding 20 and 50)
-- Result: 59409.926240780098
SELECT AVG(income)
FROM customers
WHERE age > 20 AND age < 50;


/*
* DB: Store
* Table: Customers
* Question: 
* Select people either under 30 or over 50 with an income above 50000
* Include people that are 50
* that are from either Japan or Australia
*/

SELECT firstname, income, age FROM customers
WHERE income > 50000 AND (age < 30 OR age >= 50)
AND (country = 'Japan' OR country = 'Australia')


/*
* DB: Store
* Table: Orders
* Question: 
* What was our total sales in June of 2004 for orders over 100 dollars?
*/

SELECT SUM(totalamount) FROM orders
WHERE (orderdate >= '2004-06-01' AND orderdate <= '2004-06-30') 
AND totalamount > 100

/*
* DB: https://www.db-fiddle.com/f/PnGNcaPYfGoEDvfexzEUA/0
* Question: 
* Assuming a students minimum age for the class is 15, what is the average age of a student?
*
* 30.4000000000000000
*/
SELECT avg(COALESCE(age, 15)) FROM "Student";

/*
* DB: https://www.db-fiddle.com/f/PnGNcaPYfGoEDvfexzEUA/0
* Question: 
* Replace all empty first or last names with a default?
*/
SELECT id, COALESCE(NAME, 'default'), COALESCE(lastName, 'default'), age FROM "Student";

-- Who between the ages of 30 and 50 has an income less than 50 000?
-- (include 30 and 50 in the results)
SELECT *
FROM customers
WHERE age BETWEEN 30 AND 50 AND income < 50000;

-- What is the average income between the ages of 20 and 50? (Including 20 and 50)
SELECT AVG(income)
FROM customers
WHERE age BETWEEN 20 AND 50;

/*
* DB: Store
* Table: orders
* Question: How many orders were made by customer 7888, 1082, 12808, 9623
*/

SELECT COUNT(orderid)
FROM orders
WHERE customerid IN (7888, 1082, 12808, 9623)


/*
* DB: World
* Table: city
* Question: How many cities are in the district of Zuid-Holland, Noord-Brabant and Utrecht?
*/

SELECT COUNT(id)
FROM city
WHERE district IN ('Zuid-Holland', 'Noord-Brabant', 'Utrecht');

/*
* DB: Employees
* Table: employees
* Question: Find the age of all employees who's name starts with M.
* Sample output: https://imgur.com/vXs4093
*/

SELECT emp_no, first_name, EXTRACT (YEAR FROM AGE(birth_date)) AS "age" FROM employees
WHERE first_name ILIKE 'M%';

/*
* DB: Employees
* Table: employees
* Question: How many people's name start with A and end with R?
* Expected output: 1846
*/

SELECT count(emp_no) FROM employees
WHERE first_name ILIKE 'A%R';
                                                  
/*
* DB: Store
* Table: customers
* Question: How many people's zipcode have a 2 in it?.
* Expected output: 4211 
*/

SELECT count(customerid) FROM customers
WHERE zip::TEXT LIKE '%2%';


/*
* DB: Store
* Table: customers
* Question: How many people's zipcode start with 2 with the 3rd character being a 1.
* Expected output: 109 
*/

SELECT count(customerid) FROM customers
WHERE zip::TEXT LIKE '2_1%';

/*
* DB: Store
* Table: customers
* Question: Which states have phone numbers starting with 302?
* Replace null values with "No State"                                                  
* Expected output: https://imgur.com/AVe6G4c
*/

SELECT COALESCE(state, 'No State') AS "State" FROM customers
WHERE phone::TEXT LIKE '302%';

/*
* DB: Employees
* Table: employees
* Question: Get me all the employees above 60, use the appropriate date functions
*/

SELECT AGE(birth_date), * FROM employees
WHERE (EXTRACT (YEAR FROM AGE(birth_date))) > 60 ;

-- alternative
SELECT count(birth_date) FROM employees
WHERE birth_date < now() - INTERVAL '61 years' -- 61 years before the current date
            
/*
* DB: Employees
* Table: employees
* Question: How many employees where hired in February?
*/

SELECT count(emp_no) FROM employees
WHERE EXTRACT (MONTH FROM hire_date) = 2;

/*
* DB: Employees
* Table: employees
* Question: How many employees were born in november?
*/

SELECT COUNT(emp_no) FROM employees
WHERE EXTRACT (MONTH FROM birth_date) = 11;

/*
* DB: Employees
* Table: employees
* Question: Who is the oldest employee?
*/

SELECT MAX(AGE(birth_date)) FROM employees;

/*
* DB: Store
* Table: orders
* Question: How many orders were made in January 2004?
*/

SELECT COUNT(orderid)
FROM orders
WHERE DATE_TRUNC('month', orderdate) = date '2004-01-01';

/*
* DB: Employees
* Table: titles
* Question: What unique titles do we have?
*/

SELECT DISTINCT title FROM titles;


/*
* DB: Employees
* Table: employees
* Question: How many unique birth dates are there?
*/

SELECT COUNT(DISTINCT birth_date)
FROM employees;

/*
* DB: World
* Table: country
* Question: Can I get a list of distinct life expectancy ages
* Make sure there are no nulls
*/

SELECT DISTINCT lifeexpectancy FROM country
WHERE lifeexpectancy IS NOT NULL
ORDER BY lifeexpectancy;

/*
* DB: Employees
* Table: employees
* Question: Sort employees by first name ascending and last name descending
*/
SELECT * FROM employees
ORDER BY first_name ASC, last_name DESC;

/*
* DB: Employees
* Table: employees
* Question: Sort employees by age
*/
SELECT * FROM employees
ORDER BY birth_date;

/*
* DB: Employees
* Table: employees
* Question: Sort employees who's name starts with a "k" by hire_date
*/
SELECT * FROM employees
WHERE first_name ILIKE 'k%'
ORDER BY hire_date;

SELECT c.firstname, c.lastname, o.orderid FROM orders AS o
INNER JOIN customers AS c ON o.customerid = c.customerid
WHERE c.state IN ('NY', 'OH', 'OR')
ORDER BY o.orderid;


/*
* DB: Store
* Table: products
* Question: Show me the inventory for each product
*/

SELECT p.prod_id, i.quan_in_stock
FROM products AS p
INNER JOIN inventory AS i ON p.prod_id = i.prod_id 


/*
* DB: Employees
* Table: employees
* Question: Show me for each employee which department they work in
*/

SELECT e.first_name, dp.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS dp ON dp.dept_no = de.dept_no

/*
*  How many people were hired on did we hire on any given hire date?
*  Database: Employees
*  Table: Employees
*/

SELECT hire_date, COUNT(emp_no) AS "amount"
FROM employees
GROUP BY hire_date
ORDER BY "amount" DESC;

/*
*  Show me all the employees, hired after 1991 and count the amount of positions they've had
*  Database: Employees
*/

SELECT e.emp_no, count(t.title) AS "amount of titles"
FROM employees AS e
JOIN titles AS t USING(emp_no)
WHERE EXTRACT (YEAR FROM e.hire_date) > 1991
GROUP BY e.emp_no
ORDER BY e.emp_no;

/*
*  Show me all the employees that work in the department development and the from and to date.
*  Database: Employees
*/
SELECT e.emp_no, de.from_date, de.to_date
FROM employees AS e
JOIN dept_emp AS de USING(emp_no)
WHERE de.dept_no = 'd005'
GROUP BY e.emp_no, de.from_date, de.to_date
ORDER BY e.emp_no, de.to_date;

/*
*  Show me all the employees, hired after 1991, that have had more than 2 titles
*  Database: Employees
*/

SELECT e.emp_no, count(t.title) AS "amount of titles"
FROM employees AS e
JOIN titles AS t USING(emp_no)
WHERE EXTRACT (YEAR FROM e.hire_date) > 1991
GROUP BY e.emp_no
HAVING count(t.title) > 2
ORDER BY e.emp_no;

/*
*  Show me all the employees that have had more than 15 salary changes that work in the department development
*  Database: Employees
*/

SELECT e.emp_no, count(s.from_date) AS "amount of raises"
FROM employees AS e
JOIN salaries AS s USING(emp_no)
JOIN dept_emp AS de USING(emp_no)
WHERE de.dept_no = 'd005'
GROUP BY e.emp_no
HAVING count(s.from_date) > 15
ORDER BY e.emp_no;

/*
*  Show me all the employees that have worked for multiple departments
*  Database: Employees
*/

SELECT e.emp_no, count(de.dept_no) AS "worked for # departments"
FROM employees AS e
JOIN dept_emp AS de USING(emp_no)
GROUP BY e.emp_no
HAVING count(de.dept_no) > 1
ORDER BY e.emp_no;

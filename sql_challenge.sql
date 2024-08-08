CREATE TABLE departments(
	dept_no VARCHAR NOT NULL,
	dept_name VARCHAR NOT NULL
);

CREATE TABLE dept_emp(
	emp_no INT,
	dept_no VARCHAR (10)
);

CREATE TABLE dept_manager(
	dept_no VARCHAR (100),
	emp_no INT
);

CREATE TABLE employees(
	emp_no INT,
	emp_title_id VARCHAR (50),
	birth_date VARCHAR(10),
	first_name VARCHAR (20),
	last_name VARCHAR (30),
	sex VARCHAR (2),
	hire_date VARCHAR (10)
);

CREATE TABLE salaries(
	emp_no INT,
	salary INT
);

CREATE TABLE titles(
	title_id VARCHAR (50),
	title VARCHAR (100)
);

-- All employees name, sex and number
SELECT emp_no, last_name, first_name,sex,
       (SELECT COUNT(salary) 
        FROM salaries
        WHERE emp_no = emp_no) AS salary_count
FROM employees;

--Hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE'%/1986';

--Managers name, employee number, department number & name,
SELECT dm.dept_no, 
       (SELECT d.dept_name FROM departments d WHERE d.dept_no = dm.dept_no) AS dept_name, 
       dm.emp_no, 
       (SELECT e.last_name FROM employees e WHERE e.emp_no = dm.emp_no) AS last_name, 
       (SELECT e.first_name FROM employees e WHERE e.emp_no = dm.emp_no) AS first_name
FROM dept_manager dm;

--Employees name & number, department name & number
SELECT de.dept_no, de.emp_no, 
       (SELECT e.last_name FROM employees e WHERE e.emp_no = de.emp_no) AS last_name, 
       (SELECT e.first_name FROM employees e WHERE e.emp_no = de.emp_no) AS first_name, 
       (SELECT d.dept_name FROM departments d WHERE d.dept_no = de.dept_no) AS dept_name
FROM dept_emp de;

--"Hercules B"
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--Sales department employees name & number
SELECT emp_no, last_name, first_name
FROM employees
WHERE emp_no IN (
    SELECT de.emp_no
    FROM dept_emp de
    WHERE de.dept_no = (SELECT dept_no FROM departments WHERE dept_name = 'Sales')
);

--Sales and development employees name, number and department name
SELECT emp_no, last_name, first_name, dept_name
FROM (
    SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
    FROM employees e, dept_emp de, departments d
    WHERE e.emp_no = de.emp_no AND de.dept_no = d.dept_no 
          AND d.dept_name IN ('Sales', 'Development')
) AS subquery;

--Employee last name frequency
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;
-- ZADANIE 1
DROP TABLE job_history CASCADE CONSTRAINTS;
DROP TABLE employees CASCADE CONSTRAINTS;
DROP TABLE departments CASCADE CONSTRAINTS;
DROP TABLE locations CASCADE CONSTRAINTS;
DROP TABLE countries CASCADE CONSTRAINTS;
DROP TABLE regions CASCADE CONSTRAINTS;
DROP TABLE jobs CASCADE CONSTRAINTS;

-- ZADANIE 2
CREATE TABLE regions AS SELECT * FROM hr.regions;
CREATE TABLE countries AS SELECT * FROM hr.countries;
CREATE TABLE locations AS SELECT * FROM hr.locations;
CREATE TABLE departments AS SELECT * FROM hr.departments;
CREATE TABLE jobs AS SELECT * FROM hr.jobs;
CREATE TABLE employees AS SELECT * FROM hr.employees;
CREATE TABLE job_history AS SELECT * FROM hr.job_history;

ALTER TABLE regions ADD PRIMARY KEY (region_id);
ALTER TABLE countries ADD PRIMARY KEY (country_id);
ALTER TABLE locations ADD PRIMARY KEY (location_id);
ALTER TABLE departments ADD PRIMARY KEY (department_id);
ALTER TABLE jobs ADD PRIMARY KEY (job_id);
ALTER TABLE employees ADD PRIMARY KEY (employee_id);
ALTER TABLE job_history ADD PRIMARY KEY (employee_id, start_date);

ALTER TABLE countries ADD FOREIGN KEY (region_id) REFERENCES regions(region_id);
ALTER TABLE locations ADD FOREIGN KEY (country_id) REFERENCES countries(country_id);
ALTER TABLE departments ADD FOREIGN KEY (location_id) REFERENCES locations(location_id);
ALTER TABLE employees ADD FOREIGN KEY (department_id) REFERENCES departments(department_id);
ALTER TABLE employees ADD FOREIGN KEY (job_id) REFERENCES jobs(job_id);
ALTER TABLE employees ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);
ALTER TABLE job_history ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);
ALTER TABLE job_history ADD FOREIGN KEY (job_id) REFERENCES jobs(job_id);
ALTER TABLE job_history ADD FOREIGN KEY (department_id) REFERENCES departments(department_id);

-- ZADANIE 3
SELECT last_name || ' ' || salary AS wynagrodzenie 
FROM employees 
WHERE department_id IN (20, 50) AND salary BETWEEN 2000 AND 7000 
ORDER BY last_name;

-- ZADANIE 4
SELECT hire_date, last_name, &kolumna 
FROM employees 
WHERE manager_id IS NOT NULL AND EXTRACT(YEAR FROM hire_date) = 2005 
ORDER BY &kolumna;

-- ZADANIE 5
SELECT first_name || ' ' || last_name, salary, phone_number 
FROM employees 
WHERE SUBSTR(last_name, 3, 1) = 'e' AND first_name LIKE '%' || '&czesc_imienia' || '%' 
ORDER BY 1 DESC, 2 ASC;

-- ZADANIE 6
SELECT first_name, last_name, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS miesiace, 
       CASE 
           WHEN ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) < 150 THEN salary * 0.10 
           WHEN ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) BETWEEN 150 AND 200 THEN salary * 0.20 
           ELSE salary * 0.30 
       END AS wysokosc_dodatku 
FROM employees 
ORDER BY miesiace;

-- ZADANIE 7
SELECT department_id, SUM(salary) AS suma, ROUND(AVG(salary)) AS srednia 
FROM employees 
GROUP BY department_id 
HAVING MIN(salary) > 5000;

-- ZADANIE 8
SELECT e.last_name, e.department_id, d.department_name, e.job_id 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN locations l ON d.location_id = l.location_id 
WHERE l.city = 'Toronto';

-- ZADANIE 9
SELECT e1.first_name, e1.last_name, e2.first_name AS wspolpracownik_imie, e2.last_name AS wspolpracownik_nazwisko 
FROM employees e1 
JOIN employees e2 ON e1.department_id = e2.department_id AND e1.employee_id != e2.employee_id 
WHERE e1.first_name = 'Jennifer';

-- ZADANIE 10
SELECT d.department_id, d.department_name 
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id 
WHERE e.employee_id IS NULL;

-- ZADANIE 11
SELECT e.first_name, e.last_name, e.job_id, d.department_name, e.salary, j.grade_level 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN job_grades j ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;

-- ZADANIE 12
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees) 
ORDER BY salary DESC;

-- ZADANIE 13
SELECT employee_id, first_name, last_name 
FROM employees 
WHERE department_id IN (SELECT department_id FROM employees WHERE last_name LIKE '%u%');

-- ZADANIE 14
SELECT first_name, last_name, hire_date 
FROM employees 
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) > (SELECT AVG(MONTHS_BETWEEN(SYSDATE, hire_date)) FROM employees);

-- ZADANIE 15
SELECT d.department_name, COUNT(e.employee_id) AS liczba_pracownikow, AVG(e.salary) AS srednie_wynagrodzenie 
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_name 
ORDER BY liczba_pracownikow DESC;

-- ZADANIE 16
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary < ANY (SELECT salary FROM employees e JOIN departments d ON e.department_id = d.department_id WHERE d.department_name = 'IT');

-- ZADANIE 17
SELECT DISTINCT d.department_name 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
WHERE e.salary > (SELECT AVG(salary) FROM employees);

-- ZADANIE 18
SELECT job_title, srednie 
FROM (SELECT j.job_title, AVG(e.salary) AS srednie FROM jobs j JOIN employees e ON j.job_id = e.job_id GROUP BY j.job_title ORDER BY srednie DESC) 
WHERE ROWNUM <= 5;

-- ZADANIE 19
SELECT r.region_name, COUNT(DISTINCT c.country_id) AS liczba_krajow, COUNT(e.employee_id) AS liczba_pracownikow 
FROM regions r 
LEFT JOIN countries c ON r.region_id = c.region_id 
LEFT JOIN locations l ON c.country_id = l.country_id 
LEFT JOIN departments d ON l.location_id = d.location_id 
LEFT JOIN employees e ON d.department_id = e.department_id 
GROUP BY r.region_name;

-- ZADANIE 20
SELECT e1.first_name, e1.last_name 
FROM employees e1 
JOIN employees e2 ON e1.manager_id = e2.employee_id 
WHERE e1.salary > e2.salary;

-- ZADANIE 21
SELECT TO_CHAR(hire_date, 'MM') AS miesiac, COUNT(*) AS liczba_pracownikow 
FROM employees 
GROUP BY TO_CHAR(hire_date, 'MM') 
ORDER BY miesiac;

-- ZADANIE 22
SELECT department_name, srednie 
FROM (SELECT d.department_name, AVG(e.salary) AS srednie FROM departments d JOIN employees e ON d.department_id = e.department_id GROUP BY d.department_name ORDER BY srednie DESC) 
WHERE ROWNUM <= 3;
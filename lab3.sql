-- //ZADANIE 1//
CREATE OR REPLACE VIEW v_wysokie_pensje AS
SELECT * FROM employees WHERE salary > 6000;

SELECT * FROM v_wysokie_pensje;

-- //ZADANIE 2//
CREATE OR REPLACE VIEW v_wysokie_pensje AS
SELECT * FROM employees WHERE salary > 12000;

SELECT * FROM v_wysokie_pensje;

-- //ZADANIE 3//
DROP VIEW v_wysokie_pensje;

-- //ZADANIE 4//
CREATE OR REPLACE VIEW v_finance_employees AS
SELECT e.employee_id, e.last_name, e.first_name 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
WHERE d.department_name = 'Finance';

SELECT * FROM v_finance_employees;

-- //ZADANIE 5//
CREATE OR REPLACE VIEW v_mid_salary_employees AS
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date 
FROM employees 
WHERE salary BETWEEN 5000 AND 12000;

SELECT * FROM v_mid_salary_employees;

-- //ZADANIE 6//
INSERT INTO v_mid_salary_employees (employee_id, last_name, first_name, salary, job_id, email, hire_date) 
VALUES (9999, 'Kowalski', 'Jan', 6000, 'IT_PROG', 'jkowal@example.com', SYSDATE);

SELECT * FROM v_mid_salary_employees WHERE employee_id = 9999;

UPDATE v_mid_salary_employees 
SET salary = 7000 
WHERE employee_id = 9999;

SELECT * FROM v_mid_salary_employees WHERE employee_id = 9999;

DELETE FROM v_mid_salary_employees 
WHERE employee_id = 9999;

-- //ZADANIE 7//
CREATE OR REPLACE VIEW v_dept_stats AS
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS num_employees, AVG(e.salary) AS avg_salary, MAX(e.salary) AS max_salary 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_id, d.department_name 
HAVING COUNT(e.employee_id) >= 4;

SELECT * FROM v_dept_stats;

INSERT INTO v_dept_stats (department_id, department_name, num_employees, avg_salary, max_salary) 
VALUES (999, 'Test Dept', 5, 5000, 6000);

-- //ZADANIE 8//
CREATE OR REPLACE VIEW v_wysokie_pensje_check AS
SELECT * FROM employees 
WHERE salary > 12000 
WITH CHECK OPTION;

SELECT * FROM v_wysokie_pensje_check;

INSERT INTO v_wysokie_pensje_check (employee_id, last_name, email, hire_date, job_id, salary) 
VALUES (9998, 'Nowak', 'nowak@example.com', SYSDATE, 'IT_PROG', 8000);

INSERT INTO v_wysokie_pensje_check (employee_id, last_name, email, hire_date, job_id, salary) 
VALUES (9997, 'Wisniewski', 'wisniewski@example.com', SYSDATE, 'FI_MGR', 13000);

ROLLBACK;

-- //ZADANIE 9//
DROP MATERIALIZED VIEW v_managerowie;

CREATE MATERIALIZED VIEW v_managerowie AS
SELECT e.employee_id, e.last_name, e.first_name, d.department_name 
FROM employees e 
LEFT JOIN departments d ON e.department_id = d.department_id 
WHERE e.employee_id IN (SELECT manager_id FROM employees WHERE manager_id IS NOT NULL);

SELECT * FROM v_managerowie;

-- //ZADANIE 10//
CREATE OR REPLACE VIEW v_najlepiej_oplacani AS
SELECT employee_id, last_name, first_name, salary 
FROM employees 
ORDER BY salary DESC 
FETCH FIRST 10 ROWS ONLY;

SELECT * FROM v_najlepiej_oplacani;
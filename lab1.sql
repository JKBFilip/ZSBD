-- ZADANIE 1
CREATE TABLE REGIONS (region_id NUMBER PRIMARY KEY, region_name VARCHAR2(50));
CREATE TABLE COUNTRIES (country_id CHAR(2) PRIMARY KEY, country_name VARCHAR2(50), region_id NUMBER);
CREATE TABLE LOCATIONS (location_id NUMBER PRIMARY KEY, street_address VARCHAR2(100), postal_code VARCHAR2(20), city VARCHAR2(50), state_province VARCHAR2(50), country_id CHAR(2));
CREATE TABLE DEPARTMENTS (department_id NUMBER PRIMARY KEY, department_name VARCHAR2(50) NOT NULL, manager_id NUMBER, location_id NUMBER);
CREATE TABLE JOBS (job_id VARCHAR2(10) PRIMARY KEY, job_title VARCHAR2(50) NOT NULL, min_salary NUMBER, max_salary NUMBER);
CREATE TABLE EMPLOYEES (employee_id NUMBER PRIMARY KEY, first_name VARCHAR2(50), last_name VARCHAR2(50) NOT NULL, email VARCHAR2(50) NOT NULL, phone_number VARCHAR2(20), hire_date DATE NOT NULL, job_id VARCHAR2(10) NOT NULL, salary NUMBER, commission_pct NUMBER(2,2), manager_id NUMBER, department_id NUMBER);
CREATE TABLE JOB_HISTORY (employee_id NUMBER, start_date DATE, end_date DATE NOT NULL, job_id VARCHAR2(10) NOT NULL, department_id NUMBER, PRIMARY KEY (employee_id, start_date));

-- ZADANIE 2
ALTER TABLE COUNTRIES ADD CONSTRAINT fk_countr_reg FOREIGN KEY (region_id) REFERENCES REGIONS(region_id);
ALTER TABLE LOCATIONS ADD CONSTRAINT fk_loc_countr FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id);
ALTER TABLE DEPARTMENTS ADD CONSTRAINT fk_dept_loc FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);
ALTER TABLE EMPLOYEES ADD CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);
ALTER TABLE EMPLOYEES ADD CONSTRAINT fk_emp_job FOREIGN KEY (job_id) REFERENCES JOBS(job_id);
ALTER TABLE EMPLOYEES ADD CONSTRAINT fk_emp_man FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id);
ALTER TABLE JOB_HISTORY ADD CONSTRAINT fk_jh_emp FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id);
ALTER TABLE JOB_HISTORY ADD CONSTRAINT fk_jh_job FOREIGN KEY (job_id) REFERENCES JOBS(job_id);
ALTER TABLE JOB_HISTORY ADD CONSTRAINT fk_jh_dept FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);

-- ZADANIE 3
ALTER TABLE JOBS ADD CONSTRAINT check_salary CHECK (max_salary - min_salary >= 2000);

-- ZADANIE 4
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES ('SA_REP', 'Sales Representative', 3000, 6000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES ('AD_PRES', 'President', 15000, 30000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES ('MK_MAN', 'Marketing Manager', 5000, 8000);

-- ZADANIE 5
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary) VALUES (1, 'Jan', 'Kowalski', 'jan@test.pl', '123-456-789', SYSDATE, 'AD_PRES', 20000);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary) VALUES (2, 'Anna', 'Nowak', 'anna@test.pl', '987-654-321', SYSDATE, 'IT_PROG', 8000);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary) VALUES (3, 'Piotr', 'Wisniewski', 'piotr@test.pl', '111-222-333', SYSDATE, 'SA_REP', 4000);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary) VALUES (4, 'Katarzyna', 'Wojcik', 'kat@test.pl', '444-555-666', SYSDATE, 'MK_MAN', 7000);
COMMIT;

-- ZADANIE 6
UPDATE EMPLOYEES SET manager_id = 1 WHERE employee_id IN (2, 3);

-- ZADANIE 7
UPDATE JOBS SET min_salary = min_salary + 500, max_salary = max_salary + 500 WHERE LOWER(job_title) LIKE '%b%' OR LOWER(job_title) LIKE '%s%';

-- ZADANIE 8
UPDATE EMPLOYEES SET manager_id = NULL;
DELETE FROM EMPLOYEES WHERE job_id IN (SELECT job_id FROM JOBS WHERE max_salary > 9000);
DELETE FROM JOBS WHERE max_salary > 9000;
COMMIT;

-- ZADANIE 9
DROP TABLE JOB_HISTORY;
FLASHBACK TABLE JOB_HISTORY TO BEFORE DROP;
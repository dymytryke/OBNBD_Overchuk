ALTER TABLE EMPLOYEES
    ADD COLUMN email_domain VARCHAR(50)
        GENERATED ALWAYS AS (
            split_part(email, '@', 2)
            ) STORED;

ALTER TABLE EMPLOYEES
    ADD COLUMN full_name VARCHAR(46)
        GENERATED ALWAYS AS (
            last_name || ' ' || first_name
            ) STORED;

SELECT first_name, last_name, full_name
FROM employees;

CREATE OR REPLACE VIEW upward_hierarchy AS
WITH RECURSIVE mgr AS (SELECT e.id AS employee_id,
                              e.manager_id,
                              1    AS lvl
                       FROM employees e
                       WHERE e.manager_id IS NOT NULL

                       UNION ALL

                       SELECT mgr.employee_id,
                              e.manager_id,
                              mgr.lvl + 1
                       FROM mgr
                                JOIN employees e ON mgr.manager_id = e.id
                       WHERE e.manager_id IS NOT NULL)
SELECT m.employee_id,
       m.manager_id,
       m.lvl
FROM mgr m
ORDER BY m.employee_id, m.lvl;


CREATE OR REPLACE VIEW downward_hierarchy AS
WITH RECURSIVE Subordinates AS (SELECT id, first_name, last_name, manager_id, 1 AS level
                                FROM EMPLOYEES
                                WHERE manager_id IS NOT NULL
                                UNION ALL
                                SELECT e.id, e.first_name, e.last_name, e.manager_id, s.level + 1
                                FROM EMPLOYEES e
                                         INNER JOIN Subordinates s ON e.manager_id = s.id)
SELECT id, first_name, last_name, manager_id, level
FROM Subordinates
ORDER BY manager_id, level;


CREATE MATERIALIZED VIEW upward_hierarchy_mat AS
WITH RECURSIVE mgr AS (SELECT e.id AS employee_id,
                              e.manager_id,
                              1    AS lvl
                       FROM employees e
                       WHERE e.manager_id IS NOT NULL

                       UNION ALL

                       SELECT mgr.employee_id,
                              e.manager_id,
                              mgr.lvl + 1
                       FROM mgr
                                JOIN employees e ON mgr.manager_id = e.id
                       WHERE e.manager_id IS NOT NULL)
SELECT mgr.employee_id, mgr.manager_id, mgr.lvl
FROM mgr
ORDER BY mgr.employee_id, mgr.lvl;



CREATE MATERIALIZED VIEW downward_hierarchy_mat AS
WITH RECURSIVE Subordinates AS (SELECT id, first_name, last_name, manager_id, 1 AS level
                                FROM EMPLOYEES
                                WHERE manager_id IS NOT NULL
                                UNION ALL
                                SELECT e.id, e.first_name, e.last_name, e.manager_id, s.level + 1
                                FROM EMPLOYEES e
                                         INNER JOIN Subordinates s ON e.manager_id = s.id)
SELECT id, first_name, last_name, manager_id, level
FROM Subordinates
ORDER BY manager_id, level;

INSERT INTO employees (first_name,
                       last_name,
                       email,
                       phone_number,
                       hire_date,
                       job_id,
                       salary,
                       manager_id,
                       department_id)
VALUES ('John',
        'Doe',
        'john.doe@company.com',
        '555-1234',
        CURRENT_DATE,
        'DEV',
        5000,
        1,
        10);

EXPLAIN ANALYZE SELECT * FROM upward_hierarchy;
EXPLAIN ANALYZE SELECT * FROM downward_hierarchy;


EXPLAIN SELECT * FROM employees WHERE salary > 10000;

SET enable_seqscan = off;

EXPLAIN SELECT * FROM employees WHERE salary > 10000;

SET enable_seqscan = on;
SET random_page_cost = 1.0;
SET seq_page_cost = 10.0;

EXPLAIN SELECT * FROM employees WHERE salary > 10000;

CREATE EXTENSION IF NOT EXISTS pg_hint_plan;

LOAD 'pg_hint_plan';

SET pg_hint_plan.enable_hint TO on;

SET pg_hint_plan.enable_hint_table TO ON;

SET pg_hint_plan.debug_print = on;

EXPLAIN SELECT * FROM employees WHERE salary > 10000;
EXPLAIN /*+ IndexScan(employees idx_employees_salary) */ SELECT * FROM employees WHERE salary > 10000;

EXPLAIN /*+ NestLoop(e m) */ SELECT *
FROM employees e
JOIN employees m ON e.manager_id = m.id
WHERE e.salary > 10000;

SELECT * FROM pg_stat_user_indexes WHERE relname = 'employees';
EXPLAIN SELECT * FROM pg_stat_user_indexes WHERE relname = 'employees';

EXPLAIN /*+ IndexOnlyScan(employees idx_employees_salary) */
SELECT salary FROM employees ORDER BY salary;

EXPLAIN /*+ Leading((e m)) */ SELECT *
FROM employees e
JOIN employees m ON e.manager_id = m.id
WHERE e.salary > 10000;

EXPLAIN /*+ Leading((m e)) */ SELECT *
FROM employees e
JOIN employees m ON e.manager_id = m.id
WHERE e.salary > 10000;

set work_mem = '1GB';

EXPLAIN ANALYZE
SELECT * FROM employees ORDER BY first_name;

set work_mem = '16MB';

EXPLAIN ANALYZE
SELECT * FROM employees ORDER BY first_name;

SELECT LPAD(' ', (LEVEL-1) * 2) || FIRST_NAME || ' ' || LAST_NAME AS EMPLOYEE_NAME, level
from EMPLOYEES
start with id = 1
connect by nocycle PRIOR id = MANAGER_ID;
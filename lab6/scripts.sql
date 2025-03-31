CREATE TABLE history (
    id         varchar(100) PRIMARY KEY,
    old_value  varchar(100),
    new_value  varchar(100)
);

CREATE OR REPLACE FUNCTION log_employees_salary()
RETURNS trigger AS $$
BEGIN
    IF NEW.salary IS DISTINCT FROM OLD.salary THEN
        INSERT INTO history (id, old_value, new_value)
        VALUES (
            'employees_salary_' || OLD.id,
            OLD.salary::text,
            NEW.salary::text
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_employees_salary
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION log_employees_salary();

-- DROP TRIGGER trg_employees_salary ON employees;
-- DROP FUNCTION log_employees_salary;
-- DROP TABLE history;

UPDATE employees SET salary = salary * 0.66 WHERE id = 9;

SELECT * FROM history;


CREATE OR REPLACE FUNCTION log_cities_name()
RETURNS trigger AS $$
BEGIN
    IF NEW.name IS DISTINCT FROM OLD.name THEN
        INSERT INTO history (id, old_value, new_value)
        VALUES (
            'cities_name_' || OLD.id,
            OLD.name,
            NEW.name
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_cities_name
AFTER UPDATE OF name ON cities
FOR EACH ROW
EXECUTE FUNCTION log_cities_name();

UPDATE cities SET name = 'NEW Los Angeles 1' where id = 1;

SELECT * FROM history;
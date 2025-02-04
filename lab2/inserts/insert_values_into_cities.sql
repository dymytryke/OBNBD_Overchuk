create or replace PROCEDURE insert_values_into_cities AS
   type CITY_LIST_T IS VARRAY(10) OF VARCHAR2(40);
   CITY_LIST CITY_LIST_T := CITY_LIST_T(
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose'
);
   city_name VARCHAR2(40); -- Add this variable
BEGIN
  FOR i IN 1..100000 LOOP
    city_name := CITY_LIST(DBMS_RANDOM.VALUE(1, CITY_LIST.COUNT)); -- Store the random city first
    INSERT INTO CITIES (name)
    VALUES (city_name || ' ' || i);  -- Then concatenate
  END LOOP;
  COMMIT;
END insert_values_into_cities;
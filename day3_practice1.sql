--- EX1: Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.
select NAME from CITY 
where  COUNTRYCODE ='USA'  AND POPULATION > 120000 ;

---EX2 Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.
SELECT * FROM CITY
WHERE COUNTRYCODE ='JPN'

---EX3 Query a list of CITY and STATE from the STATION table.
SELECT CITY, STATE FROM STATION

---EX4 Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
  SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' or CITY LIKE 'E%' or CITY LIKE 'I%' or CITY LIKE 'O%' or CITY LIKE 'U%' ;

---EX5 Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT (CITY)
FROM STATION WHERE CITY LIKE '%a' or  CITY LIKE '%e' OR  CITY LIKE '%i' OR CITY LIKE '%o'  or CITY LIKE '%u';

---EX6 Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION
WHERE NOT ( CITY LIKE 'A%' or  CITY LIKE 'E%' or  CITY LIKE 'I%' or CITY LIKE 'O%'  or CITY LIKE 'U%'

---EX7 Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
SELECT NAME FROM EMPLOYEE 
ORDER BY NAME ;

---EX8 Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than  per month who have been employees for less than  months. 
---Sort your result by ascending employee_id.
SELECT NAME FROM EMPLOYEE 
WHERE SALARY>2000 AND MONTHS<10 
ORDER BY EMPLOYEE_ID ;

--- EX9 +-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| low_fats    | enum    |
| recyclable  | enum    |
+-------------+---------+

SELECT PRODUCT_ID FROM PRODUCTS
WHERE low_fats = 'Y' AND recyclable='Y'

---EX10 Find the names of the customer that are not referred by the customer with id = 2.
SELECT name from Customer
WHERE referee_id !=2 or referee_id is Null;

---EX11 Write a solution to find the name, population, and area of the big countries.
SELECT name, population,area FROM World
WHERE area >=3000000 OR population >=25000000;

---EX12 Write a solution to find all the authors that viewed at least one of their own articles. Return the result table sorted by id in ascending order.
SELECT distinct author_id as id from Views
Where author_id= viewer_id 
ORDER BY author_id

---ẼX13 Write a query to determine which parts have begun the assembly process but are not yet finished.
SELECT part,assembly_step FROM parts_assembly
WHERE finish_date IS NULL;

---EX14 Tesla
SELECT part,assembly_step FROM parts_assembly
WHERE finish_date IS NULL;

---EX15 Find the advertising channel where Uber spent more than 100k USD in 2019
select advertising_channel from uber_advertising
Where money_spent >100000 and year=2019;













---EX1 Laptop vs. Mobile Viewership
SELECT 
sum(CASE WHEN device_type='laptop' THEN 1 ELSE 0 END) AS laptop_views,
sum(CASE WHEN device_type IN ('tablet','phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership

---EX2 Triangle Judgement
SELECT x,y,z
CASE 
WHEN x+y>z AND y+z>x AND z+x>y THEN 'YES' ELSE 'NO' END AS 'triangle'
FROM Triangle

---EX3 
  SELECT name from Customer
WHERE referee_id !=2 or referee_id is Null

---EX4 Find Customer Referee :https://leetcode.com/problems/find-customer-referee/description/?envType=study-plan-v2&envId=top-sql-50
SELECT
round(100.0*sum(case when call_category='n/a' or call_category is null then 1 else 0 
END)/ count(policy_holder_id),1) as uncategorised_call_pct
from callers

  
---ex5 Make a report showing the number of survivors and non-survivors by passenger class
---https://platform.stratascratch.com/coding/9881-make-a-report-showing-the-number-of-survivors-and-non-survivors-by-passenger-class?code_type=1
SELECT
    survived,
    sum(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    sum(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    sum(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY 
    survived

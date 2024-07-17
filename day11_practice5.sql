---ex1 query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.
SELECT Country.Continent, FLOOR(AVG(City.Population))
FROM Country, City 
WHERE Country.Code = City.CountryCode 
GROUP BY Country.Continent 


*---ex2 Signup Activation Rate [TikTok SQL Interview Question]
SELECT 
ROUND(CAST(COUNT(texts.email_id) AS DECIMAL)
/ COUNT(DISTINCT emails.email_id), 2) AS activation_rate

FROM emails
LEFT JOIN texts
ON emails.email_id = texts.email_id AND texts.signup_action = 'Confirmed'

 *---ex3 : datalemur-time-spent-snaps. https://datalemur.com/questions/time-spent-snaps
select b.age_bucket,
round(100.0*sum(a.time_spent) FILTER (WHERE a.activity_type='send')
/sum(a.time_spent),2) as send_perc, 
round(100.0*sum(a.time_spent) filter (where a.activity_type='open')
/sum(a.time_spent),2) as open_perc
from activities as a
inner join age_breakdown as b on a.user_id=b.user_id
where a.activity_type in ('open','send')
group by b.age_bucket


*---ex4: datalemur-supercloud-customer. https://datalemur.com/questions/supercloud-customer
WITH supercloud_cust AS (
select a.customer_id,
count(distinct b.product_category) as dem
from customer_contracts as a
inner join products as b on a.product_id=b.product_id
group by a.customer_id )
select customer_id
from supercloud_cust
where dem= (select COUNT(DISTINCT product_category) from products)


  

---ex6  List the Products Ordered in a Period https://leetcode.com/problems/list-the-products-ordered-in-a-period/description/?envType=study-plan-v2&envId=top-sql-50
  select a.product_name, sum(unit) as unit from products as a
join orders as b on a.product_id=b.product_id
where year(order_date)=2020 and month(order_date)=2
group by a.product_id
having sum(unit)>99

---ex7 Page With No Likes [Facebook SQL Interview Question]  https://datalemur.com/questions/sql-page-with-no-likes
SELECT a.page_id from pages as a
left outer join page_likes as b on a.page_id=b.page_id
where b.liked_date is null
order by a.page_id

SELECT page_id from pages
where page_id not in (
select page_id from page_likes
where page_id IS NOT NULL )


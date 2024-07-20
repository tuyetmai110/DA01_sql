---ex1 Duplicate Job Listings
select count( distinct company_id)
from 
(SELECT company_id	,title,description, COUNT(job_id) as job_count
FROM job_listings GROUP BY company_id	,title,description ) as job_count
where job_count>1

---ex2  https://datalemur.com/questions/sql-highest-grossing
with cte as(
select category,product, SUM(spend) as total_spent , 
rank() over(
partition by category order by SUM(spend) desc) as ranking
from product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
group by category,product)

select category,product,total_spent from cte where ranking<=2
order by category,ranking 


---ex3: Patient Support Analysis  https://datalemur.com/questions/frequent-callers
select count(policy_holder_id) as policy_holder_count from
(select policy_holder_id from callers group by policy_holder_id 
having count(case_id)>=3 ) as a

with a as (select policy_holder_id from callers 
group by policy_holder_id 
having count(case_id)>=3 )
select count(policy_holder_id) as policy_holder_count from a

--ex4 Page With No Likes https://datalemur.com/questions/sql-page-with-no-likes
select page_id from pages
where not exists 
(select page_id from page_likes where pages.page_id=page_likes.page_id)


---ex5 Active User Retention [Facebook SQL Interview Question]
https://datalemur.com/questions/user-retention https://datalemur.com/questions/user-retention
WITH cte AS (
 SELECT user_id FROM user_actions
 WHERE EXTRACT(MONTH FROM event_date) = 7 
 AND event_type IN ('sign-in', 'like', 'comment')),
cte1 as
(SELECT a.user_id FROM user_actions AS a
INNER JOIN cte ON cte.user_id = a.user_id
WHERE EXTRACT(MONTH FROM event_date) = 6 
AND a.event_type IN ('sign-in', 'like', 'comment'))
select '7' as month, count(DISTINCT user_id) as monthly_active_users
from cte1



  
---ex6  monthly transactions https://leetcode.com/problems/monthly-transactions-i/description/?envType=study-plan-v2&envId=top-sql-50
SELECT  SUBSTR(trans_date,1,7) as month, country, count(id) as trans_count, SUM(CASE WHEN state = 'approved' then 1 else 0 END) as approved_count,
SUM(CASE WHEN state = 'approved' then amount else 0 END) as approved_total_amount,
SUM(amount) as trans_total_amount
FROM Transactions
GROUP BY month, country

---ex7 1070. Product Sales Analysis III       https://leetcode.com/problems/product-sales-analysis-iii/description/?envType=study-plan-v2&envId=top-sql-50
  with cte as ( select product_id, min(year) as minyear from sales group by product_id )
select a.product_id, a.year as first_year, a.quantity,a.price
from sales a
inner join cte b on a.product_id=b.product_id and  a.year=b.minyear

  
  ---ex8 https://leetcode.com/problems/customers-who-bought-all-products/description/?envType=study-plan-v2&envId=top-sql-50
  select customer_id from Customer group by customer_id
having count(distinct product_key)=(select count(product_key) from product)
  
  ---ex9 https://leetcode.com/problems/employees-whose-manager-left-the-company/description/?envType=study-plan-v2&envId=top-sql-50
select employee_id from Employees 
where salary <30000 and manager_id not in
 (select employee_id from Employees  )
 order by employee_id
 
---ex10  Duplicate Job Listings https://datalemur.com/questions/duplicate-job-listings
select count( distinct company_id)
from 
(SELECT company_id	,title,description, COUNT(job_id) as job_count
FROM job_listings GROUP BY company_id	,title,description ) as job_count
where job_count>1


---ex11 /* Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name. https://leetcode.com/problems/movie-rating/description/?envType=study-plan-v2&envId=top-sql-50*/
(select name as results from MovieRating join users on users.user_id=MovieRating.user_id
group by name order by count(rating) desc,name 
limit 1)
 union all
(select title results from movies join MovieRating on movies.movie_id=MovieRating.movie_id
where extract(year_month from created_at)=202002
group by title
order by avg(rating) desc, title
limit 1)


---ex 12 Friend Requests II: Who Has the Most Friends https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/description/?envType=study-plan-v2&envId=top-sql-50
 with cte as( 
    select requester_id id from RequestAccepted
    union all
    select accepter_id id from RequestAccepted )
select id, count(*) as num from cte
group by id
order by  count(*) desc
limit 1

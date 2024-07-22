---ex1 Y-on-Y Growth Rate [Wayfair SQL Interview Question]
https://datalemur.com/questions/yoy-growth-rate
select EXTRACT(year from transaction_date) as year, 
product_id,spend as curr_year_spend, 
 lag(spend) over( partition by product_id order by EXTRACT(year from transaction_date) ) as prev_year_spend,
round(100*(spend-lag(spend) over( partition by product_id order by EXTRACT(year from transaction_date) )) / lag(spend) over( partition by product_id order by EXTRACT(year from transaction_date)),2) as yoy_rate
from user_transactions

--ex2https://datalemur.com/questions/card-launch-success  Card Launch Success [JPMorgan Chase SQL Interview Question]
WITH CTE AS(
SELECT *,
rank() over(partition by card_name order by issue_year,issue_month ) 
as RANK from monthly_cards_issued ) 
select card_name,issued_amount FROM CTE
where rank=1
order by issued_amount desc

---ex3 https://datalemur.com/questions/sql-third-transaction User's Third Transaction [Uber SQL Interview Question]

with cte as(
select user_id,spend, transaction_date  ,
row_number() over (partition by user_id order by transaction_date) as a
from transactions) 

select user_id, spend, transaction_date 
from cte
where a=3

---ex4 
WITH cte AS (
  SELECT 
    transaction_date, 
    user_id, 
    product_id, 
    RANK() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date DESC) AS transaction_rank 
  FROM user_transactions) 
SELECT 
  transaction_date, 
  user_id,
  COUNT(product_id) AS purchase_count
FROM cte
WHERE transaction_rank = 1 
GROUP BY transaction_date, user_id
ORDER BY transaction_date;


---ex5 https://datalemur.com/questions/rolling-average-tweets 
SELECT user_id,tweet_date,
round(avg(tweet_count) over(partition by user_id order by tweet_date 
rows between 2 preceding and current row),2) AS rolling_avg_3d
from tweets r

---ex6 https://datalemur.com/questions/repeated-payments  Repeated Payments [Stripe SQL Interview Question]
with cte as(
select merchant_id,
extract(epoch from transaction_timestamp-lag(transaction_timestamp)
over(partition by amount,merchant_id,credit_card_id order by transaction_timestamp))/60 as diff 
from transactions)
select count(merchant_id) as dem
from cte
where diff<=10

---ex7  https://datalemur.com/questions/sql-highest-grossing Highest-Grossing Items
select category,product,total_spend 
from(
select category,product,
sum(spend) as total_spend, 
rank()over(partition by category order by sum(spend) DESC ) as ranking
from product_spend 
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product) as t
where ranking<=2

---ex8
with cte as(
SELECT a.artist_name,
dense_rank () over(order by count(b.song_id) desc) as artist_rank
from artists a
join songs b on a.artist_id=b.artist_id
join global_song_rank c on c.song_id=b.song_id
where c.rank<=10
group by a.artist_name)

select artist_name, artist_rank
from cte
where artist_rank<=5








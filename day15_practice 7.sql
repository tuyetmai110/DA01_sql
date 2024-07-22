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

---ex7 


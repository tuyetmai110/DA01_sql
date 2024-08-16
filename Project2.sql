--- 1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
SELECT 
  FORMAT_TIMESTAMP('%Y-%m', shipped_at) AS month_year,
  COUNT(DISTINCT user_id) AS total_user,
  COUNT(order_id) AS total_order
FROM  bigquery-public-data.thelook_ecommerce.order_items
WHERE 
  shipped_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY 
  month_year
ORDER BY 
  month_year

---2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select FORMAT_TIMESTAMP('%Y-%m', shipped_at) AS month_year,
round(sum(sale_price)/count(order_id),2) as average_order_value,sum(distinct user_id) as distinct_users,
from bigquery-public-data.thelook_ecommerce.order_items
WHERE shipped_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY  month_year
ORDER BY  month_year

---3. Nhóm khách hàng theo độ tuổi
WITH ranked_users AS (
SELECT  first_name,last_name,gender, age, 'youngest' AS tag,
RANK() OVER(PARTITION BY gender ORDER BY age ASC) AS rank
FROM bigquery-public-data.thelook_ecommerce.users
WHERE  FORMAT_TIMESTAMP('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04'
UNION ALL
  
SELECT first_name,last_name, gender,age,'oldest' AS tag,
RANK() OVER(PARTITION BY gender ORDER BY age DESC) AS rank
FROM bigquery-public-data.thelook_ecommerce.users
WHERE FORMAT_TIMESTAMP('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04')
SELECT * FROM ranked_users WHERE rank = 1

---4.Top 5 sản phẩm mỗi tháng.
WITH monthly_profit AS (
SELECT  FORMAT_TIMESTAMP('%Y-%m', a.created_at) AS month_year,
 a.product_id,   b.name AS product_name, SUM(b.retail_price) AS sales, SUM(b.cost) AS costs,
SUM(b.retail_price) - SUM(b.cost) AS profit
FROM bigquery-public-data.thelook_ecommerce.order_items a 
JOIN bigquery-public-data.thelook_ecommerce.products b  ON a.id = b.id 
GROUP BY month_year, a.product_id, b.name),

ranked AS (
SELECT  month_year, product_id,  product_name, sales,costs, profit,
DENSE_RANK() OVER(PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month
FROM monthly_profit)

SELECT month_year, product_id,  product_name, sales,costs, profit,rank_per_month
FROM ranked
WHERE rank_per_month <= 5
ORDER BY  month_year, rank_per_month

---5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục

SELECT FORMAT_TIMESTAMP('%Y-%m-%d', b.created_at) as dates,a.category as product_categories, sum(a.retail_price) as revenue
from bigquery-public-data.thelook_ecommerce.products a
join bigquery-public-data.thelook_ecommerce.order_items b on a.id=b.id
WHERE FORMAT_TIMESTAMP('%Y-%m-%d', b.created_at) BETWEEN '2022-01-15' AND '2022-04-14'
group by dates,a.category 
order by dates, a.category 
















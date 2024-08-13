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

















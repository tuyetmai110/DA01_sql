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



SELECT 
  first_name, 
  last_name, 
  gender,
  CASE 
    WHEN ROW_NUMBER() OVER(PARTITION BY gender ORDER BY age) = 1 THEN 'youngest' 
    ELSE NULL 
  END AS tag
FROM 
  `bigquery-public-data.thelook_ecommerce.users`

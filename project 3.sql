select * from public.sales_dataset_rfm_prj;

---1) Doanh thu theo từng ProductLine, Year  và DealSize? Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE
with revenue as(
select ProductLine,DealSize,YEAR_ID,
sum(priceeach*quantityordered) as REVENUE
from sales_dataset_rfm_prj
group by ProductLine,YEAR_ID,DealSize)

/* 2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
,month_revenue as(
select MONTH_ID,year_id, sum(priceeach*quantityordered) as REVENUE, count(ordernumber) as ORDER_NUMBER,
row_number()over(partition by year_id order by sum(priceeach*quantityordered) desc, count(ordernumber) desc)
from sales_dataset_rfm_prj
group by  MONTH_ID,year_id
)

/* 3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
,revenue_productline as (select MONTH_ID, productline,count(productline),sum(priceeach*quantityordered) as REVENUE
from sales_dataset_rfm_prj
where MONTH_ID=11
group by MONTH_ID,productline
order by count(productline) desc)

/* 4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK */
,A as(select YEAR_ID,PRODUCTLINE,sum(priceeach*quantityordered) as REVENUE,
ROW_NUMBER() OVER(PARTITION BY YEAR_ID ORDER BY sum(priceeach*quantityordered) DESC) AS RANK
from sales_dataset_rfm_prj
where country='UK'
group by YEAR_ID,PRODUCTLINE)


/* 5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM */
---b1 tính giá R-F-M
, rfm as (select customername, current_date-max(orderdate) as r,
count(distinct ordernumber) as f,
sum(priceeach*quantityordered) as m
from sales_dataset_rfm_prj
group by customername)
------b2 chia các giá trị thành các khoảng trên thang điểm 1-5
,rfm_score as(select customername,
ntile(5) over(order by r desc) as r_score,
ntile(5) over(order by f ) as f_score,
ntile(5) over(order by m ) as m_score
from rfm)
---b3 phân nhóm theo 125 tổ hợp r-gm
,rfm_final as(
select customername,
cast(r_score as varchar)||cast(f_score as varchar)||cast(m_score as varchar) as rfm_score
from rfm_score )
select segment,count(*)
from rfm_final a 
join segment_score b on a.rfm_score=b.scores
group by segment
































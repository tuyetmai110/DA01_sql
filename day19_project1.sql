create table SALES_DATASET_RFM_PRJ
(
  ordernumber VARCHAR,
  quantityordered VARCHAR,
  priceeach        VARCHAR,
  orderlinenumber  VARCHAR,
  sales            VARCHAR,
  orderdate        VARCHAR,
  status           VARCHAR,
  productline      VARCHAR,
  msrp             VARCHAR,
  productcode      VARCHAR,
  customername     VARCHAR,
  phone            VARCHAR,
  addressline1     VARCHAR,
  addressline2     VARCHAR,
  city             VARCHAR,
  state            VARCHAR,
  postalcode       VARCHAR,
  country          VARCHAR,
  territory        VARCHAR,
  contactfullname  VARCHAR,
  dealsize         VARCHAR
) 
select * from public.sales_dataset_rfm_prj


---Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 

ALTER table sales_dataset_rfm_prj
alter column priceeach type numeric using(trim(priceeach)::numeric)

ALTER TABLE sales_dataset_rfm_prj 
ALTER COLUMN orderdate TYPE timestamp WITHOUT TIME ZONE 
USING orderdate::timestamp WITHOUT TIME ZONE;

alter table sales_dataset_rfm_prj
alter column ordernumber type smallint
USING ordernumber::smallint 

alter table sales_dataset_rfm_prj
alter column quantityordered type smallint
using quantityordered::smallint

alter table sales_dataset_rfm_prj
alter column orderlinenumber type smallint
using orderlinenumber::smallint

alter table sales_dataset_rfm_prj
alter column sales type real
using sales::real

alter table sales_dataset_rfm_prj
alter column status type text
using status::text

alter table sales_dataset_rfm_prj
alter column productline type text
using productline::text

alter table sales_dataset_rfm_prj
alter column msrp type smallint
USING msrp::smallint 

alter table sales_dataset_rfm_prj
alter column productcode type character varying
USING productcode::character varying 

alter table sales_dataset_rfm_prj
alter column customername type text
using customername::text

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN dealsize TYPE text,
ALTER COLUMN contactfullname TYPE text,
ALTER COLUMN territory TYPE text,
ALTER COLUMN country TYPE text,
ALTER COLUMN state TYPE text,
ALTER COLUMN city TYPE text,
ALTER COLUMN addressline1 TYPE text,
ALTER COLUMN addressline2 TYPE text;

---Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED,PRICEEACH
---,ORDERLINENUMBER, SALES, ORDERDATE.
select * from public.sales_dataset_rfm_prj

SELECT *
FROM public.sales_dataset_rfm_prj
WHERE ORDERNUMBER IS NULL 
   OR QUANTITYORDERED IS NULL 
   OR PRICEEACH IS NULL 
   OR ORDERLINENUMBER IS NULL 
   OR SALES IS NULL 
   OR ORDERDATE IS NULL 


---3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
---Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
---Gợi ý: ( ADD column sau đó UPDATE)
select * from public.sales_dataset_rfm_prj

ALTER table sales_dataset_rfm_prj
ADD Column CONTACTLASTNAME varchar(20),
ADD Column CONTACTFIRSTNAME varchar(20)

update sales_dataset_rfm_prj
set CONTACTFIRSTNAME=substring(contactfullname,position('-' in contactfullname)+1,length(contactfullname)-position('-' in contactfullname)+1)
set CONTACTLASTNAME=substring(contactfullname,1,position('-' in contactfullname)-1)

---4.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
select * from public.sales_dataset_rfm_prj

ALTER table sales_dataset_rfm_prj
ADD Column YEAR_ID smallint
	
	ALTER table sales_dataset_rfm_prj
	ADD Column QTR_ID smallint
	
	ALTER table sales_dataset_rfm_prj
	ADD Column MONTH_ID smallint

update sales_dataset_rfm_prj
set QTR_ID=EXTRACT(quarter from orderdate)

update sales_dataset_rfm_prj
set MONTH_ID=EXTRACT(month from orderdate)

update sales_dataset_rfm_prj
set YEAR_ID=EXTRACT(year from orderdate)


---5.Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và
---hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
-- cách 1: sử dung IQR/BOXPLOT tìm ra outlier
-- B1: Tính Q1,Q3,IQR
-- b2: xấc định min=Q1-1.5*IQR; MAX=Q3+1.5*IQR
--b3: xác định outlier <min or >max

with cte as(	
select Q1-1.5*IQR AS min_value,
Q3+1.5*IQR as max_value
from(
select 
percentile_cont(0.25) within group (order by quantityordered) as q1,
percentile_cont(0.75) within group (order by quantityordered) as q3,
percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.75) within group (order by quantityordered) as iqr
from sales_dataset_rfm_prj) as a ) 

select quantityordered from sales_dataset_rfm_prj
where quantityordered<(select min_value from cte)
or quantityordered>(select max_value from cte)

-- cách 2: sử dụng Z-SCORE =(quantityordered-avg)/stddev
with cte as(
select quantityordered,(select avg(quantityordered) from sales_dataset_rfm_prj) as avg ,
( select stddev(quantityordered) as stddev from sales_dataset_rfm_prj)  from sales_dataset_rfm_prj),

cte1 as (select (quantityordered-avg)/stddev as z_score from cte
where  abs((quantityordered-avg)/stddev )>3)

update sales_dataset_rfm_prj
set quantityordered=(select avg(quantityordered) from sales_dataset_rfm_prj) 
where quantityordered in (select quantityordered from cte1)


---6 Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN
alter table sales_dataset_rfm_prj
rename to SALES_DATASET_RFM_PRJ_CLEAN










































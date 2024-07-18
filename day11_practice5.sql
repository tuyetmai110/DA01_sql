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

*---ex5 The Number of Employees Which Report to Each Employee 
---https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/description/?envType=study-plan-v2&envId=top-sql-50
select emp1.employee_id, emp1.name, count(emp2.employee_id) as  reports_count, round(avg(emp2.age))  as average_age
from employees as emp1
join employees as emp2 on emp1.employee_id=emp2.reports_to
group by emp1.employee_id, emp1.name
order by emp1.employee_id

  

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

                                         MID-COURSE TEST

/* Câu hỏi 1:
Topic: DISTINCT
Task: Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
Question: Chi phí thay thế thấp nhất là bao nhiêu?
Answer: 9.99 */
select distinct replacement_cost from film
order by replacement_cost

/* Question 2:
Topic: CASE + GROUP BY
Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau
1.low: 9.99 - 19.99
2.medium: 20.00 - 24.99
3.high: 25.00 - 29.99
Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?
Answer: 514 */
select 
case 
	when replacement_cost between 9.99 and 19.99 then 'low' 
	when replacement_cost between 20.00 and 24.99 then 'medium'
else 'high'
end as category, count(film_id) as soluong
	from film
group by category

/* Question 3:
Topic: JOIN
Task: Tạo danh sách các film_title  bao gồm tiêu đề (title), 
độ dài (length) và tên danh mục (category_name) được sắp xếp theo độ dài giảm dần.
Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?
Answer: Sports : 184 */
select a.title, a.length as do_dai, c.name as ten_danhmuc
from film as a
join film_category as b on a.film_id=b.film_id
join category as c on b.category_id=c.category_id
where c.name='Drama' or c.name='Sports'
order by a.length desc

/* Question 4:
Topic: JOIN & GROUP BY
Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?
Answer: Sports :74 titles*/
select c.name, count(a.film_id)
from film as a
join film_category as b on a.film_id=b.film_id
join category as c on b.category_id=c.category_id
group by c.name
order by count(a.film_id) desc
	
/* Question 5:
Topic: JOIN & GROUP BY
Task:Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.
Question: Diễn viên nào đóng nhiều phim nhất?
Answer: Susan Davis : 54 movies */

select a.first_name || ' '|| a.last_name as hovaten,count(b.film_id) from actor as a
join film_actor as b on a.actor_id=b.actor_id
group by hovaten
order by count(b.film_id) desc


/* Question 6:
Topic: LEFT JOIN & FILTERING
Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Question: Có bao nhiêu địa chỉ như vậy?
Answer: 4 */

select count(address) from address
where address.address not in(
	select address from address
	join customer on address.address_id=customer.address_id
)



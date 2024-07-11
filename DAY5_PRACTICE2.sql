4,

---EX1 Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
Select DISTINCT CITY FROM STATION
WHERE ID%2=0
  
---EX2 Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
SELECT count(CITY)-COUNT( DISTINCT CITY) FROM STATION

---3XX3 
select CEILING(avg(salary)-avg(replace(salary, '0', '')) )
from EMPLOYEES

---ex4 datalemur-alibaba-compressed-mean.
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/sum(order_occurrences) AS DECIMAL),1) 
FROM items_per_order

---EX5 
Select candidate_id FROM candidates
Where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id
Having count(skill)=3

---ex6 datalemur-verage-post-hiatus-1.
SELECT user_id,
date(max(post_date))-date(min(post_date))as days_between FROM posts
where post_date>='2021-01-01' and post_date<'2022-01-01'
group by user_id
having count(post_id)>=2

---ex7 Cards Issued Difference
SELECT card_name,
max(issued_amount)-min(issued_amount)
FROM monthly_cards_issued
group by card_name
order by max(issued_amount)-min(issued_amount) desc

---ex8 Output the manufacturer's name, the number of drugs associated with losses, and the total losses in absolute value. 
---Display the results sorted in descending order with the highest losses displayed at the top.
SELECT manufacturer,
count(drug) as drug_count,
abs(sum(cogs-total_sales)) as total_loss
FROM pharmacy_sales
where total_sales<cogs
group by manufacturer
order by total_loss desc

---EX9 Not Boring Movies
select id,movie,description,rating from Cinema
where id%2!=0 and description!='boring'
order by rating desc

---EX10 Write a solution to calculate the number of unique subjects each teacher teaches in the university.
select teacher_id, count( distinct subject_id) as cnt
from Teacher
group by teacher_id

---EX11 Find Followers Count
select user_id, count(follower_id)as followers_count
from Followers
group by user_id


---EX12.  Classes More Than 5 Students
SELECT class from courses
group by class
having count(student)>=5

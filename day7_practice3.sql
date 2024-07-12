EX1 ---Query the Name of any student in STUDENTS who scored higher than 75  Marks.
---Order your output by the last three characters of each name.
---If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
select name from STUDENTS
where marks>75
order by right(name,3),ID

---EX2 Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.
select user_id, 
concat(upper(LEFT(name,1)),lower(substring(name from 2 for length(name)-1))) as name
concat(upper(LEFT(name,1)),lower(right(name,length(name)-1))) as name
concat(upper(LEFT(name,1)),lower(substring(name from 2))) as name
from Users
order by user_id

---ex3 Write a query to calculate the total drug sales for each manufacturer. 
---Round the answer to the nearest million and report your results in descending order of total sales.
---In case of any duplicates, sort them alphabetically by the manufacturer name.
SELECT manufacturer,'$' || round(sum(total_sales)/1000000,0) || ' '|| 'million'
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales), manufacturer

---ex4:Average Review Ratings
SELECT EXTRACT(month from submit_date) as mth,
product_id	, round(avg(stars),2) as avg_stars
FROM reviews
group by mth,product_id
order by mth, product_id

---ex5 who sent the highest number of messages on Microsoft Teams in August 2022. 
---Display the IDs of these 2 users along with the total number of messages they sent
SELECT sender_id,count(message_id) as message_count
FROM messages
where extract(year from sent_date)=2022 and extract(month from sent_date)=8
group by sender_id
order by message_count desc
limit 2

---ex6 Invalid Tweets
select tweet_id 
from Tweets
where length(content)>15

---ex7
select activity_date as day, count(distinct(user_id)) as active_users from Activity
where activity_date between "2019-06-28" and "2019-07-27"
group by activity_date;

---EX8 Number of Hires During Specific Time Period
select count(id), extract(month from joining_date) AS MONTH
from employees
where extract(month from joining_date) between 1 and 7 
and extract(year from joining_date)=2022
group by extract(month from joining_date)


---EX9 Find the position of the lower case letter 'a' in the first name of the worker 'Amitah'.
select POSITION('a' IN first_name) from worker
where first_name= 'Amitah'

---ex10 Macedonian Vintages
select substring(title,length(winery)+2, 4)
from winemag_p2
where country='Macedonia'




























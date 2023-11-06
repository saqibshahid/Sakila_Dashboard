with week_customers as (
select 
customer_id,
Date(rental_date),
DATE(rental_date - INTERVAL WEEKDAY(rental_date)+1 DAY) AS week_date ,
dense_rank() over(partition by customer_id order by rental_date asc) order_rank,  
week(Date(rental_date),1) as rental_week,  
lag(week(Date(rental_date),1),1) over (partition by customer_id) as previous_rent_week, 
week(Date(rental_date),1) - lag(week(Date(rental_date),1),1) over (partition by customer_id) as diff_week 
from rental 
where year(rental_date) != '2006' 
) 
 ,
  _list as (
 select 
rental_week,
week_date,
count(distinct customer_id) as total_customers,
count(distinct case when order_rank=1 then customer_id end) as new_customers,
count(distinct case when diff_week=1 or diff_week=2 then customer_id end) as retain_customers,
count(distinct case when diff_week>2 then customer_id end) as returning_customers,
lag(count(distinct customer_id) , 1) over(order by rental_week) prev_week_customer 
from week_customers
group by rental_week , week_date
)
select * ,
retain_customers*100/prev_week_customer as retention_rate, 
100- (retain_customers*100/prev_week_customer) as churn_rate 
from _list
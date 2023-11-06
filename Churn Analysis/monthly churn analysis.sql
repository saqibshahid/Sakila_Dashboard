-- create view churn_analysis as 
with date_table as (
select *, 
DATE_FORMAT(rental_date, '%Y-%m') as _month, 
dense_rank() over (partition by customer_id order by rental_date asc) as _rank,
DATE_FORMAT(rental_date, '%Y%m') as _date, 
lag( DATE_FORMAT(rental_date,'%Y%m'),1) over (partition by customer_id) previous_rent_month 
from rental
)
,
customer_table as  ( 
select
_month, 
_date, 
count(distinct case when _rank = 1 then customer_id end) as new_customer,
count(distinct customer_id) total_customers , 
count(distinct case when PERIOD_DIFF(_date, previous_rent_month) = 1 then customer_id end) as retain_customers, 
count(distinct case when PERIOD_DIFF(_date, previous_rent_month) > 1 then customer_id end) as returning_customers, 
lag(count(distinct customer_id) , 1) over(order by _date) prev_total_customer 
From date_table 
group by _date, _month
)
select _month,
total_customers,
new_customer,
retain_customers,
returning_customers,
 retain_customers*100/prev_total_customer as retention_rate, 
100- (retain_customers*100/prev_total_customer) as churn_rate 
from customer_table 
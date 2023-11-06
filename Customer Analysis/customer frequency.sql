with day_diff_rent as (
select cus.customer_id,
       cus.first_name,
       r.rental_date,
       dense_rank() over (partition by cus.customer_id order by r.rental_date asc) as rental_rank,
       lag(r.rental_date) over (partition by cus.customer_id order by r.rental_date ) as privs_date,
    datediff(r.rental_date, lag(r.rental_date) over (partition by cus.customer_id order by r.rental_date )) as day_diff
from customer cus 
left join rental r 
on cus.customer_id = r.customer_id
group by cus.customer_id, cus.first_name, r.rental_id
),
customer_avg_day as (select customer_id ,
	   first_name,
      round(avg(day_diff)) as avg_day 
from day_diff_rent
group by customer_id)
-- , customer_frequency as (
select 
customer_id ,
	   first_name,
case when avg_day between 1 and 3 then '1-3 days'
     when avg_day between 4 and 7 then '4-7 days'
     when avg_day between 8 and 10 then '8-10 days'
     else 'Above 10 days' 
     end as rental_frequency_range,
CASE
            WHEN avg_day BETWEEN 1 AND 3 THEN 'Most Frequent'
            WHEN avg_day BETWEEN 4 AND 7 THEN 'Frequent'
            WHEN avg_day BETWEEN 8 AND 10 THEN 'Less Frequent'
            ELSE 'Infrequent'
        END AS rental_frequency
from customer_avg_day
-- )
-- select 
-- cf.rental_frequency_range,
-- cf.rental_frequency,
-- count(cf.rental_frequency) as total_customers
-- from customer_frequency cf
-- group by cf.rental_frequency_range,
-- cf.rental_frequency
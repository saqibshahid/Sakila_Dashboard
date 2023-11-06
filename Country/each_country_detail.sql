-- create view  each_country_detail as
SELECT 
country.country_id,
country.country, 
count(distinct city.city_id) as no_of_city,  
sum(payment.amount) as revenue,
count(distinct customer.customer_id) as total_customers,
count(distinct payment.rental_id) as rental_count,
dense_rank () over(order by sum(payment.amount) desc) as _rank
FROM country  
left join city
on country.country_id = city.country_id
left join address
on city.city_id = address.city_id
left join customer
on address.address_id = customer.address_id
left join payment
on customer.customer_id = payment.customer_id
group by country.country_id

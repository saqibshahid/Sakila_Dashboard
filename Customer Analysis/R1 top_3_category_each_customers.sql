-- create view customer_category as
with movies as (
select customer.customer_id, 
customer.first_name,
 category.name as category,
 category.category_id,
 count(category.name) as movie_rental_count,
rank() over(partition by customer.customer_id order by count(category.category_id) desc) as category_rank
from customer
left join rental 
on customer.customer_id = rental.customer_id
left join inventory
on rental.inventory_id = inventory.inventory_id
left join film_category
on inventory.film_id = film_category.film_id
left join category
on film_category.category_id = category.category_id
 group by customer.customer_id, customer.first_name, category.name, category.category_id
  )
  select * from movies 
  where category_rank <= 3
 -- create view top_recomanded_movies as
 with top_3_recomanded as (
select 
A.customer_id, 
A.first_name,
B.category,
B.category_id,
B.film_title,
B.film_id 
from customer_movies A
left join top_3_movies_each_category B
on A.category_id = B.category_id and A.film_id != B.film_id
)
select  
DISTINCT
top.customer_id,
top.first_name,
top.category,
top.category_id,
top.film_title
from top_3_recomanded top 
inner join customer_top_seen_movies seen
on top.film_id != seen.film_id and top.customer_id = seen.customer_id and top.category = seen.category




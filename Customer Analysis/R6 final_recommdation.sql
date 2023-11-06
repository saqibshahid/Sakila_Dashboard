-- create view recomanded_movies as
select 
DISTINCT 
cus.customer_id,
cus.first_name,
cus.category,
ml.film_title 
 
from customer_category cus
left join top_recomanded_movies ml 
on cus.customer_id = ml.customer_id and cus.category = ml.category
WHERE ml.film_title IS NOT NULL
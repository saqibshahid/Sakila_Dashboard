-- user seen in top 3
-- create view customer_top_seen_movies as 
select 
DISTINCT
A.customer_id, 
A.first_name,
B.category,
B.category_id,
B.film_title ,
B.film_id
from top_3_movies_each_category B 
left join customer_movies A
on A.category_id = B.category_id and A.film_id = B.film_id

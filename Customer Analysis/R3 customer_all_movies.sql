-- all movies that use can seen
-- create view customer_movies as
select 
 cst.customer_id,
 cst.first_name,
 cat.name as category,
 cat.category_id,
 f.title as film_title,
 f.film_id
from customer cst
left join  rental r 
on cst.customer_id = r.customer_id
left join inventory inv 
on r.inventory_id = inv.inventory_id
left join film f 
on inv.film_id = f.film_id
left join film_category fc 
on fc.film_id = f.film_id
left join category cat 
on cat.category_id = fc.category_id
order by cst.customer_id, cat.category_id
-- top 3 movies each category
-- create view top_3_movies_each_category as
with _movies as (
select 
 cat.name as category,
 cat.category_id,
 f.title as film_title,
 f.film_id,
 count(inv.film_id) as movie_rent_count,
 sum(pay.amount) as movie_revenue,
 dense_rank() over (partition by cat.category_id order by count(inv.film_id) desc, sum(pay.amount) desc) as movie_rank
from  film f 
left join  film_category fc 
on fc.film_id = f.film_id
left join category cat 
on cat.category_id = fc.category_id
left join inventory inv 
on f.film_id = inv.film_id
left join rental re 
on re.inventory_id = inv.inventory_id
left join payment pay 
on pay.rental_id = re.rental_id 
group by f.film_id, cat.category_id
 order by cat.name
 )
 select * from _movies
 where movie_rank <= 3
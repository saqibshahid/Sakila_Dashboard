with weekly_seen as (
SELECT 
DATE_FORMAT(r.rental_date, '%v') as _week, -- 1st day is monday
cat.category_id,
cat.name,
count(cat.category_id) as category_count,
dense_rank() over (partition by DATE_FORMAT(r.rental_date, '%v')  order by count(cat.category_id) desc) as category_rank 
FROM rental r
left join inventory inv 
on r.inventory_id = inv.inventory_id
left join film f 
on inv.film_id = f.film_id 
left join film_category fc 
on f.film_id = fc.film_id
left join category cat 
on fc.category_id = cat.category_id
group by  _week,  cat.category_id
)
select * from weekly_seen
where category_rank <=2
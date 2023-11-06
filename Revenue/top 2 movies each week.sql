with weekly_seen as (
SELECT 
DATE_FORMAT(r.rental_date, '%v') as _week, -- 1st day is monday
f.film_id,
f.title,
count(f.film_id) as film_count,
dense_rank() over (partition by DATE_FORMAT(r.rental_date, '%v')  order by count(f.film_id) desc) as film_rank 
FROM rental r
left join inventory inv 
on r.inventory_id = inv.inventory_id
left join film f 
on inv.film_id = f.film_id 
group by  _week,  f.film_id
)
select * from weekly_seen
where film_rank <=2



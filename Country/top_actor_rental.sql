with actor_of_country as(
SELECT
  co.country,
  co.country_id,
  a.actor_id,
  a.first_name,
  a.last_name,
  COUNT(r.rental_id) AS rental_count,
  dense_rank() over (partition by co.country order by COUNT(r.rental_id) desc) as rank_on_actor
FROM
  actor a
  left JOIN film_actor fa ON a.actor_id = fa.actor_id
  left JOIN film f ON fa.film_id = f.film_id
  left JOIN inventory inv ON f.film_id = inv.film_id
  left JOIN rental r ON inv.inventory_id = r.inventory_id
  left JOIN customer cu ON r.customer_id = cu.customer_id
  left JOIN address ad ON cu.address_id = ad.address_id
  left JOIN city ci ON ad.city_id = ci.city_id
  left JOIN country co ON ci.country_id = co.country_id
GROUP BY
  co.country_id, a.actor_id
)
 ,top_actor as (
   SELECT ac.country,
	ac.country_id,
	MAX(ac.rental_count) as max_rental_count 
	FROM actor_of_country ac
	 GROUP BY ac.country_id
     )
      select 
        A2.country_id,
		A2.country,
        A1.actor_id,
        A1.first_name,
        A1.last_name,
        A2.max_rental_count 
   from actor_of_country A1 
   left join top_actor A2
   on A2.country_id = A1.country_id AND A2.max_rental_count = A1.rental_count
    where A2.country_id is not null
   ORDER BY A2.max_rental_count DESC
     

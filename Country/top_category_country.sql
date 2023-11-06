-- create view  top_category_country as
with category_of_country as (
SELECT 
cnt.country,
cnt.country_id,
cat.name AS category,
cat.category_id,
COUNT(*) AS no_of_rentals,
sum(pay.amount),
dense_rank() over (partition by cnt.country order by count(r.rental_id)desc, sum(pay.amount) desc) as rank_on_category
FROM rental r
LEFT JOIN customer cstm
  ON r.customer_id = cstm.customer_id
LEFT JOIN address adr
  ON cstm.address_id = adr.address_id
LEFT JOIN city ct
  ON adr.city_id = ct.city_id
LEFT JOIN country cnt
  ON ct.country_id = cnt.country_id
LEFT JOIN inventory i
  ON i.inventory_id = r.inventory_id
LEFT JOIN film f
  ON f.film_id = i.film_id
LEFT JOIN film_category fc
  ON fc.film_id = f.film_id
LEFT JOIN category cat
  ON cat.category_id = fc.category_id
left join payment pay 
  on pay.rental_id = r.rental_id 
 GROUP BY cnt.country_id, cat.category_id
 )
  ,top_category as (
   SELECT A1.country,
	A1.country_id,
	MAX(A1.no_of_rentals) AS no_of_rentals
	FROM category_of_country A1
	 GROUP BY A1.country_id
     )
 select 
        A2.country_id,
		A2.country,
        A1.category,
        A2.no_of_rentals
   from category_of_country A1 
   left join top_category A2
   on A2.country_id = A1.country_id AND A2.no_of_rentals = A1.no_of_rentals
   where A2.country_id is not null
   ORDER BY A2.no_of_rentals DESC
  
 -- create view  each_costomer_details as
SELECT 
  cu.customer_id,
  cu.first_name as customer_name,
  ct.country,
  c.city,
  sum(p.amount) as amount_spend,
  count(r.rental_id) as rental_count
FROM customer cu 
left join payment p
on cu.customer_id = p.customer_id
left join rental r
on r.customer_id = cu.customer_id
left join address ad 
on cu.address_id = ad.address_id
left join city c 
on ad.city_id = c.city_id
left join country ct 
on ct.country_id = c.country_id
group by cu.customer_id
-- view per_day_revenue as
SELECT 
DATE_FORMAT(r.rental_date, '%v') as _week, -- 1st day is monday
DATE_FORMAT(r.rental_date, '%W') as _day,
count(r.rental_id) as rental_count,
sum(p.amount) as revenue
FROM rental r
left join payment p
on r.rental_id = p.rental_id 
group by  _week, _day
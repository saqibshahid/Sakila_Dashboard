WITH MaxDate AS (
  SELECT MAX(rental_date) AS max_date
  FROM rental
)
, rfm AS (
  SELECT 
    c.customer_id,
    c.first_name,
    DATEDIFF((SELECT max_date FROM MaxDate), MAX(r.rental_date)) AS R,
    COUNT(r.rental_id) AS F,
    SUM(p.amount) AS M
  FROM customer c
  LEFT JOIN rental r
    ON c.customer_id = r.customer_id
  LEFT JOIN payment p
    ON r.rental_id = p.payment_id
  GROUP BY c.customer_id, c.first_name
), rfm_with_ntile AS (
  SELECT 
    rfm.customer_id, 
    rfm.first_name, 
    rfm.R AS Recency, 
    rfm.F AS Frequency, 
    rfm.M AS Monetary,
    NTILE(4) OVER (ORDER BY rfm.R DESC) as R_S,
    NTILE(4) OVER (ORDER BY rfm.F ASC) as F_S,
    NTILE(4) OVER (ORDER BY rfm.M ASC) as M_S
  FROM rfm
)

SELECT 
  customer_id, 
  first_name, 
  Recency, 
  Frequency, 
  Monetary,
  R_S,
  F_S,
  M_S,
  concat(R_S,'-',F_S,'-',M_S) as RFM,
  (CASE
    WHEN (R_S = 4) AND (F_S = 4) AND (M_S = 4) THEN 'Champions'
    WHEN (R_S BETWEEN 3 AND 4) AND (F_S BETWEEN 3 AND 4) AND (M_S BETWEEN 2 AND 4) THEN 'Loyal Customers'
    WHEN (R_S BETWEEN 3 AND 4) AND (F_S BETWEEN 1 AND 4) AND (M_S BETWEEN 1 AND 4) THEN 'Potential Loyalists'
    WHEN (R_S = 4) AND (F_S = 1) AND (M_S = 1) THEN 'New Customers'
    WHEN (R_S = 3) AND (F_S BETWEEN 1 AND 3) AND (M_S BETWEEN 1 AND 3) THEN 'Promising'
    WHEN (R_S BETWEEN 2 AND 3) AND (F_S BETWEEN 1 AND 4) AND (M_S BETWEEN 1 AND 4) THEN 'Need Attention'
    WHEN (R_S = 2) AND (F_S = 1) AND (M_S = 2) THEN 'About to sleep'
    WHEN (R_S <= 2) AND (F_S BETWEEN 1 AND 4) AND (M_S BETWEEN 1 AND 4) THEN 'At risk'
    WHEN (R_S <= 2) AND (F_S BETWEEN 3 AND 4) AND (M_S BETWEEN 2 AND 4) THEN 'Cannot lose them'
    WHEN (R_S = 1) AND (F_S = 2) AND (M_S = 1) THEN 'Hibernating'
    WHEN (R_S = 1) AND (F_S = 1) AND (M_S = 1) THEN 'Lost'
  END) AS rfm_segment
FROM rfm_with_ntile;
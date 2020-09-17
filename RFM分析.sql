-- -----------------------------------------------
-- RFM Analysis
-- -----------------------------------------------

with cte_shopper_rfm_base as (
select
  ord.shopper_id
  , min(datediff(d, ord.order_date, cast(getdate() as date))) as recency
  -- , min(datediff(cast(now() as date), ord.order_date)) as recency  -- MySQL
  , count(*) as frequency
  , avg(ord.order_amt) as monetary
from
  sales_orders ord
group by
  ord.shopper_id
)
, cte_shopper_rfm_score as (
select
  a.shopper_id
  , a.recency
  , case when a.recency <= 30 then 5
    else case when a.recency <= 90 then 4
    else case when a.recency <= 180 then 3
    else case when a.recency <= 240 then 2
    else 1
    end end end end
  as recency_score
  , a.frequency
  , case when frequency <= 2 then 1
      else case when frequency <= 4 then 2
      else case when frequency <= 6 then 3
      else case when frequency <= 8 then 4
    else 5
    end end end end
  as frequency_score
  , monetary
  , ntile(5) over (order by a.monetary)  as monetary_score 
from
  cte_shopper_rfm_base a
)
select
  a.recency_score
  , a.frequency_score
  , a.monetary_score
  , a.recency_score + a.frequency_score + a.monetary_score as total_score
  , count(*) as shopper_cnt
from
  cte_shopper_rfm_score a
group by
  a.recency_score
  , a.frequency_score
  , a.monetary_score
  , a.recency_score + a.frequency_score + a.monetary_score
order by
  a.recency_score + a.frequency_score + a.monetary_score desc
  , a.recency_score
  , a.frequency_score
  , a.monetary_score
;

-- -----------------------------------------------
-- Cohort Analysis
-- -----------------------------------------------

with cte_pucchase_history as (
select
  a.shopper_id
  , year(a.order_date) as yr
  , month(a.order_date) as mth
  , a.order_date
  , row_number() over (partition by a.shopper_id order by a.order_date) as rownum
from 
  (
  select 
    distinct
    ord.shopper_id 
    , ord.order_date
  from
    sales_orders ord
  ) a
)
, cte_return_tracking as (
select
  a.shopper_id
  , a.yr
  , a.mth
  , sum(case when datediff(d, a.order_date, b.order_date) between 1  and 30 then 1 else 0 end) as bucket_30d
  , sum(case when datediff(d, a.order_date, b.order_date) between 31 and 60 then 1 else 0 end) as bucket_60d
  -- , sum(case when datediff(b.order_date, a.order_date) between 1  and 30 then 1 else 0 end) as bucket_30d -- MySQL
  -- , sum(case when datediff(b.order_date, a.order_date) between 31 and 60 then 1 else 0 end) as bucket_60d -- MySQL
from
  cte_pucchase_history a
  left outer join cte_pucchase_history b on a.shopper_id = b.shopper_id and a.rownum <> b.rownum
where
  a.rownum = 1
group by
  a.shopper_id
  , a.yr
  , a.mth
)
, cte_retention_summary as (
select
  a.yr
  , a.mth
  , sum(case when a.bucket_30d > 0 then 1 else 0 end) as bucket_30d
  , sum(case when a.bucket_60d > 0 then 1 else 0 end) as bucket_60d
from
  cte_return_tracking a
group by
  a.yr
  , a.mth
)
, cte_cohort as (
select
  yr
  , mth
  , sum(case when rownum = 1 then 1 else 0 end) as first_time_shopper_cnt
  , count(distinct hist.shopper_id) as total_shopper_cnt
from
  cte_pucchase_history hist
group by
  yr
  , mth
)
select
  ch.*
  , ret.bucket_30d bucket_30d_cnt
  , ret.bucket_30d * 100.0 / ch.first_time_shopper_cnt as bucket_30d
  , ret.bucket_60d bucket_60d_cnt
  , ret.bucket_60d * 100.0 / ch.first_time_shopper_cnt as bucket_60d
from
  cte_cohort ch
  inner join cte_retention_summary ret on ret.yr = ch.yr and ret.mth = ch.mth
order by
  ch.yr
  , ch.mth
;

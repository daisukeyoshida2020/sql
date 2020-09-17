-- -----------------------------------------------
-- Window Functions
-- -----------------------------------------------

-- SUM
select
  cat.category_layer2
  , prd.product_name
  , ord.order_date
  , sum(ord.order_amt)
  , sum(ord.order_amt) over() as window_sum01
  -- , sum(ord.order_amt) over(order by ord.order_date) as window_sum02
  -- , sum(ord.order_amt) over(partition by cat.category_layer2 order by ord.order_date) as window_sum03
from
  sales_orders ord
  inner join product_master prd on prd.product_id = ord.product_id
  inner join product_category_master cat on cat.product_category_id = prd.product_category_id
where
  ord.order_date between '2020-09-01' and '2020-09-04'
  and prd.product_name in (
  'Comfort Slide Sandal'
  , 'Outdoor Boot Cut Casual Pants'
  )
group by
  cat.category_layer2
  , prd.product_name
  , ord.order_date
  , ord.order_amt
order by
  cat.category_layer2
  , prd.product_name
  , ord.order_date
;


-- Frame
select
  cat.category_layer2
  , prd.product_name
  , ord.order_date
  , ord.order_id
  , ord.order_amt
  , sum(ord.order_amt) over(partition by cat.category_layer2 order by ord.order_date) as window_sum03
  , sum(ord.order_amt) over(partition by cat.category_layer2 order by ord.order_date rows UNBOUNDED PRECEDING)    as window_sum04
  , sum(ord.order_amt) over(partition by cat.category_layer2 order by ord.order_date rows between UNBOUNDED PRECEDING and 1 preceding) as window_sum05
from
  sales_orders ord
  inner join product_master prd on prd.product_id = ord.product_id
  inner join product_category_master cat on cat.product_category_id = prd.product_category_id
where
  ord.order_date between '2020-09-01' and '2020-09-04'
  and prd.product_name in (
  'Comfort Slide Sandal'
  , 'Outdoor Boot Cut Casual Pants'
  )
order by
  cat.category_layer2
  -- , prd.product_name
  , ord.order_date
;

-- LAG & LEAD
select
  year(a.order_date) yr
  , month(a.order_date) mth
  , count(distinct shopper_id) as shopper_cnt
  , count(*) as order_cnt
  , count(distinct product_id) as distinct_prod_cnt
  , sum(order_qty) as order_qty
  , sum(order_amt) as order_amt
  , lag(sum(order_amt)) over (order by year(a.order_date), month(a.order_date)) as prv_order_amt
  , lead(sum(order_amt)) over (order by year(a.order_date), month(a.order_date)) as next_order_amt
  , sum(order_amt) * 100.0 /  lag(sum(order_amt)) over (order by year(a.order_date), month(a.order_date)) as MoM
from
  sales_orders a
group by
  year(a.order_date)
  , month(a.order_date)
order by
  year(a.order_date)
  , month(a.order_date)
;


-- Rank
select
  year(a.order_date) yr
  , month(a.order_date) mth
   , count(distinct product_id) as distinct_prod_cnt
   , rank() over (order by count(distinct product_id) desc) as rnk
   , dense_rank() over (order by count(distinct product_id) desc) as d_rnk
   , row_number() over (order by count(distinct product_id) desc, year(a.order_date), month(a.order_date)) as rownum
from
  sales_orders a
group by
  year(a.order_date)
  , month(a.order_date)
;


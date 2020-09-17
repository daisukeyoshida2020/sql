-- -----------------------------------------------
-- ABC Analysis
-- -----------------------------------------------

with cte_total_amt as (
  select 
    sum(ord.order_amt) as order_amt
  from
    sales_orders ord
)
, cte_product_amt as (
select
  cat.category_layer1
  , cat.category_layer2
  , prd.product_name
  , coalesce(sum(ord.order_amt), 0) as order_amt
from
  product_master prd
  inner join product_category_master cat on cat.product_category_id = prd.product_category_id
  left outer join sales_orders ord on ord.product_id = prd.product_id
group by
  cat.category_layer1
  , cat.category_layer2
  , prd.product_name
)
select
  a.*
  , a.order_amt * 100.0 / b.order_amt as order_amt_ratio
from
  cte_product_amt a
  cross join cte_total_amt b
order by
  a.order_amt * 100.0 / b.order_amt desc
;

-- Windowä÷êîÉoÅ[ÉWÉáÉì

select 
  a.*
  , sum(a.order_amt_ratio) over (order by order_amt_ratio desc) as accumulate_amt_ratio
from 
  (
  select
    distinct
    cat.category_layer1
    , cat.category_layer2
    , prd.product_name
    , coalesce(sum(ord.order_amt) over (partition by prd.product_name), 0) as order_amt
    , coalesce(sum(ord.order_amt) over (partition by prd.product_name), 0) * 100.0 / sum(ord.order_amt) over() as order_amt_ratio 
  from
    product_master prd
    inner join product_category_master cat on cat.product_category_id = prd.product_category_id
    left outer join sales_orders ord on ord.product_id = prd.product_id
  ) a
order by
    a.order_amt_ratio desc
;

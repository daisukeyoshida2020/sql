-- ------------------------------------------
-- Inner Join
-- ------------------------------------------

select
  ord.*
  , prd.product_name
from 
  sales_orders ord
  inner join product_master prd on prd.product_id = ord.product_id
;

-- ------------------------------------------
-- Outer Join
-- ------------------------------------------

--����f�[�^���Ȃ�product��T��
select 
  prd.*
from 
  product_master prd 
where 
  not exists (select * from sales_orders ord where ord.product_id = prd.product_id)
;

select
  ord.*
  , prd.product_name
from 
  sales_orders ord
  right outer join product_master prd on prd.product_id = ord.product_id
where
  prd.product_id in ('004', '009')
;

-- ------------------------------------------
-- Cross Join
-- ------------------------------------------

with cte_grp_01 as (
select 
  product_name
from
  product_master prd
where
  prd.product_id in ('004', '009')
)
, cte_grp_02 as (
select 
  product_name
from
  product_master prd
where
  prd.product_id in ('010', '012')
)
select
  a.product_name as grp_01_product_name
  , b.product_name as grp_02_product_name
from
  cte_grp_01 a
  cross join cte_grp_02 b
;

select 
  year(ord.order_date) as yr
  , month(ord.order_date) as mth
  , sales_period.min_order_date
  , sales_period.max_order_date
  , sum(order_amt) as order_amt
from
  sales_orders ord
  cross join (select min(order_date) as min_order_date, max(order_date) as max_order_date from sales_orders ord) sales_period
where
  year(ord.order_date) = 2020
group by
  year(ord.order_date)
  , month(ord.order_date)
  , sales_period.min_order_date
  , sales_period.max_order_date
order by
  year(ord.order_date)
  , month(ord.order_date)
;

-- ------------------------------------------
-- HAVING
-- ------------------------------------------

select 
  ord.product_id
  , sum(ord.order_amt) as order_amt
from
  sales_orders ord
where
  order_date = '2020-09-04'
group by
  ord.product_id
having 
  sum(ord.order_amt) >= 30000
;

-- ------------------------------------------
-- CASE
-- ------------------------------------------

select
    year(a.order_date) as yr
  , sum(a.order_amt) as order_amt
  , sum(a.order_qty) as order_qty
from
  sales_orders a
group by
    year(a.order_date)
;

select
  'order_amt' as category_name
    , sum(case when year(a.order_date) = 2019 then a.order_amt else 0 end) as yr2019
    , sum(case when year(a.order_date) = 2020 then a.order_amt else 0 end) as yr2020
from
  sales_orders a
union all
select
  'order_qty' as category_name
    , sum(case when year(a.order_date) = 2019 then a.order_qty else 0 end) as yr2019
    , sum(case when year(a.order_date) = 2020 then a.order_qty else 0 end) as yr2020
from
  sales_orders a
;

-- ------------------------------------------
-- EXISTS�q��
-- ------------------------------------------

select
  prd.*
from
  product_master prd
where
  exists (select * from sales_orders ord where ord.product_id = prd.product_id)
;

-- ------------------------------------------
-- WITH
-- ------------------------------------------

WITH cte_numbers(n) AS (
-- WITH recursive cte_numbers(n) AS ( -- MySQL
select 1
union all
select n + 1 from cte_numbers where n < 10
)
SELECT 
  *
FROM 
    cte_numbers
;


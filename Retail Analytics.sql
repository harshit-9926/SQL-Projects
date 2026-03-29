use case_study;
SELECT * FROM customer_profiles;
select * from product_inventory;
select * from sales_transaction;

alter table sales_transaction
change column `ï»¿TransactionID` Transaction_id int;

alter table product_inventory
change column `productid_id` productID int;

alter table customer_profiles
change column `Transaction_id` Customer_id int;

-- cleaning sales trnsaction table
select * from sales_transaction;

SELECT * FROM customer_profiles;
select * from product_inventory;
select * from sales_transaction;

-- data cleaning sales transaction
set sql_safe_updates= 0;

update sales_transaction
set TransactionDate = replace(TransactionDate, '/','-');

-- count rows
select count(*)from sales_transaction;

-- checking duplicate
select transaction_id,  count(*) from sales_transaction
group by transaction_id
having count(*) >1;

select * from sales_transaction
where transaction_id in (4999,5000);

delete from sales_transaction
where transaction_id = 5000
limit 1;

-- handling null

select * from sales_transaction
where Transaction_id is null or CustomerID is null or ProductID is null or QuantityPurchased is null or TransactionDate is null or Price is null;

select * from sales_transaction;

update sales_transaction
set TransactionDate = str_to_date(TransactionDate,'%d-%m-%y');

select * from sales_transaction
where QuantityPurchased <=0 or Price <=0;

select * from sales_transaction;

select * from product_inventory;

select s.productid, s.price as saleprice, p.price as inventoryprice
from sales_transaction s
join product_inventory p
on s.productid = p.productid
where s.price != p.price ;

update sales_transaction s
join product_inventory p
on s.productid = p.productid
set s.price = p.price
where s.price != p.price ;

-- data cleaning product_inventory
select * from product_inventory;

select productid,count(*) from product_inventory
group by productid
having count(*)>1;

select * from product_inventory 
where productID is null or ProductName is null or Category is null or StockLevel is null or Price is null;

select * from product_inventory
where stocklevel <= 0;

select * from product_inventory
where price <= 0;

-- data cleaning customer_profiles

SELECT * FROM customer_profiles;

update customer_profiles
set JoinDate = replace(JoinDate,'/','-');

update customer_profiles
set JoinDate = str_to_date(JoinDate,'%d-%m-%y');


select * from customer_profiles
where Customer_id is null or Age is null or Gender is null or Location is null or JoinDate is null;

select * from customer_profiles
where age <10 or age >100;

delete from customer_profiles 
where age  <10 or age >100;

select distinct gender from customer_profiles;

select * from customer_profiles;

select count(location) from customer_profiles
where location ='';

update customer_profiles
set location = 'unknown'
where location = '';

-- TABLES HAS BEEN CLEANED



-- Product performance variability

SELECT * FROM customer_profiles;
select * from product_inventory;
select * from sales_transaction;

# 1 which product sell well
 
select productid, sum(quantityPurchased) as total_qty_sold, 
round(sum(quantityPurchased * price),2) as total_sale
from sales_transaction
group by productid
order by total_qty_sold desc;

# 2 which product are falling
select p.productid, p.productname, p.category, p.price, sum(s.quantityPurchased) as total_purchase, sum(p.stocklevel) as stock,
round(sum(s.quantityPurchased * p.price),2) AS total_revenue
from  product_inventory p
join sales_transaction s
on p.productid = s.ProductID
group by p.productid, p.productname, p.category, p.price
order by total_purchase asc
limit 10;

# which category perform best

select p.category, sum(s.quantitypurchased) as total_qty_sold,
round(sum(s.quantityPurchased * p.price),2) AS total_sale
from product_inventory p
join sales_transaction s on p.productid = s.productid
group by p.category
order by total_qty_sold desc;

# high & low sale products 
select productid, sum(quantityPurchased) as total_qty_sold
from sales_transaction
group by productid
having total_qty_sold > 0
order by total_qty_sold desc;


# daily sales trend
select cast(transactiondate as date) as trans_date, sum(quantityPurchased) as total_qty_sold,
round(sum(quantityPurchased * price),2) AS total_sale,
count(*) as total_transaction
from sales_transaction
group by trans_date
order by trans_date desc;

# month-on-month growth
with mom as(
select month(transactiondate) as month, round(sum(quantityPurchased * price),2) AS total_sale
from sales_transaction
group by month(transactiondate)
order by total_sale)
select month, total_sale,
lag(total_sale) over(order by month) as previous_month,
round(((total_sale - lag(total_sale) over(order by month))/
lag(total_sale) over(order by month))*100,2) as mom_growth
from mom
order by month;




-- customer segmentation
# 1 they don't know how to group by customer(orders 0 , 1- 10 ,11-30, 30+) (customer segment no order, low order, mid value, high value)
select * from sales_transaction;

with csutomer_segment as( 
select customerid, sum(quantitypurchased) as orders, round(sum(price*quantitypurchased),2)as total_sales
from sales_transaction
group by customerid)

select customerid, orders, total_sales,
case when
orders =0 then 'no order'
when orders between 1 and 10 then 'low order'
when orders between 11 and 30 then 'medium order'
when orders > 30 then 'high orders' else 0
end as order_segment
from csutomer_segment
order by orders desc;



-- customer behaviour analysis

# 1 do people buy again
# 2 who are loyal
# 3 who stopped buying means churned 

# how often do customer buy
select customerid, count(*) as num_of_trans
from sales_transaction
group by customerid
order by num_of_trans desc;


# high spend customer, high frequency
select customerid, count(*) as total_transaction, sum(quantitypurchased)as qty_sold
,round(sum(quantityPurchased * price),2) AS total_spend
from sales_transaction
group by customerid
having qty_sold > 10 and total_spend >1000
order by total_spend desc;

# occasional customers
select customerid, sum(quantitypurchased)as qty_sold,
round(sum(quantityPurchased * price),2) AS total_spend
from sales_transaction
group by customerid
having qty_sold <5 
order by qty_sold asc; 

# loyalty duration

with duration as(
select customerid,
min(transactiondate)as earlier_date,
max(transactiondate) as latest_date
from sales_transaction
group by customerid)
select customerid,
datediff(latest_date,earlier_date)as duration_date,
case when datediff(latest_date,earlier_date) <40 then 'customer_churn'
when datediff(latest_date,earlier_date) <100 then 'customer_buying_frequently' else 'Loyal_customer'
end as Loyalty
from duration
order by duration_date desc;

# repeat purchase patterns
select customerid, productid, count(*) as no_of_transaction
from  sales_transaction
group by customerid	,productid
having no_of_transaction >1
order by customerid ;

SELECT * FROM customer_profiles;
select * from product_inventory;
select * from sales_transaction;



wITH ordered AS (
  SELECT sum(price * quantitypurchased) as total_sales,
         ROW_NUMBER() OVER (ORDER BY sum(price * quantitypurchased)) AS row_num,
         COUNT(*) OVER () AS total_rows
  FROM sales_transaction
)
SELECT 
  AVG(total_sales) AS median_salary
FROM ordered
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));	

WITH salary_rank AS (
    SELECT 
        emp_id,
        sum(price * quantitypurchased) as total_sales,
        PERCENTILE_cont(0.5) WITHIN GROUP (ORDER BY total_sales) 
            OVER () AS median_salary
    FROM sales_transaction
)
SELECT 
    emp_id,
    sum(price * quantitypurchased)
FROM salary_rank
WHERE sum(price * quantitypurchased) > median_salary;
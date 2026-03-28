use e_commerce_case_study;

select * from products;
select * from order_details;
select * from customers;
select * from orders;

-- Data cleaning
select * from products;
select * from order_details;
select count(*) from order_details;
-- detecting null
select * from order_details
where order_id is null or product_id is null or quantity is null or price_per_unit is null;

-- detecting negetive value
select * from order_details
where quantity <= 0 or price_per_unit <=0;

-- detecting outliers
select * from order_details
where price_per_unit < 3000 or price_per_unit > 60000;

select * from customers;
select count(*)from customers;
select * from orders;
describe orders;
select count(*) from orders;

set sql_safe_updates = 0;
update orders
set order_date = str_to_date(order_date,'%Y-%m-%d');

select o.order_id, sum(od. quantity * od.price_per_unit) as amount,
o.total_amount
from orders o
join order_details od 
on o.order_id = od.order_id
group by  o.order_id, o.total_amount
having sum(od. quantity * od.price_per_unit) != o.total_amount;


select * from orders
where total_amount <=0;

-- customer insights -: customer behaviour analysis
-- product analysis -: product performance
-- sale optimization -: identifying trends
-- invetory management -: analyze stock level and its availability

select * from products;
select * from order_details;
select * from customers;
select * from orders;

-- CUSTOMER INSIGHTS -: CUSTOMER BEHAVIOUR ANALYSIS

# customer buying pattern
select o.customer_id, c.name, count(*)as no_of_transaction
from orders o
join customers c
on o.customer_id = c.customer_id
group by o.customer_id, c.name
order by no_of_transaction desc;

# customer high & low spender 
select  customer_id, total_amount
from orders
group by customer_id, total_amount 
order by total_amount desc
limit 10;

# customer recency
with customer_recency as(
select customer_id, sum(total_amount)as totalspend,
min(order_date)as earlier_date,
max(order_date)as latest_date
from orders
group by customer_id)
select customer_id, totalspend,
datediff(latest_date, earlier_date)as recency
from customer_recency
order by recency asc;

# occasional customers
select o.customer_id, od.order_id, sum(od.quantity)as Qty_sold, 
sum(o.total_amount)as total_spend
from orders o
join order_details od 
on o.order_id = od.order_id
group by o.customer_id, od.order_id
order by sum(od.quantity) desc;

# repeaters
select o.customer_id, od.product_id, count(*) as no_of_transaction
from order_details od
join orders o
on o.order_id = od.order_id
group by o.customer_id, od.product_id
having no_of_transaction >1;

# customer purchase with location
select o.customer_id, c.name, c.location,
sum(od.quantity)as qty_purchase,
sum(od.quantity * od.price_per_unit) as amt_spend
from orders o
join order_details od
on o.order_id = od.order_id
join customers c
on o.customer_id = c.customer_id
group by o.customer_id, c.name, c.location
order by sum(quantity) desc;

# top 3 location as number_of_customers
select location, count(customer_id) as number_of_customers
from Customers
group by location
order by count(customer_id) desc
limit 3;

# Engeagement depth analysis
with segment as(
select customer_id, count(order_id)as NumberOfOrders 
from orders
group by customer_id)
select 
NumberOfOrders, count(customer_id) as CustomerCount,
case when NumberOfOrders = 1 then 'one-time buyer'
when NumberOfOrders between 2 and 4 then 'Occasional shoppers'
else 'Regular customer' 
end as customer_segment 
from segment
group by NumberOfOrders
order by NumberOfOrders asc;

# new customer added monthly
with firstpurchase as(
select customer_id ,date_format(min(order_date), '%Y-%m')as FirstPurchaseMonth
from Orders
group by customer_id
)
select FirstPurchaseMonth, count(customer_id)as TotalNewCustomers
from firstpurchase
group by FirstPurchaseMonth
order by FirstPurchaseMonth asc;

select * from products;
select * from order_details;
select * from customers;
select * from orders;


-- PRODUCT ANALYSIS -: PRODUCT PERFORMANCE

# is product selling well or not 
select p.product_id, sum(od.quantity) as sold_qty,
sum(od.quantity * od.price_per_unit) as amount
from order_details od
join products p
on od.product_id = p.product_id
group by product_id
order by sum(od.quantity) asc;

# best performer category and product
select p.product_id,p.category, p.name, sum(od.quantity) as sold_qty,
sum(od.quantity * od.price_per_unit) as amount
from order_details od
join products p
on od.product_id = p.product_id
group by product_id, p.category, p.name
order by sum(od.quantity* od.price_per_unit)  desc;

# product performance by location
select  c.location,
sum(od.quantity)as qty_purchase,
sum(od.quantity * od.price_per_unit) as amt_spend
from orders o
join order_details od
on o.order_id = od.order_id
join customers c
on o.customer_id = c.customer_id
group by  c.location
order by sum(quantity) desc;

# category & location wise performance
select p.category, c.location,
sum(od.quantity)as qty_purchase,
sum(od.quantity * od.price_per_unit) as amt_spend
from orders o
join customers c
on o.customer_id = c.customer_id
join order_details od
on o.order_id = od.order_id
join products p
on od.product_id = p.product_id
group by p.category, c.location
order by sum(od.quantity) desc;

# purchase high value product
select Product_id, avg(quantity)as AvgQuantity, sum(quantity * price_per_unit)as TotalRevenue
from Order_Details
group by Product_id
having AvgQuantity =2
order by TotalRevenue desc;

select * from products;
select * from order_details;
select * from customers;
select * from orders;

# category wise customer reach
select p.category, count(distinct o.customer_id)as unique_customers
from Products p
join Order_Details od
on p.product_id = od.product_id
join Orders o
on od.order_id = o.order_id
group by p.category
order by unique_customers desc ;

# low engagement Product
with low_engage as(
select p.product_id, p.name, count(distinct c.customer_id)as UniqueCustomerCount
from products P
join order_details od
on p.product_id = od.product_id
join orders o 
on od.order_id = o.order_id
join customers c
on o.customer_id = c.customer_id
group by p.product_id, p.name
)
select product_id,name,
UniqueCustomerCount
from low_engage
where UniqueCustomerCount < (SELECT COUNT(*)from customers)* 0.4
order by UniqueCustomerCount;


-- SALE OPTIMIZATION -: IDENTIFYING TRENDS

# daily sales trend
select cast(o.order_date as date ) as odr_date,
sum(od.quantity) as sold_qty, sum(od.quantity* od.price_per_unit) as amount,
count(*) as total_transaction from orders o
join order_details od
on o.order_id = od.order_id
group by odr_date
order by odr_date desc;

# month-on-month growth

with month_on_month as(
select date_format(order_date,'%Y-%m' ) as month, sum(od.quantity* od.price_per_unit) as monthly_sale
from orders o
join order_details od
on o.order_id = od.order_id
group by month
)
select month, monthly_sale,
lag(monthly_sale) over(order by month) as previous_month_sale,
round(((monthly_sale - lag(monthly_sale) over(order by month))/
lag(monthly_sale) over(order by month))*  100,2) as m_on_m_growth_percentage
from month_on_month
order by month asc ;

# location wise sale optimization
select date_format(o.order_date,'%Y-%m')as yearmonth , c.location,
sum(od.quantity)as qty_purchase,
sum(od.quantity * od.price_per_unit) as amt_spend
from orders o
join customers c
on o.customer_id = c.customer_id
join order_details od
on o.order_id = od.order_id
join products p
on od.product_id = p.product_id
group by c.location, date_format(o.order_date,'%Y-%m')
order by yearmonth desc;

# average order value flactuation
with avg_ordervalue as(
select date_format(order_date, '%Y-%m')as Month, 
round(avg(total_amount),2)as AvgOrderValue
from Orders 
group by Month)
select Month, AvgOrderValue,
round(AvgOrderValue - lag(AvgOrderValue) over(order by month),2) as ChangeInValue
from avg_ordervalue
order by month ;

# monthly sale volume
select date_format(order_date, '%Y-%m')as Month,
sum(total_amount)as TotalSales
from Orders
group by Month 
order by TotalSales desc;

select * from products;
select * from order_details;
select * from customers;
select * from orders;


-- INVENTORY MANAGEMENT -:ANALYZE STOCK LEVEL & ITS AVAILABILITY

# category & product wise inventory

select p.category, p.name, sum(od.quantity)
from products p
join order_details od
on p.product_id = od.product_id
group by p.category, p.name
order by sum(od.quantity) desc;

#  year, month & product wise remaining inventory
with remaining_inventory as (
select date_format(o.order_date, '%Y-%m') as yearmonth, p.product_id, p.name,
sum(od.quantity) as total_qty
from orders o
join order_details od
on o.order_id = od.order_id
join products p
on od.product_id = p.product_id
group by date_format(o.order_date, '%Y-%m'), p.product_id, p.name)
select product_id, name, yearmonth, total_qty, 
lag(total_qty) over(partition by product_id order by yearmonth)as previous_month_qty,
(total_qty - lag(total_qty) over(partition by product_id order by yearmonth))as monthly_stock
from remaining_inventory
order by product_id, yearmonth;

#  high demand product and the need for frequent restocking
select product_id, count(order_id)as SalesFrequency
from Order_Details
group by product_id
order by SalesFrequency desc
limit 5;


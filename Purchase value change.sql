/*                          REQUIREMENT
Can I have a view showing customer sales and include a column which shows the difference in value from the previous sale? 
I want to see if new customers who make their first purchase are likely to spend more.
*/
with m_cte as
(
select orderNumber, orderDate, customerNumber,sum(sales_value) as sales_value
from
(
select t1.orderNumber, t1.orderDate, customerNumber, t2.productCode, t2.quantityOrdered, t2.priceEach,
t2.quantityOrdered*t2.priceEach as sales_value
from orders t1 
inner join orderdetails t2
on t1.orderNumber= t2.orderNumber
) s1
group by orderNumber, orderDate, customerNumber
), 

n_cte as
(
select p1.*, customerName, 
row_number() over (partition by customerName order by orderdate) as purchase_number,
lag(sales_value) over (partition by customerName order by orderdate) as previous_sales_value
from m_cte p1
inner join customers p2
on p1.customerNumber= p2.customerNumber
)
select *, sales_value - previous_sales_value as purchase_value_change
from n_cte
where previous_sales_value is not null;
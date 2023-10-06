/*                          REQUIREMENT
Can you please show me a breakdown of sales, but also show their credit limit?
Maybe group the credit limits as I want a high level view to see whether high credit limit people are making higher value of sales which we would
expect.
*/

with sales as 
(
select t1.orderNumber, t3.customerNumber, t2.productCode, t2.quantityOrdered, t2.priceEach, t2.quantityOrdered* t2.priceEach as sales_value,
t3.creditLimit
from orders t1
inner join orderdetails t2
on t1.orderNumber= t2.orderNumber
inner join customers t3
on t1.customerNumber= t3.customernumber
)
select ordernumber, customernumber, 
case 
when creditlimit<75000 then 'a: Less than $75K'
when creditlimit between 75000 and 100000 then 'b: Between $75K and $100K'
when creditlimit between 100000 and 150000 then 'c: Between $100K and $150K'
when creditlimit>150000 then 'd: Above $150K'
else 'Other'
end as creditlimitgroup,
sum(sales_value) as sales_value
from sales
group by ordernumber, customernumber, creditlimitgroup
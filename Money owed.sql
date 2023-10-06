/*
Please can you send me a breakdown of each customer and their sales, but include a money owed column as I would like to see if any customer
have gone over their credit limit.
*/

with sales_cte as
(
select distinct t1.orderNumber, orderDate, t1.customerNumber, t2.productCode, creditlimit, quantityOrdered * priceEach as sales_value
from orders t1
inner join orderdetails t2
on t1.orderNumber= t2.orderNumber
inner join products t3
on t2.productcode= t3.productcode
inner join customers t4
on t1.customerNumber= t4.customernumber
),

running_total_cte as 
(
select *, lead(orderdate) over (partition by customernumber order by orderdate) as next_order_date
from
(
select ordernumber, orderdate, customernumber, creditlimit, sum(sales_value) as sales_value
from sales_cte
group by ordernumber, orderdate, customernumber, creditlimit
)tab
) , 

payments_cte as 
(
select *
from payments
),

main_cte as
(
select s1.*, 
sum(sales_value) over (partition by s1.customerNumber order by orderdate) as running_sales_value, 
sum(amount) over (partition by s1.customerNumber order by orderdate) as running_payments
from running_total_cte s1
left join payments_cte s2
on s1.customernumber= s2.customernumber and s2.paymentdate between s1.orderdate and 
case 
when s1.next_order_date is null then current_date 
else s1.next_order_date
end
), 

a_cte as
(
select *, running_sales_value - running_payments as money_owed,
creditlimit - (running_sales_value - running_payments) as difference
from main_cte
)
select *
from a_cte
where difference <0
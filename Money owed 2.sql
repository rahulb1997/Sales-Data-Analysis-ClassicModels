with sales_cte as
(
select t1.orderNumber, t1.orderDate, t1.customerNumber, productCode, creditlimit, quantityOrdered* priceEach as sales_value
from orders t1
inner join orderdetails t2
on t1.orderNumber= t2.orderNumber
inner join customers t3
on t1.customerNumber= t3.customerNumber
),

running_sales_cte as
(
select ordernumber, orderdate, customernumber, creditlimit, sum(sales_value) as sales_value
from sales_cte
group by ordernumber, orderdate, customernumber, creditlimit
),

next_order_date_cte as
(
select *, lead(orderdate) over (partition by customernumber order by orderdate) as next_order_date 
from  running_sales_cte
),

payments_cte as
(
select customernumber as customer_number, paymentdate, amount
from payments
),

main_cte as
(
select t1.*, 
sum(sales_value) over (partition by t1.customernumber order by orderdate) as running_sales_total,
sum(amount) over (partition by t1.customerNumber order by orderdate) as running_amount
from next_order_date_cte t1
left join payments_cte t2
on t1.customernumber= t2.customer_number and paymentdate between orderdate and 
case
when next_order_date is null then current_date
else next_order_date
end
),

final_cte as
(
select *, running_sales_total- running_amount as amount_owed,
creditlimit - (running_sales_total- running_amount) as difference
from main_cte
)
select * 
from final_cte
where difference <0


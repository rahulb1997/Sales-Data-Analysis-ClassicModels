/*                          REQUIREMENT
Can you show me a view of where the customers of each office are located?
*/

with main_cte as
(
select t1.orderNumber, t1.customerNumber, t2.productCode, t3.productLine, t2.priceEach, t2.quantityOrdered, t2.priceEach *t2.quantityOrdered as sales_value,
t4.city as customer_city, t4.country as customer_country, t6.city as office_city, t6.country as office_country
from orders t1
inner join orderdetails t2
on t1.orderNumber = t2.orderNumber
inner join products t3
on t2.productCode= t3.productCode
inner join customers t4
on t1.customerNumber= t4.customerNumber
inner join employees t5
on t4.salesRepEmployeeNumber= t5.employeeNumber
inner join offices t6
on t5.officeCode= t6.officeCode
)
select ordernumber, productline, customer_city, customer_country, office_city, office_country, sum(sales_value) as sales_value
from main_cte
group by ordernumber, productline, customer_city, customer_country, office_city, office_country;
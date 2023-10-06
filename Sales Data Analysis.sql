/*                          REQUIREMENT
Can you please give me the sales for 2004?
I would like to see a breakdown by product and country. Please include sales value, cost of sales and net profit. 
*/


select t1.orderDate, t1.orderNumber, t2.quantityOrdered, t2.priceEach, t3.productName, t3.productLine, t3.buyPrice, t4.city, t4.country
from orders t1
left join orderdetails t2
on t1.orderNumber= t2.orderNumber
left join products t3
on t2.productCode= t3.productCode
left join customers t4
on t4.customerNumber= t1.customerNumber
where year(orderdate)= 2004;
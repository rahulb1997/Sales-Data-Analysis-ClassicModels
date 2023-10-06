create or replace view sales_data_view_for_power_bi as 

select ord.orderdate, ord.orderNumber, cust.customerName, productLine, cust.city as customer_city, cust.country as customer_country,
ofc.city as office_city, ofc.country as office_country, buyPrice, quantityOrdered, priceEach, 
quantityOrdered * priceEach as sales_value, buyPrice*quantityOrdered as cost_of_sales
from orders ord
inner join orderdetails orddet
on ord.orderNumber= orddet.orderNumber
inner join products prod
on orddet.productCode= prod.productCode
inner join customers cust
on cust.customernumber= ord.customerNumber
inner join employees emp
on emp.employeeNumber= cust.salesRepEmployeeNumber
inner join offices ofc
on ofc.officeCode= emp.officeCode;

select * 
from sales_data_view_for_power_bi
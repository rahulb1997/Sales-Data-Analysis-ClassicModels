/*                          REQUIREMENT
Can you please give me the breakdown of what products are commonly purchased together, and any products rarely purchased together?
*/

with prod_cte as
(
select orderNumber, t1.productCode, productLine
from orderdetails t1
left join products t2
on t1.productCode= t2.productCode
)
select distinct p1.ordernumber, p1.productline as product_one, p2.productline as product_two 
from prod_cte p1
left join prod_cte p2
on p1.ordernumber= p2.ordernumber and p1.productline <> p2.productline;
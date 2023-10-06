/*                          REQUIREMENT
We have discovered that shipping date is delayed due to the whether, and it's possible they will take up to 3 days to arrive. Can you get me a list 
of affected orders?
*/

select *, date_add(shippeddate, interval 3 day) as new_arrival_date,
case
when date_add(shippeddate, interval 3 day) > requiredDate then 1
else 0 
end as late_flag
from orders
where (date_add(shippeddate, interval 3 day) > requiredDate) =1
--Author: Snehal Mundhe 


use AdventureWorks2008R2;

--Lab 3-1

/* Modify the following query to add a column that identifies the
 frequency of repeat customers and contains the following values
 based on the number of orders during 2007:
'No Orders' for count = 0
'One Time' for count = 1
'Regular' for count range of 2-5
'Often' for count range of 6-12
'Very Often' for count greater than 12
 Give the new column an alias to make the report more readable. */


 --Answer:-
SELECT c.CustomerID, c.TerritoryID,
COUNT(o.SalesOrderid) [Total Orders],
case 
	when COUNT(o.SalesOrderid)=0
		Then 'No Orders'
	when COUNT(o.SalesOrderid)=1
		Then 'One Time'
	when COUNT(o.SalesOrderid) between 2 and 5
		Then 'Regular'
	when COUNT(o.SalesOrderid) between 6 and 12
		Then 'Often'
	Else 'Very Often'
End as "Order_Status"
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY c.TerritoryID, c.CustomerID;








--Lab 3-2

/* Modify the following query to add a rank without gaps in the
 ranking based on total orders in the descending order. Also
 partition by territory.*/


--Answer:-
SELECT c.CustomerID, c.TerritoryID,
COUNT(o.SalesOrderid) [Total Orders] ,
DENSE_RANK() OVER
(PARTITION BY c.TerritoryID order by COUNT(o.SalesOrderID) desc) AS Rank_Total_Orders
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY c.TerritoryID, c.CustomerID;








-- Lab 3-3
/* Write a query that returns the highest bonus amount
 ever received by male sales people in Canada. */


 --Answer:-
with final(Bonus, Gender, CountryRegionCode,rank)
as
(
select sp.Bonus, hr.Gender, st.CountryRegionCode,
DENSE_RANK() over
(partition by hr.Gender order by max(bonus) desc) as b_rank
from sales.SalesTerritory st 
left outer join 
Sales.SalesPerson sp 
on (sp.TerritoryID = st.TerritoryID)
left outer join 
HumanResources.Employee hr
on (sp.BusinessEntityID = hr.BusinessEntityID)
where hr.Gender = 'M' and st.CountryRegionCode = 'CA'
group by sp.Bonus, hr.Gender, st.CountryRegionCode
)
select top 1 Bonus from final where rank = 1






--Lab 3-4
/* Write a query to list the most popular product color for each month
 of 2007, considering all products sold in each month. The most
 popular product color had the highest total quantity sold for
 all products in that color.
 Return the most popular product color and the total quantity of
 the sold products in that color for each month in the result set.
 Sort the returned data by month.

 Exclude the products that don't have a specified color. */


--Answer:-
with tab(Color, month_color, Total_Sales, rank_color)
as
(
select pd.Color, datepart(month, oh.OrderDate) as month_color, sum(od.OrderQty) as Total_Sales,
RANK() over(partition by datepart(month, oh.OrderDate) order by sum(od.OrderQty) desc) as rank_color
from Production.Product as pd
left outer join Sales.SalesOrderDetail as od
on(pd.ProductID = od.ProductID)
left outer join Sales.SalesOrderHeader as oh
 on(od.SalesOrderID = oh.SalesOrderID)
where DATEPART(year,oh.OrderDate) ='2007'and pd.Color is not null
group by oh.OrderDate,pd.Color
)
select Color, Total_Sales from tab where rank_color =1
order by month_color









 --3-5
 /* Write a query to retrieve the distinct customer id's and
 account numbers for the customers who have placed an order
 before but have never purchased the product 708. Sort the
 results by the customer id in the ascending order. */


 --Answer:-
select cs.CustomerID, cs.AccountNumber
from Sales.Customer as cs
except
select cs.CustomerID, cs.AccountNumber
from Sales.Customer as cs
inner join
Sales.SalesOrderHeader oh
on(cs.CustomerID =oh.CustomerID)
inner join
Sales.SalesOrderDetail od
on(od.SalesOrderID = oh.SalesOrderID)
where od.ProductID = 708
group by cs.CustomerID, cs.AccountNumber
order by cs.CustomerID





 
 

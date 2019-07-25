--Part A
-- Step 1) Create a new database of the format: LASTNAME_FIRSTNAME_TEST 

Create database "MUNDHE_SNEHAL_TEST"
Go

use "MUNDHE_SNEHAL_TEST"

/*
Step 2) Within this database, experiment creating, altering, and dropping tables and columns. Put in
sample data and play around with other kinds of queries. Write at least 20 SQL statements for this step.
*/

-- Tracking transaction
Begin Tran;

-- Creating Table
create table customers
(
customerID varchar(20),
FirstName char(25),
LastName char(25),
city char(25),
zipcode int
);

-- Inserting values
insert customers values('ABC1234', 'Rajiv', 'Rastogi', 'New Delhi', 110047);
insert customers values('PQR425', 'Divya', 'Shengar', 'Dehradun', 110045);
insert customers values('LMN989','Shubham', 'Agarwal', 'Mumbai', 4526);
insert customers values('CMB789', 'Jyoti', 'Thankur', 'New Delhi', 11089);
insert customers values('PLM252', 'Snehal', 'Mundhe', 'Pune', 22447);

-- Altering Table-1
ALTER TABLE customers alter column customerID varchar(20) NOT NULL;

--Altering Table-2
ALTER TABLE customers ADD CONSTRAINT PK_CUST PRIMARY KEY (customerID);


-- Update Table

update customers set city ='Boston' , zipcode = 02119
where customerID = 'PLM252';

update customers set city = 'LosAngeles' , zipcode = 90001
where customerID = 'LMN989';

-- Alter column width

alter table customers alter column city char(15) not null;
alter table customers alter column FirstName char(15);
alter table customers alter column LastName char(15);

-- Creating a non-clustered Index on zipcode
CREATE NONCLUSTERED INDEX nclu_customers ON customers (zipcode)

-- Query to retrieve indexes
EXECUTE sp_helpindex customers;

-- Saving transaction
save tran P
 
commit;

--Fetching data
select * from customers;

--
select * from customers 
where left(FirstName,1)='S'

--
select * from customers where FirstName not like '%[aeiou]'
--
select FirstName,len(FirstName) as length_FirstName from customers where len(FirstName)=5 union  
select FirstName,len(FirstName) from customers where len(FirstName)=7

--
select city,zipcode from customers where left(zipcode,1)=1 
order by right(zipcode,2) asc

--
select FirstName,city,len(city) as long_city from customers order by len(city)

-- Delete rows
Delete from customers where city = 'Boston';

Delete from customers where city = 'New Delhi' and FirstName ='Rajiv';



--Truncating the customer table
Truncate table customers;

-- Removing indexes
alter table customers drop constraint PK_CUST;
drop index nclu_customers on customers;

-- Rollback to get the saved data
ROLLBACK TRAN P;

-- Drop the table
drop table customers;

-- Fetching all the data
select * from customers;


-- Step 3)and 4) 

create table TargetCustomers(
TargetID varchar(25) constraint Tar_id_pk primary key,
FirstName char(25),
LastName char(25),
Address varchar(25),
City char(20),
State char(10),
ZipCode int
);


create table MailingLists(
MailingListID varchar(25) constraint m_id_pk primary key,
MailingList varchar(25)
);



create table TargetMailingList(
TargetID varchar(25) not null,
MailingListID varchar(25) not null,
primary key clustered(TargetID, MailingListID),
FOREIGN KEY ( TargetID) REFERENCES [TargetCustomers] ( TargetID) ON UPDATE  NO ACTION  ON DELETE  CASCADE,
FOREIGN KEY ( MailingListID ) REFERENCES [MailingLists] ( MailingListID  ) ON UPDATE  NO ACTION  ON DELETE  CASCADE
);




-- Part B
use AdventureWorks2008R2;


select CustomerID,
  stuff((SELECT distinct ', ' + ISNULL(cast(SalesPersonID as varchar(10)),'')
           FROM Sales.SalesOrderHeader p2
           where p2.CustomerID = p1.CustomerID
           FOR XML PATH('')),1,1,'') as 'SalesPersonID' 
from Sales.SalesOrderHeader p1
group by CustomerID
order by CustomerID desc;



--Part C
/* Bill of Materials - Recursive */
/* The following code retrieves the components required for manufacturing
 the "Mountain-500 Black, 48" (Product 992). Use it as the starter code
 for calculating the material cost reduction if the component 815
 is manufactured internally at the level 1 instead of purchasing it
 for use at the level 0. Use the list price of a component as
 the material cost for the component. */

IF OBJECT_ID('tempdb..#BOM') IS NOT NULL
DROP TABLE #BOM;

WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
    -- Top-level compoments
	SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
        b.EndDate, 0 AS ComponentLevel
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 992
          AND b.EndDate IS NULL

    UNION ALL

	-- All other sub-compoments
    SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty,
        bom.EndDate, ComponentLevel + 1
    FROM Production.BillOfMaterials AS bom 
        INNER JOIN Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID
        AND bom.EndDate IS NULL
)
SELECT AssemblyID, ComponentID, Name, (ListPrice * PerAssemblyQty) as Total,PerAssemblyQty, ComponentLevel

into #BOM

FROM Parts AS p
    INNER JOIN Production.Product AS pr
    ON p.ComponentID = pr.ProductID
ORDER BY ComponentLevel, AssemblyID, ComponentID;


-- Fetching records 
select * from #BOM



--Original price of product 992
select sum(Total) as '992_cost_withoutlevel1' from #BOM where AssemblyID = 992

-- After Material cost reduction
SELECT CAST(((SELECT SUM(Total) FROM #BOM WHERE ComponentLevel = 0 AND 
ComponentID NOT IN 
(SELECT distinct AssemblyID FROM #BOM WHERE ComponentLevel = 1 and AssemblyID=815))
+
(SELECT SUM(Total)
FROM #BOM
WHERE ComponentLevel = 1 and AssemblyID= 815)) AS DECIMAL(8,4)) AS Reduced_Cost_Product992;




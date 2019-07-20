/*Part A
Step 1) Create a new database of the format: LASTNAME_FIRSTNAME_TEST*/ 

CREATE DATABASE PATEL_SHUBHAM_TEST;
GO

USE PATEL_SHUBHAM_TEST;

/*Step 2) Within this database, experiment creating, altering, and dropping tables and columns. Put in
sample data and play around with other kinds of queries. Write at least 20 SQL statements for this step.*/

CREATE TABLE dbo.Customers (
	CustomerID varchar(5),
	Name varchar(40)
);

ALTER TABLE dbo.Customers ALTER COLUMN CustomerID varchar(5) NOT NULL;

ALTER TABLE dbo.Customers ADD CONSTRAINT pk2 PRIMARY KEY (CustomerID);

ALTER TABLE dbo.Customers ALTER COLUMN Name varchar(40) NOT NULL;

INSERT dbo.Customers VALUES ('aaa', 'customer1');

INSERT dbo.Customers VALUES ('aab', 'customer2');

INSERT dbo.Customers VALUES ('aba', 'customer3');

INSERT dbo.Customers VALUES ('baa', 'customer4');

INSERT dbo.Customers VALUES ('bab', 'customer5');

INSERT dbo.Customers
 VALUES ('pqr', 'Customer6'),
 ('xyz', 'Customer7')

CREATE TABLE dbo.Orders (
	OrderID int IDENTITY,
	CustomerID varchar(40),
	OrderDate datetime DEFAULT Current_Timestamp
);

ALTER TABLE dbo.Orders ALTER COLUMN OrderID int NOT NULL; 

ALTER TABLE dbo.Orders ALTER COLUMN CustomerID varchar(5) not null; 

ALTER TABLE dbo.Orders ADD CONSTRAINT pk1 PRIMARY KEY (OrderID);

ALTER TABLE dbo.Orders ADD CONSTRAINT fk1 FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID);

INSERT dbo.Orders (CustomerID) VALUES ('aaa');

INSERT dbo.Orders (CustomerID) VALUES ('aba');

INSERT dbo.Orders (CustomerID) VALUES ('baa');

CREATE TABLE dbo.Products
 (
 ProductID int IDENTITY NOT NULL PRIMARY KEY,
 Name varchar(40) NOT NULL,
 UnitPrice money NOT NULL
 ); INSERT dbo.Products
 VALUES ('Phone', 999.99),
 ('Mouse', 88.99)
DROP TABLE dbo.Products;

DROP TABLE dbo.Orders;

DROP TABLE dbo.Customers;

/*Step 3) Eventually, create 3 tables and the corresponding relationships to implement the ERD below in
the database.*/

CREATE TABLE dbo.TargetCustomers (
	TargetID int IDENTITY NOT NULL PRIMARY KEY,
	FirstName varchar(40) NOT NULL,
	LastName varchar(40) NOT NULL,
	Address varchar(40) NOT NULL,
	City varchar(40) NOT NULL,
	State varchar(40) NOT NULL,
	ZipCode int NOT NULL
);

CREATE TABLE dbo.MailingLists (
	MailingListID int IDENTITY NOT NULL PRIMARY KEY,
	MailingList varchar(40) NOT NULL
);

CREATE TABLE dbo.TargetMailingLists (
	TargetID int NOT NULL REFERENCES dbo.TargetCustomers(TargetID),
	MailingListID int NOT NULL REFERENCES dbo.MailingLists(MailingListID),
	CONSTRAINT PKTargetMailingLists PRIMARY KEY CLUSTERED (TargetID, MailingListID)
);


/*Part B

Using the content of AdventureWorks, write a query to retrieve
all unique customers with all salespeople they have dealt with.
If a customer has never worked with a salesperson, make the
'Salesperson ID' column blank instead of displaying NULL.
Sort the returned data by CustomerID in the descending order.
The result should have the following format.
Hint: Use the SalesOrderHeadrer table.*/

USE AdventureWorks2008R2;

SELECT DISTINCT sh.CustomerID,
COALESCE(STUFF((SELECT distinct ', '+RTRIM(CAST(SalesPersonID as char))  
       FROM Sales.SalesOrderHeader
       WHERE CustomerID = sh.CustomerID
       FOR XML PATH('')) , 1, 2, ''), '') AS SalesPersonID
FROM Sales.SalesOrderHeader sh
ORDER BY sh.CustomerID DESC;


/*Part C

Bill of Materials - Recursive 

The following code retrieves the components required for manufacturing
the "Mountain-500 Black, 48" (Product 992). Use it as the starter code
for calculating the material cost reduction if the component 815
is manufactured internally at the level 1 instead of purchasing it
for use at the level 0. Use the list price of a component as
the material cost for the component. */

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
DROP TABLE #TempTable;

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
SELECT AssemblyID, ComponentID, Name, ListPrice, PerAssemblyQty, 
       ListPrice * PerAssemblyQty SubTotal, ComponentLevel

into #TempTable

FROM Parts AS p
    INNER JOIN Production.Product AS pr
    ON p.ComponentID = pr.ProductID
ORDER BY ComponentLevel, AssemblyID, ComponentID;

SELECT CAST((
(SELECT SUM(SubTotal)
FROM #TempTable
WHERE ComponentLevel = 0 AND
      ComponentID NOT IN (SELECT AssemblyID FROM #TempTable WHERE ComponentLevel = 1))
+
(SELECT SUM(SubTotal)
FROM #TempTable
WHERE ComponentLevel = 1)) AS DECIMAL(8,2)) AS TotalCost;
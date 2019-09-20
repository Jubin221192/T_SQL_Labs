use Jubin
go

create table recurs_exmp
(employeid int,
employeename nvarchar(45),
managerid int)


insert into recurs_exmp
values
(1,'John',5)

insert into recurs_exmp
values
(2,'Mark',8)

insert into recurs_exmp
values
(3,'Steve',8)
insert into recurs_exmp
values
(4,'Tom',3)

insert into recurs_exmp
values
(5,'Lara',8)

insert into recurs_exmp
values
(6,'Simon',2)

insert into recurs_exmp
values
(7,'David',4)

insert into recurs_exmp
values
(8,'Ben',NULL)

insert into recurs_exmp
values 
(9,'Stacy',2)

insert into recurs_exmp
values
(10,'Sam',5)

select * from recurs_exmp;

-- Recursive CTE
declare @id int;
set @id = 7;

-- Here we have two parts one is Anchor and other is the recursive member
with EmployeeCTE as
(

	-- Anchor
	select employeid, employeename, managerid
	from recurs_exmp
	where employeid = @id

	union all

	-- Recursive Method
	select emp.employeid, emp.employeename, emp.managerid
	from recurs_exmp as emp
	join EmployeeCTE
	on emp.employeid = EmployeeCTE.managerid
)

select E1.employeename, ISNULL(E2.employeename, 'No Boss') from EmployeeCTE E1
left join
EmployeeCTE E2
on 
E1.managerid = E2.managerid
----

use  AdventureWorks2008R2;

declare @list varchar(max) = '';

declare @custid int = 14328

select @list = @list + ' ' +RTRIM(cast(SalesOrderId as char))
+','
from 
Sales.SalesOrderHeader
where CustomerID = @custid
order by SalesOrderID;

select @custid 'CustomerId' , left(@list, len(@list)-1) as orders;


create table #Person 
(
PersonID int identity(1,1),
SAL decimal(9,0)
)

insert into #Person
values
(5000),
(7000),
(7000)

select * from #Person;



with CTE as
(

select * , DENSE_RANK() over (order by SAL DESC) as frequency
from #Person
)
select frequency, count(frequency) from CTE
having count(frequency) = MAX(count(frequency))

-- SQL statement to create the vertical format

use AdventureWorks2008R2
go

SELECT TerritoryID, SalesPersonID, COUNT(SalesOrderID) AS [Order Count]
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IN (280, 281, 282, 283, 284, 285, 286, 287, 
      288, 289, 290, 291, 292, 293, 294, 295)
GROUP BY TerritoryID, SalesPersonID
ORDER BY TerritoryID, SalesPersonID;

---

/*
SELECT TerritoryID, SalesPersonID, COUNT(SalesOrderID) AS [Order Count]
into [NewTable]
FROM Sales.SalesOrderHeader ;
*/

go
select TerritoryID, [280] , [281],[282],[283], [284], [285], [286], [287], [288], [289], [290], [291], [292], [293], [294], [295]
from
(
select TerritoryID, SalesPersonID
FROM Sales.SalesOrderHeader
) SourceTable
PIVOT
(
count(SalesPersonID)
for SalesPersonID IN
([280], [281],[282],[283], [284], [285], [286], [287], [288], [289], [290], [291], [292], [293], [294], [295])
) as PivotTa
order by PivotTa.TerritoryID


--Unpivoting

select * from Pivot_tabl;
go

select TerritoryID, SalesPersonID, count(SalesPersonID) as OrderCount
from
(
select TerritoryID, 280, 281,282,283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295
from Pivot_tabl
)
UNPIVOT
(
SalesPersonID
for SalesPersonID in(280, 281,282,283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295)
) as unp;


-- Deleting duplicate records

with employeeCTE as
(

select * , row_number() over(partition by id oreder by id) as rownumber
from 
employees
)
delete from employeeCTE where rownumber > 1;



--SQL query to find employees hired in the last n month

Select * , DATEDIFF(MONTH,HireDate,getdate() as diff)
from Employer
where DATEDIFF(MONTH, HireDate, getdate() between 1 and 3
order by HireDate desc;

/*
Same can be done for days and year , just have to replace MONTH keyword in DATEDIFF
*/


---PIVOT table more real life problem

use Jubin
go

Create Table Countries
(
 Country nvarchar(50),
 City nvarchar(50)
)
GO

Insert into Countries values ('USA','New York')
Insert into Countries values ('USA','Houston')
Insert into Countries values ('USA','Dallas')

Insert into Countries values ('India','Hyderabad')
Insert into Countries values ('India','Bangalore')
Insert into Countries values ('India','New Delhi')

Insert into Countries values ('UK','London')
Insert into Countries values ('UK','Birmingham')
Insert into Countries values ('UK','Manchester')


select * from Countries;
go

select Country, [city1], [City2], [City3]
from
(
select Country, City, 'City' + cast((ROW_NUMBER() over(partition by Country order by Country)) as varchar(10)) as colum_seq
from 
Countries
) as sourcetable
PIVOT
(
max(city) for colum_seq in([city1], [City2], [City3])
)PIV



-- Rows that contain only numerical values
Create Table TestTable
(
 ID int identity primary key,
 Value nvarchar(50)
)

Insert into TestTable values ('123')
Insert into TestTable values ('ABC')
Insert into TestTable values ('DEF')
Insert into TestTable values ('901')
Insert into TestTable values ('JKL')

select * from TestTable;

select Value from TestTable where isnumeric(Value)=0;


-- Working with dates
Create Table Employees
(
       ID int identity primary key,
       Name nvarchar(50),
       DateOfBirth DateTime
)

Insert Into Employees Values ('Tom', '2018-11-19 10:36:46.520')
Insert Into Employees Values ('Sara', '2018-11-18 11:36:26.400')
Insert Into Employees Values ('Bob', '2017-12-22 10:40:10.300')
Insert Into Employees Values ('Alex', '2017-12-30 9:30:20.100')
Insert Into Employees Values ('Charlie', '2017-11-25 7:25:14.700')
Insert Into Employees Values ('David', '2017-10-09 8:26:14.800')
Insert Into Employees Values ('Elsa', '2017-10-09 9:40:18.900')
Insert Into Employees Values ('George', '2018-11-15 10:35:17.600')
Insert Into Employees Values ('Mike', '2018-11-16 9:14:17.600')
Insert Into Employees Values ('Nancy', '2018-11-17 11:16:18.600')

select * from Employees;

-- For Date
select Name,DateOfBirth, cast(DateOfBirth as date) as DatePart from Employees
where CAST(DateOfBirth as date) between '2017-11-01' and '2017-12-31';

-- For month and day

select Name, DateOfBirth,cast(DateOfBirth as date) as DatePart  from Employees
where Day(DateOfBirth) = 9 and month(DateOfBirth) =10;

-- birthdays from last 7 days excluding today
select Name, DateOfBirth,cast(DateOfBirth as date) as DatePart  from Employees
where cast(DateOfBirth as date)
between DATEADD(DAY, -7, CAST(getdate() as date))
and CAST(getdate() as date)


-----------------------------------------------------------------------------------
use Jubin
go

-------------------
--STRING FUNCTIONS
-------------------
create table tblEmployee
(
FirstName varchar(40),
LastName varchar(40),
Email varchar(40)
)


insert into tblEmployee
values
('Sam', 'Sony', 'Sam@aaa.com'),
('Ram', 'Barber', 'Ram@aaa.com'),
('Sara', 'Sanosky','Sara@ccc.com'),
('Todd','Gartner','Todd@bbb.com'),
('John','Grover', 'John@aaa.com'),
('Sana','Lenin', 'Sana@ccc.com'),
('James','Bond','James@bbb.com'),
('Rob','Hunter', 'Rob@ccc.com'),
('Steve', 'Wilson','Steve@aaa.com'),
('Pam','Broker','Pam@bbb.com')

select * from tblEmployee;


-- select count(3)

-- Replicate function
select FirstName, LastName, SUBSTRING(Email,1,2) + REPLICATE('*', 5)
+ SUBSTRING(Email, CHARINDEX('@',Email), Len(Email) -charindex('@',Email)+1) as Email
from tblEmployee

-- Space Function
Select FirstName + SPACE(5) + LastName as [Full Name] from tblEmployee;

-- PATINDEX("%Pattern%", Expression)
/* 
Returns the starting position of the first occurence of a pattern 
in a specified expression. It takes two arguments, the pattern 
to be searched and the expression. PATINDEX() is simial to CHARINDEX(),
With CHARINDEX() we can't use wildcards, however this capability is provided 
in PATINDEX()
*/

Select Email, patindex('%@aaa.com', Email) as FirstOccurence from tblEmployee
where patindex('%@aaa.com', Email) >0

-- Replace Function
-- Replace(String_Expression, Pattern, Replacement_Value)

select Email, replace(Email, 'com', 'net') as converted_email from tblEmployee;

-- STUFF Function

-- Stuff() function inserts Replacement_expression, at the start position specified,
-- along with removing the characters specified using length parameter

select FirstName, LastName, Email, STUFF(Email, 2, 3, '******') 
as stuffed_Email from tblEmployee;

-- Left() and Right() function

select Left(Email, 4) as 'Left_Char' , RIGHT(Email, 4) as 'Right_Char'
from tblEmployee;

----------------------------------------------------------------------------------
-- Self Join
---------------------------------------------------------------------------------
--/* 
select * from Employees; 

--
use Jubin
go

create table emp_1
(
id int,
Name varchar(45),
Gender varchar(25),
Salary int
)

insert into emp_1
values
(1, 'Mark','Male', 1000),
(2, 'John','Male', 2000),
(3, 'Pam', 'Female', 3000),
(4, 'Sara', 'Female', 4000),
(5, 'Tom','Female',5000),
(6, 'Mary','Female',6000),
(7,'Ben','Male',7000),
(8,'Jodi','Female',8000),
(9,'Tom','Male',9000),
(10, 'Ron', 'Male', 9500)

select * from emp_1;

-- Lead and Lag 
select Name, Gender, Salary,
Lead(Salary,2,-1) over(partition by Gender order by Salary) as lead,
lag(Salary,1,-1) over(partition by Gender order by Salary) as lag
from emp_1

--Window functions
select Name, Gender, Salary,
AVG(Salary) over(order by Salary rows between unbounded preceding and unbounded following) as Average,
count(Salary) over(order by Salary rows between unbounded preceding and unbounded following) as [count]
from emp_1


select * from emp_1;

--Composite Clustured Index
create clustered Index ix_empl_gen_sal 
on emp_1(Gender desc , Salary asc)

--creating a non-clustured index
create NonClustered Index ix_empl_table
on emp_1(Salary)

---
-- How to find out the nth highest salary

-- (3rd highest salary)
select top 1 Salary from
(
select distinct top 3 Salary
from emp_1
order by Salary Desc)
Result
order by Salary

-- using CTE
with result as 
(
select Salary, DENSE_RANK() over(order by Salary desc) as rank from emp_1
)
select Salary from result
where result.rank = 2


--- Date Questions in interview
select * from Employees;

select Name, DateOfBirth, cast(DateOfBirth as Date) as [DatePart] from Employees
where CAST(DateOfBirth as Date) between '2017-11-01' and '2017-12-31';	

--in a given month and day
select Name, DateOfBirth, cast(DateOfBirth as Date) as [DatePart] from Employees
where Day(DateOfBirth) = 9 and month(DateOfBirth) = 10;	

-- all the persons who are born in the last 7 days excluding today
select Name, DateOfBirth, cast(DateOfBirth as Date) as [DatePart]
from Employees
where CAST(DateOfBirth as date)
between DATEADD(day, -7, cast(getdate() as date))
and DATEADD(day, -1, cast(getdate() as date))
















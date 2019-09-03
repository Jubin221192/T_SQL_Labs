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







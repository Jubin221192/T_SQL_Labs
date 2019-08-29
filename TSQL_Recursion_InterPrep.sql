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

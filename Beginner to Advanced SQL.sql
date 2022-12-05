/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [EmployeeID]
      ,[JobTitle]
      ,[Salary]
  FROM [PortfolioProject].[dbo].[EmployeeSalary]


  /*
select statement, top, distinct, count, As, Max, Min, Avg
*/

--select top 5*
--from EmployeeDemographics


/*
to select unique values in a specific column
select Distinct(EmployeeID)
from EmployeeDemographics

*/
select count(distinct(EmployeeID)) as Number_Of_Distinct_IDs
from EmployeeDemographics

select MAX (salary)
from EmployeeSalary

select AVG (salary)
from EmployeeSalary





/*
where statement, =,<>,<,>, AND, OR, LIKE, NULL, NOT NULL, IN
*/

SELECT *
FROM EmployeeDemographics
--WHERE FirstName = 'Charl'
where FirstName <> 'Charl' -- <> means not equal to



Select *
from EmployeeDemographics
where Age <32 and Gender = 'Male'


Select *
from EmployeeDemographics
where Age <32 or  Gender = 'Female' --or means one of the conditions has to be true


Select *
from EmployeeDemographics
--where LastName like 'T%' --the use of the wildcard % after the letter implies the query should showcase Last names starting S
where LastName like '%s%' -- find s anywhere in the lastname column

Select * 
from EmployeeDemographics
where LastName in ('Haick', 'Tongues') --IN is like a multiple equal to sign


/* Group by, Order by
*/
SELECT FirstName, LastName, Gender, Age
FROM EmployeeDemographics
where Age < 31

order by 3 desc  --order by 4 means output  the first 4 columns


SELECT EmployeeDemographics.EmployeeID, JobTitle, avg(Salary)
FROM [dbo].[EmployeeDemographics]
INNER JOIN [dbo].[EmployeeSalary]
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE FirstName <> 'Charl'
group by JobTitle




--USE BETWEEN, CASES and NULL

Select FirstName, LastName, Age,
case
    when Age> 30 then 'Old'
	when Age between 27 and 30 tHEN 'Young'
	else 'bABY'
end
from [dbo].[EmployeeDemographics]
where Age is not null
order by Age


--using HAVING clause

select JobTitle, COUNT (JobTitle),
CASE
    WHEN JobTitle = 'Acoountant' then Salary+ (Salary*10)
	when JobTitle = 'Data Analyst' then Salary + (Salary*15)
	when JobTitle = 'HR'  then Salary + (Salary * 0001)
	Else Salary + (Salary* 03)
end  as Salary_After_Promotion
from [dbo].[EmployeeDemographics]
join [dbo].[EmployeeSalary]
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
group by JobTitle
having count (JobTitle)> 1 --the HAVING statement is completely independent on the GROUP BY statement so it should follow the GROUP BY




--updating and deleting data
-- INSERT INTO a table is going to create a new row whiles UPDATE is going to alter a pre existing row
--deleting from a table is irreversible

UPDATE EmployeeDemographics
set EmployeeID = 1012
where FirstName = 'Joseph' and LastName = 'Max'

select demo.EmployeeID
from [dbo].[EmployeeDemographics] as demo
where FirstName = 'Joseph' and LastName= 'Max'



--CTE: Common Table Expression
WITH CTE_Employee as
(SELECT FirstName, LastName, Gender, Salary,
 count(gender) over (partition by Gender) as TotalGender,
 AVG(Salary) over (partition by  Gender) as AvgSalary
 from [dbo].[EmployeeDemographics] emp
 join [dbo].[EmployeeSalary] sal
 on emp.EmployeeID = sal.EmployeeID
 where Salary > '45000'
)
select FirstName, AvgSalary
from CTE_Employee




--Using Trim, LTRIM, RTRIM all these get rid of blank spaces

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - seer')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 


--Using Replace
Select LastName, REPLACE(lastName, '- seer', ' ') as LastNameFIxed
from [dbo].[EmployeeErrors]

--using substring
select SUBSTRING(FirstName, 2,3) -- this means, 'select the 2nd letter of the firstname and print the 3 letters that succeeds it'
from EmployeeErrors



--using upper and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, upper(FirstName) as upFirst

from EmployeeErrors

--select
--replace(upFirst, 1,3) firstthreecapital
--from EmployeeErrors




--using stored procedure

CREATE PROCEDURE TEST 
AS
Select *
from EmployeeDemographics

EXEC TEST   --EXEC is the keyword to execute a stored procedure


CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM PortfolioProject..EmployeeDemographics emp
JOIN PortfolioProject..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee
GO;




CREATE PROCEDURE Temp_Employee2 
@JobTitle nvarchar(100)
AS
DROP TABLE IF EXISTS #temp_employee3

Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM PortfolioProject..EmployeeDemographics emp
JOIN PortfolioProject..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
where JobTitle = @JobTitle --- make sure to change this in this script from original above
group by JobTitle

Select * 
From #temp_employee3
GO;


exec Temp_Employee2 @jobtitle = 'Salesman'
exec Temp_Employee2 @jobtitle = 'Accountant'




--SubQuery in Select
select EmployeeID, Salary, (select avg(salary) from EmployeeSalary) as AVG_Salary
from EmployeeSalary


--here's another alternative to to do subqueries
select EmployeeID, Salary, AVG(salary) over () as AVG_Salary
from EmployeeSalary
group by


--subquery in from
select a.EmployeeID, AVG_Salary
from (Select EmployeeID, Salary, AVG(Salary) over () as AVG_Salary
from EmployeeSalary)a




--subquery in where
Select EmployeeID, JobTitle, Salary
from EmployeeSalary
where EmployeeID in (
        select EmployeeID
		from EmployeeDemographics
		where Age >30
)

/*
 Stored Procedures
 Calculation of Salaries of employees
	 You might need the list of active employees from the employee table	 
	 You have the salary divided into HRA, DA, Basic -- Additional Amount	 
	 You also have to pay bonuses/incentives -- Additional Amount
	 You need the leaves
	 You also have LOP's -- Deductible Amount
	 You have to encash their leaves -- Additional Amount
	 They have to pay taxes -- Deductible amount

 SQL Stored Procedures are block or batch(es) of SQL statements 
	That are executed together
	In a specific sequence
	To serve definite business purpose
 which can be reused as and when required and it is accessible to everyone
 who has access to the database

 WHAT ? A stored Proc can do whatever a normal T-SQL statement can do 
	unlike functions which can only perform retrivals of data from tables.
 WHERE ? It is created and becomes a part of the database. It is stored in the 
	schema where it is created. The default schema like other db objects is dbo
	unless we specify another schema where it should be created.
 WHY ? 
 1. Encapsulation : OOPS(Object Oriented Programming concepts). Binds 
	complicated business logic into a single unit without exposing the internal
	content.
 2. Reusuability : SP's are reusuable and can be called multiple number of times
	based on need by users having execute permissions on them.
 3. Maintainabilty : The logic inside the SP can be controlled/maintained
	from a centralized location.
 4. Execution Plan Caching : 
	- Parsing  (20%) - X
	- Compiled (40%) - X
	- Executes (40%)
	 The SP when created is parsed and compiled. So it does not compile everytime it is run.
	 It also caches the best execution plan in the few initial runs.
		a. Execution plan is the path used by SQL optimizer to execute your query
			and return the result.
		b. SQL server creates the execution plan during the query execution
		c. SQL Server takes that little bit of extra time in compiling your code 
			+ creating the execution plan
 */
-- Creation of Stored Procedure
CREATE OR ALTER PROCEDURE csp_GetData
AS
BEGIN
	SELECT *
	FROM Employee
END

--Execute the Stored Procedure
EXEC csp_GetData

--ALTERING SP to add/remove columns
CREATE OR ALTER PROCEDURE dbo.csp_GetData
AS
BEGIN
	SELECT EmployeeId,EmployeeFirstName,EmployeeLastName,Address
	FROM Employee
END

EXEC csp_GetData

--Adding a paramter
CREATE OR ALTER PROCEDURE dbo.csp_GetData
(
	@EmployeeId int = 0 -- Default value to a parameter makes it optional
)
AS
BEGIN
	SELECT emp.EmployeeId,dbo.fn_GetEmployeeFullName(EmployeeFirstName,EmployeeLastName) AS FullName
				,Address,EmployeeDOB
	FROM Employee AS emp
	LEFT JOIN EmployeeDOB AS edob ON edob.EmployeeID = emp.EmployeeId
	WHERE emp.EmployeeId = @EmployeeId OR @EmployeeId = 0 --(FALSE OR TRUE)
END

EXEC csp_GetData @EmployeeId = 5
GO

SELECT * FROM EmployeeDOB

--Adding an additional paramter
CREATE OR ALTER PROCEDURE dbo.csp_GetData
(
	@EmployeeId int = 0 -- Optional Paramter
	,@EmployeeAddress varchar(100) -- Mandatory Parameter
)
/*
Date		ModifiedBy	Comments
15-05-2021	Dinesh		CreatedNew proc
20-05-2021	John		Modifed to add Salary Column
07-12-2022	Dinesh		ExplainedProc
*/
AS
BEGIN
	SELECT EmployeeId,dbo.fn_GetEmployeeFullName(EmployeeFirstName,EmployeeLastName) AS FullName
		,Address
	FROM Employee
	WHERE (EmployeeId = @EmployeeId OR @EmployeeId = 0)
	AND Address = @EmployeeAddress
END

EXEC csp_GetData  @EmployeeAddress = 'India',@EmployeeId = 6

SELECT * FROM Employee

-- To view the definition of the SP
sp_helptext csp_GetData

CREATE OR ALTER PROCEDURE csp_SetData
(
	@EmployeeID INT
	, @EmployeeFirstName varchar(100)
	, @EmployeeLastName varchar(100)
	, @Salary INT
	, @Address varchar(200)
)
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM Employee WHERE EmployeeId = @EmployeeID)	
		INSERT INTO Employee(EmployeeId, EmployeeFirstName,EmployeeLastName,Salary,Address)
		SELECT @EmployeeID, @EmployeeFirstName,@EmployeeLastName,@Salary,@Address
	ELSE
		PRINT 'EmployeeID Already exists!! Please choose a new ID'
END

EXEC csp_SetData 10,'Leo','Smith',2000,'US'

-- Views
	-- View could be looked as an additional layer on top of a table which enables us to protect
		-- sensitive information based on our needs
	-- View is just a query on top of a table
	-- As this is just a layer on top of a table, views do not store any data physically in the server
	-- Instead, the data when requested, the query is executed and the data is returned

-- Create a new view
CREATE OR ALTER VIEW vw_GetEmployeeData
AS
	SELECT * FROM Employee

-- Fetch data from a view
SELECT * FROM vw_GetEmployeeData

-- Restrict to specific columns
CREATE OR ALTER VIEW vw_GetEmployeeData
AS
	SELECT EmployeeID, EmployeeFirstName, EmployeeLastName, Address 
	FROM Employee
	WHERE EmployeeID > 3

SELECT * FROM vw_GetEmployeeData

-- Joining tables to view the data
CREATE OR ALTER VIEW vw_GetEmployeeData
AS
	SELECT emp.EmployeeID, dbo.fn_GetEmployeeFullName(EmployeeFirstName,EmployeeLastName) AS FullName, Address, EmployeeDOB
	FROM Employee AS emp
	LEFT JOIN EmployeeDOB AS edob ON edob.EmployeeID = emp.EmployeeID
	WHERE emp.EmployeeID > 3

SELECT * 
FROM vw_GetEmployeeData
WHERE EmployeeID IN (5,6)

SELECT * FROM vw_GetEmployeeData AS vw
INNER JOIN Employee AS ut ON ut.EmployeeId = vw.EmployeeId

------------------------------------Practice--------------------

CREATE OR ALTER VIEW vw_asianCountry
AS
	SELECT * FROM world_population	WHERE Continent = 'Asia' AND Country_Territory = 'India'

SELECT * FROM vw_asianCountry

CREATE OR ALTER PROCEDURE csp_asianCountry
AS
BEGIN
	SELECT * FROM world_population	WHERE Continent = 'Asia' AND Country_Territory = 'India'
END
EXEC csp_asianCountry


-----------------------------------------------------------------

--SELECT * FROM UniqueTest

-- Orphan View
	-- Views for which the base table/column has changed/altered is called an orphan view
	-- To prevent such scenarios, and to not make our views orphan, we schemabind the view
	-- Schemabinding binds our views to the dependent physical column and tables in the views
	-- Schemabinding is only applicable for columns that are binded in the view

CREATE OR ALTER VIEW vw_GetEmployeeBackupData
WITH SCHEMABINDING
AS
	SELECT EmployeeID, EmployeeFirstName, Address
	FROM dbo.Employee_Backup

SELECT * INTO Employee_Backup
FROM Employee

DROP VIEW vw_GetEmployeeBackupData

SELECT * FROM Employee_Backup

SELECT * FROM vw_GetEmployeeBackupData

ALTER TABLE Employee_Backup
DROP COLUMN EmployeeID

ALTER TABLE Employee_Backup
DROP COLUMN Salary

SELECT * FROM Employee_Backup

DROP TABLE Employee_Backup

SELECT * FROM vw_GetEmployeeBackupData

-- View the definition of a view
CREATE OR ALTER VIEW vw_GetEmployeeDetails
WITH SCHEMABINDING 
AS
	SELECT EmployeeId, EmployeeFirstName, EmployeeLastName FROM dbo.Employee

sp_helptext vw_GetEmployeeDetails

Employee
A - NULLABLE -- Optional
B - NULLABLE -- Optional
C - NOT NULLABLE -- Mandatory
vwEmployee(A,B)
INSERT INTO vwEmployee(A,B)
SELECT Val1,Val2


SELECT * FROM Employee;
SELECT *,
CASE
    WHEN Salary <= 1000 THEN 'C'
    WHEN Salary <= 2000 THEN 'B'
    WHEN Salary <= 3000 THEN 'B+'
    WHEN Salary <= 4000 THEN 'A'
    ELSE 'A+'
END AS Salary_Grd
FROM Employee;

SELECT * FROM Employee;
SELECT * FROM Employee WHERE EmployeeId = 6;


-- DML operations on a view
	-- Views are not only meant to read data
	-- Views does not have physical data stored, so any DML operation is executed on the parent table
	-- We can also perform Insert/Update/Delete on the table using the views
		-- Your view should always have a select from a single table
		-- All the NOT NULL(Mandatory) columns in the base table are to be selected in the view
		
SELECT * FROM vw_GetEmployeeBackupData -- View

SELECT * FROM Employee_Backup -- Base Table
SELECT * FROM vw_GetEmployeeBackupData

-- INSERT
INSERT INTO vw_GetEmployeeBackupData(EmployeeID,EmployeeFirstName, Address)
SELECT 999,'Tom','US'

-- UPDATE
UPDATE vw_GetEmployeeBackupData
SET Address = 'India'
WHERE EmployeeID = 999

-- DELETE
DELETE FROM vw_GetEmployeeBackupData
WHERE EmployeeID = 999

---------------------------------------------------------------------------------------------------------------
-- Science Book
-- 10 chapters --- 400 pages
-- 1 --- 5-25
-- 2 --- 26-56
-- 3 --- 57-120

-- Query Optimization
SELECT * FROM employee WHERE Employee_Id = 6;
-- It will read all 8 records that are available in my table

--== Indexes
-- They are routes to better performance in SQL Server
-- Indexes help in faster access by providing swift access to rows in data tables
-- This is very similar to an index page in a book
-- Microsoft often makes changes to how Indexes are organized and managed

--== Index Structure
-- Indexes are created on table columns
-- They provide faster access to data using the indexed column
-- Indexes are basically B-Tree (Binary Tree) structures which help flatten tables and provide easy access
-- Without an index, a table is called a heap
-- We can create indexes on most data columns
-- We cannot create indexes on LOB (Large Object) data types like image, text, varchar(max), nvarchar(max)
-- Indexes are very effective when created on a unique integer column

-- Heap:
-- folded all clothes

/*
Employee (EmployeeId, Name, Designation, Salary, Department)
1 
2
3
4
5
6
7
8
9
10
....
20

SELECT * FROM Employee WHERE EmployeeID = 10
Without Index - 20 Reads -- Table Scan
With Index - 3 Reads - Index Seek

1                          1-20
2             1-10                    11-20
3      1-5          6-10       11-15         16-20
4   1-2   3-5   6-7   8-10   11-12  13-15  16-17  18-20
                         8 - (Address Pointer)
                         9 - (Address Pointer2)
                         10- (Address Pointer3)
                         8-x, 9-y, 10-z
5  1-*,2-*  3,4,5  6,7  8,9,10
             1-999()
1 2 3 4 5 6 7 8 9 10 ----- 999
*/

--== Types of Indexes
-- Clustered Index
-- The complete data row is stored in the leaf node of the index
-- The indexed column is arranged in ascending or descending order
-- Data is physically sorted in asc or desc in the data file
-- Only one clustered index per table
-- You can include multiple columns in the clustered index, but it's not always recommended
-- Table with a clustered index is called a clustered table

-- Non Clustered Index
-- Leaf nodes do not store the entire data row
-- Instead, they store a pointer/memory address to the row in memory
-- The non-clustered indexed column data is sorted on the fly
-- You can have multiple non-clustered indexes per table
-- SQL Server 2005 supports 249 NCI, SQL Server 2008 supports +999

-- INDEXES ARE A NECESSARY EVIL

CREATE TABLE IndexTest (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Insert values into the table
DECLARE @i INT = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO IndexTest (id, name)
    VALUES (@i, 'Biswombhara' + CAST(@i AS VARCHAR(5)));
    SET @i = @i + 1;
END;

SELECT * 
FROM IndexTest 
WHERE id = 10000;


SELECT * INTO IndexTest_CI FROM IndexTest;

SELECT * FROM IndexTest;
SELECT * FROM IndexTest_CI;

SELECT * 
FROM IndexTest 
WHERE Id = 7748;

-- WITHOUT INDEX
-- Operation  : Table Scan
-- Rows Read  : 10000
-- I/O        : 0.027
-- CPU        : 0.011

-- WITH CLUSTERED INDEX
-- Operation  : Index Seek
-- Rows Read  : 1
-- I/O        : 0.003125
-- CPU        : 0.0001581

CREATE CLUSTERED INDEX IX_IndexTest_CI_Id ON IndexTest_CI(Id);

SELECT * 
FROM IndexTest_CI
WHERE Id = 7748;

--CREATE NONCLUSTERED INDEX IX_NCI_IndexTest_Name ON IndexTest_CI(Name);
--GO

ALTER TABLE IndexTest_CI 
DROP INDEX IX_IndexTest_CI_Id;


-------------------------------------------------------------
-------------------------------------------------------------
-- INDEX PREREQUISITES
-------------------------------------------------------------
-- For heavily updated tables keep the index columns to as few as possible
-- When there are not much updation happening, create as many indexes as required
-- For clustered index, create it on unique int columns to get the best out of it.
-- Creating it on the primary key is the best

-- Whenever we create a primary key on a column in a table, SQL Server
-- by default creates a unique clustered index on that column

-- Whenever you create a UNIQUE constraint on a column, SQL by default creates
-- a non clustered index on that column


-------------------------------------------------------------
-- NORMALIZATION
-------------------------------------------------------------
-- *** Normalization ***
--  Software - 3
--  SW -3
--  SWare -3

--== Normalization
-- Process that helps us in reducing data redundancy in accordance with a series
-- of normal forms

-- Types of Normal Forms
-- First Normal Form (1 NF)
-- Second Normal Form (2 NF)
-- Third Normal Form (3 NF)

-- Drawbacks of data redundancy :
-- Data maintenance becomes tedious
-- Data Inconsistencies pop up
-- Data Manipulation issues
-- Data Accessibility Issues
-- Space crunch


-------------------------------------------------------------
-- FIRST NORMAL FORM (1NF)
-------------------------------------------------------------
-- Every cell (intersection of a row and a column) must have a single data value

-- DE-NORMALIZED TABLE
-- EMPID | NAME   | EMPAGE | DEPT
-- 1     | Dinesh | 27     | Software, Testing, Database
-- 2     | Santosh| 28     | Management, Software, Finance
-- 3     | John   | 25     | SW, Mgmt, Testing
-- 4     | Smith  | 29     | Software, Testing, Finance

INSERT INTO Employee VALUES (1, 'Dinesh', 27, 'Software,Testing, Database');

-- NORMALIZED SETUP
-- First create a Department table (Lookup table)

-- DEPTID | DEPTNAME
-- 1 | Software
-- 2 | Testing
-- 3 | Database
-- 4 | Management
-- 5 | Sales
-- 6 | Finance
-- 7 | Developer

-- EMPID | NAME   | EMPAGE | DEPT
-- 1 | Dinesh | 27 | 1
-- 2 | Santosh| 28 | 4
-- 3 | John   | 25 | 1
-- 4 | Smith  | 29 | 2


-------------------------------------------------------------
-- SECOND NORMAL FORM (2NF)
-------------------------------------------------------------
-- When it is in 1 NF
-- Partial dependencies are removed and placed in a different table

-- DE-NORMALIZED TABLE
-- COURSE_NAME | START_DATE | TITLE
-- SQL  | 02-08-2019 | SQL Development
-- MSBI | 20-08-2019 | MSBI Development
-- AWS  | 01-09-2019 | Amazon Web Services Training
-- SQL  | 02-10-2019 | SQL Development
-- SQL  | 02-11-2019 | SQL Development
-- MSBI | 12-05-2019 | MSBI Development

-- NORMALIZED SETUP
-- First create a new table that holds the Name to Title mapping

-- COURSE_NAME | TITLE
-- SQL | SQL Development
-- MSBI | MSBI Development
-- AWS | Amazon Web Services Training

-- Next, we remove the TITLE column from the DE-NORMALIZED table
-- Hence the structure would look like

-- COURSE_NAME | START_DATE
-- SQL | 02-08-2019
-- MSBI | 20-08-2019
-- AWS | 01-09-2019
-- SQL | 02-10-2019
-- SQL | 02-11-2019


-------------------------------------------------------------
-- THIRD NORMAL FORM (3NF)
-------------------------------------------------------------
-- When the table is in 2 NF
-- Non-Primary key columns shouldn't depend on other non-primary key columns
-- Eg Below : Title is not dependent on EmpID
-- There is no transitive functional dependency
-- Eg Below : DeptName should be replaced with DeptID (Primary Key of a different table)

-- DE-NORMALIZED TABLE
-- EMPID | NAME | COURSENAME | DATEOfCourse | TITLE | DEPTNAME
-- 1 | DINESH | SQL | 02-08-2019 | SQL Development | Developer
-- 2 | SANTOSH| AWS | 01-09-2019 | Amazon Web Services | Management
-- 3 | Suresh | MSBI | 03-10-2020 | Microsoft Business Intelligence Development | Development

-- NORMALIZED SETUP
-- First, we create a table to map the course name and the title

-- COURSENAME | TITLE
-- SQL | SQL Development
-- AWS | Amazon Web Services
-- MSBI | Microsoft Business Intelligence Development

-- Next, we create a DEPT table to remove the other partially dependent columns

-- DEPTID | DEPTNAME
-- 1 | Developer
-- 2 | Management
-- 3 | Development

-- Next, let us separate the Employee data

-- EMPID | NAME | DEPTID
-- 1 | DINESH | 1
-- 2 | SANTOSH| 2

-- Next, let us arrange the parent table (Xref)

-- EMPID | COURSENAME | DATEOfCourse
-- 1 | SQL | 02-08-2019
-- 2 | AWS | 02-08-2019
-- 1 | AWS | 02-08-2019


-------------------------------------------------------------
-- USE DATABASE
-------------------------------------------------------------

USE SQL_Practise;


-------------------------------------------------------------
-- EXAMPLE TABLES
-------------------------------------------------------------
-- Employee: ID, FN, LN, ADDR, DEPT
-- CanteenEmpInfo: ID, Lunch, Dinner, Breakfast
-- 1 | Yes | No | No
---
/*
Transaction
	Set of SQL operations performed in a sequence such that all operations are
		guranteed to succeed or fail as a single unit
TRANSACTION IS ALL OR NONE
	
Transfer an amount worth 100$
	-- 100 $ is deducted from the payer's account
	-- 100 $ is credited to receiver's account

When do we use a transaction : 
	-- When multiple number of rows are inserted, updated or deleted in a sequence
	-- When the changes to one table required the other table data to be
		kept consistent
	-- When we are working on modifying data across two or more concurrent DB's

Transactions is categorized by four properties, often referred to as the ACID property
	ACID (Atomicity, Consistency, Isolation, Durability)
Atomicity : Transactions should be regarded as a single unit, irrespective of the number of steps involved
Consistency : States that the transaction should always leave the DB/Table in a consistent
	state after commit or rollback of the changes
Isolation : Each transaction has its own boundary and do not interfere with other 
	transactions
Durabilty : Any modifcation done on the data after the transaction is finished should 
	be kept permanently in the DB/system

Types of transactions : 
	Autocommit transaction : The statements written as part of this are automatically
		treated as a transaction and is committed or rolled back once the statement is
		executed
	Explicit Transaction : This is where we specify the boundary of the transaction.
		We manually specify the begin and the end of the transaction

ISOLATION LEVELS in transactions
	-- READ COMMITTED - This helps us in reading only committed data from the table
	-- READ UNCOMMITTED - This reads dirty data as well. 
Default Transaction isolation level in SQL server is READ UNCOMMITTED when the SELECT is ran in the same query window
Default Transaction isolation level in SQL server is READ COMMITTED when the SELECT is ran in another query window
*/
BEGIN TRANSACTION -- This is the starting point in a transaction
	--== SQL QUERY GOES HERE
	UPDATE e
	SET e.EmployeeLastName = 'KumarNew' --Kumar
	--SELECT * 
	FROM Employee AS e
	WHERE EmployeeID = 1

	UPDATE e
	SET e.EmployeeDOB = '2000-01-01'--2003-08-27
	--SELECT * 
	FROM EmployeeDOB AS e
	WHERE EmployeeID = 1

ROLLBACK TRANSACTION -- If you want to rollback your transaction
COMMIT TRANSACTION -- If you want to commit your transaction

SELECT * FROM Employee WHERE EmployeeId = 1
SELECT * FROM EmployeeDOB WHERE EmployeeId = 1
-- DIRTY READ: When we read data that is not yet committed to the database is called a dirty read
SELECT @@TRANCOUNT
/*
-- Transaction Isolation Level (Retrival of data)
The default transaction isolation level in SQL Server is Read Uncommitted in the same query window
The default transaction isolation level in SQL Server is Read committed in a different query window
	READ COMMITTED	-- It will only read committed data in the table. If there 
		is a transaction running on the table, the query will wait till the
		transaction is completed.
	READ UNCOMMITTED -- In this level, the uncommitted data from the table 
		is also read. This brings in dirty data from the table.
*/
BEGIN TRANSACTION
	UPDATE emp
	SET EmployeeFirstName = 'David'--Steve
	--SELECT *
	FROM Employee AS emp
	WHERE EmployeeId = 4

COMMIT TRAN
ROLLBACK TRANSACTION
SELECT * FROM Employee

-- Reads only committed data
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
SELECT * FROM Employee

-- Reads dirty data as well
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
SELECT * FROM Employee

SELECT * FROM Employee



-- CTE's (Common table Expressions)
	-- CTE is just a temporary storage for the data to be stored and used only once in their lifetime
	-- Scope of a CTE is only till the first SELECT inside the same batch after the CTE is created

;WITH cteEmployee(FirstName, LastName, Address, DOB)
AS
(
	SELECT e.EmployeeFirstName
		,e.EmployeeLastName
		,e.Address
		,edob.EmployeeDOB
	FROM Employee AS e
	INNER JOIN EmployeeDOB AS edob ON e.EmployeeId = edob.EmployeeID
	WHERE Address = 'India'
)
SELECT * FROM cteEmployee AS x
--INNER JOIN Employee AS Y on x.FirstName = Y.EmployeeFirstName
--CROSS JOIN cteEmployee AS y
--CROSS JOIN cteEmployee AS z
SELECT * FROM cteEmployee AS x

-- Subqueries
-- Get the Employees who earn more than the Avg Salary
SELECT * 
FROM Employee
WHERE Salary > (SELECT AVG(Salary) FROM Employee)

DECLARE @AvgSalary int = (SELECT AVG(Salary) FROM Employee)
SELECT * FROM Employee
WHERE Salary > @AvgSalary

-- Derived Table
SELECT * FROM
(
	SELECT *,
		DENSE_RANK() OVER(ORDER BY Salary DESC) AS RankValue
	FROM Employee
) AS x
WHERE RankValue = 4

;with cte
AS
(
	SELECT *,
		DENSE_RANK() OVER(ORDER BY Salary DESC) AS RankValue
	FROM Employee
)
SELECT * FROM cte
WHERE RankValue = 4


-- JOIN --

CREATE TABLE EmployeeDOB(
	EmployeeID INT,
	EmployeeDOB DATE
)

INSERT INTO EmployeeDOB(EmployeeID, EmployeeDOB)
SELECT 1, GETDATE()-7000 UNION ALL
SELECT 2, GETDATE()-7300 UNION ALL
SELECT 5, GETDATE()-7900 UNION ALL
SELECT 6, GETDATE()-8000 UNION ALL
SELECT 7, GETDATE()-7800 UNION ALL
SELECT 8, GETDATE()-7600 UNION ALL
SELECT 9, GETDATE()-6000 UNION ALL
SELECT 10, GETDATE()-12000 UNION ALL
SELECT 11, GETDATE()-15000

SELECT * FROM EmployeeDOB
SELECT * FROM Employee


-- Innner Join

SELECT emp.*, edob.EmployeeDOB
FROM Employee AS emp
INNER JOIN EmployeeDOB AS edob
ON edob.EmployeeID = emp.EmployeeId

-- Left Join / Left Outer Join

SELECT *
FROM Employee AS emp
LEFT JOIN EmployeeDOB AS edob
ON edob.EmployeeID = emp.EmployeeId
-- WHERE edob.EmployeeDOB IS NULL


-- Right Join / Right Outer Join

SELECT *
FROM Employee AS emp
RIGHT JOIN EmployeeDOB AS edob
ON edob.EmployeeID = emp.EmployeeId
--WHERE edob.EmployeeID IS NULL

------------------- 22nd AUG 2025 ---------------------

--`Full Outer Join

SELECT *
FROM Employee AS emp
FULL OUTER JOIN EmployeeDOB AS edob
ON edob.EmployeeID = emp.EmployeeId
WHERE emp.EmployeeId IS NULL OR edob.EmployeeID IS NULL


-- CROSS JOIN


SELECT * FROM Employee
CROSS JOIN EmployeeDOB

CREATE TABLE Months( MonthNm varchar(10))

INSERT INTO Months( MonthNm )
SELECT 'Jan' UNION ALL
SELECT 'Feb' UNION ALL
SELECT 'Mar' UNION ALL
SELECT 'Apr' UNION ALL
SELECT 'May' UNION ALL
SELECT 'Jun' UNION ALL
SELECT 'Jul' UNION ALL
SELECT 'Aug' UNION ALL
SELECT 'Sep' UNION ALL
SELECT 'Oct' UNION ALL
SELECT 'Nov' UNION ALL
SELECT 'Dec' 

SELECT EmployeeFirstName, EmployeeLastName, MonthNm
FROM Employee
CROSS JOIN Months


-------------> UPDATE & DELETE


-- Creating a Backup table for Employee Table, EmployeeDOB 








SELECT * INTO 
Employee_Backup FROM Employee


SELECT * FROM Employee_Backup

SELECT * INTO 
EmployeeDOB_Backup FROM EmployeeDOB

SELECT * from EmployeeDOB_Backup

SELECT * INTO 
Months_Backup FROM Months

SELECT * FROM Months_Backup


-- Backup only a few rows from the Table
SELECT * 
INTO Employee_Backup_OnlyRows
FROM Employee
WHERE EmployeeID IN (1, 4, 3)

SELECT * FROM Employee_Backup_OnlyRows


-----------------------------------------------------25th August 2025--------------------------------------------------------


-- UPDATE ---

SELECT * FROM Employee

UPDATE Employee
SET EmployeeFirstName = 'Deenesh'
WHERE EmployeeId = 1


-- Revert Back your change using the backup table

UPDATE emp
SET EmployeeFirstName = bak.EmployeeFirstName
FROM Employee AS emp
INNER JOIN Employee_Backup AS bak
ON bak.EmployeeId = emp.EmployeeId


INSERT INTO Employee( EmployeeId, EmployeeFirstName, EmployeeLastName, Salary)
SELECT 9, 'Raman', 'Raghu', 4500


UPDATE Employee
SET Address = 'London'
WHERE EmployeeId = 9


-- DELETE

DELETE emp
FROM Employee AS emp
WHERE EmployeeId = 8

-- -- Revert Back your change using the backup table

INSERT INTO Employee(
	EmployeeId,
	EmployeeFirstName,
	EmployeeLastName,
	Salary,
	Address
)
SELECT EmployeeId,
	   EmployeeFirstName,
	   EmployeeLastName,
	   Salary,
	   Address
FROM Employee_Backup
WHERE EmployeeId = 8
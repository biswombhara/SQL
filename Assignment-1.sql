-- Q1: Create Tables


CREATE DATABASE SQL_ASSIGNMENTS

CREATE TABLE Departments(
	DepartmentID INT PRIMARY KEY,	
	DepartmentName VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Students(
	StudentID INT PRIMARY KEY,	
	Name VARCHAR(50) NOT NULL,
	Age INT CHECK (Age >= 17),
	DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
)

CREATE TABLE Courses(
	CourseID INT PRIMARY KEY,	
	CourseName VARCHAR(50) NOT NULL,
	DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
)

-- Q2: Insert Data


INSERT INTO Departments( DepartmentID ,	DepartmentName ) 
	VALUES 
	( 1, 'Computer Science' ),
	( 2, 'Mechanical' ),
	( 3, 'Electrical' ),
	( 4, 'Civil' ),
	( 5, 'Electronics' )

INSERT INTO Students(StudentID ,Name ,Age ,DepartmentID)
	SELECT 101, 'Tony Stark', 23, 1 UNION ALL
	SELECT 102, 'Steve Rogers', 24, 4 UNION ALL
	SELECT 103, 'Bruce Banner', 22, 2 UNION ALL
	SELECT 104, 'Natasha Romanoff', 18, 5 UNION ALL
	SELECT 105, 'Clint Barton', 20, 3

INSERT INTO Courses(CourseID ,CourseName ,DepartmentID)
	SELECT 01, 'DBMS', 1 UNION ALL
	SELECT 02, 'Thermodynamics', 2 UNION ALL
	SELECT 03, 'Circuits', 3 UNION ALL
	SELECT 04, 'Structures', 4 UNION ALL
	SELECT 05, 'AI', 1


-- Q3: Apply WHERE & Operators

SELECT * FROM Students WHERE Age >= 20

SELECT * FROM Courses WHERE DepartmentID = 1

SELECT * FROM Students WHERE DepartmentID = 5

SELECT * FROM Students WHERE Age BETWEEN 18 AND 22


-- Q4: Joins

SELECT Students.Name, Departments.DepartmentName
FROM Students
INNER JOIN Departments
ON Students.DepartmentID = Departments.DepartmentID

SELECT *
FROM Courses
LEFT JOIN Departments
ON Courses.DepartmentID = Departments.DepartmentID

SELECT Courses.CourseName, Students.Name
FROM Students
RIGHT JOIN Courses
ON Students.DepartmentID = Courses.DepartmentID
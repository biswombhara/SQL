------------------------------- Assignment: Student Management Database ---------------------------------

-- 1. Create a Table
-- Create a table named Students with the following columns and constraints:

	CREATE TABLE Student(
		StudentID INT PRIMARY KEY IDENTITY(1,1),
		FirstName VARCHAR(50) NOT NULL,
		LastName VARCHAR(50) NOT NULL,
		DOB DATE NOT NULL,
		Gender CHAR(1) CHECK (Gender IN ('M','F')),
		Marks INT CHECK (Marks BETWEEN 0 AND 100),
		AdmissionDate DATETIME DEFAULT GETDATE()
	)

-- 2. Insert Records
-- Insert at least 7 records into the table with different names, DOBs, and marks.

	INSERT INTO Student (FirstName, LastName, DOB, Gender, Marks) VALUES
	('Peter', 'Parker', '2001-08-10', 'M', 95),
	('Tony', 'Stark', '1970-05-29', 'M', 99),
	('Natasha', 'Romanoff', '1984-11-22', 'F', 88),
	('Wanda', 'Maximoff', '1989-02-10', 'F', 78),
	('Bruce', 'Wayne', '1975-04-17', 'M', 92),
	('Clark', 'Kent', '1980-06-18', 'M', 85),
	('Diana', 'Prince', '1988-03-01', 'F', 90)


-- 3. Create a Backup Table
-- Create a new table Students_Backup and copy all the records from Students into it.

	SELECT * INTO Student_Backup FROM Student

-- 4. Apply Date Functions
-- Write queries for:
---- Display students’ age in years using DOB.

	 SELECT DATEDIFF(YEAR, DOB, GETDATE()) AS Age FROM Student

---- Extract year and month from AdmissionDate.

	 SELECT YEAR(AdmissionDate) AS YEAR, DATENAME(MONTH, AdmissionDate) AS MONTH FROM Student

---- Display students admitted in the last 30 days.

	 SELECT * FROM Student
	 WHERE AdmissionDate >= AdmissionDate - 30

-- 5. Apply Aggregate Functions
-- Write queries for:
---- 1. Find the highest, lowest, and average marks.

		SELECT MAX(Marks) AS Highest_Mark, MIN(Marks) AS Lowest_Mark, AVG(Marks) AS Average_Mark FROM Student

---- 2. Count the total number of male and female students.

		SELECT Gender, COUNT(*) AS Total
		FROM Student
		GROUP BY Gender

---- 3. Find the number of students born after 2000.

		SELECT * FROM Student
		WHERE DOB >= '2000-01-01'


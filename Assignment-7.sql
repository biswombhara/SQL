/*
Problem Statement:
You have successfully cleared your fourth semester. 
In the fifth semester you will work with clauses and SET operators.
*/

-- Tasks To Be Performed:

-- 1. Arrange the ‘Orders’ dataset in decreasing order of amount.
	
	SELECT * FROM Orders
	ORDER BY Amount DESC

/*
2. Create a table with the name ‘Employee_details1’ consisting of these columns: 
   ‘Emp_id’, ‘Emp_name’, ‘Emp_salary’. 
   Create another table with the name ‘Employee_details2’ consisting of the same columns as the first table.
*/

	CREATE TABLE Employee_details1(
		Emp_id INT,
		Emp_name VARCHAR(30),
		Emp_salary INT
	)

	SELECT * FROM Employee_details1 INTO Employee_details2

--3. Apply the UNION operator on these two tables.

	SELECT * FROM Employee_details1
	UNION
	SELECT * FROM Employee_details2

--4. Apply the INTERSECT operator on these two tables.

	SELECT * FROM Employee_details1
	INTERSECT
	SELECT * FROM Employee_details2

--5. Apply the EXCEPT operator on these two tables.

	SELECT * FROM Employee_details1
	EXCEPT
	SELECT * FROM Employee_details2

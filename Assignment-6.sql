/*
Problem Statement:
You have successfully cleared your third semester. 
In the fourth semester you will work with inbuilt functions 
and user-defined functions.
*/
/*
Tasks To Be Performed:
1. Use the inbuilt functions and find the minimum, maximum, 
   and average amount from the Orders table.
*/
	SELECT MIN(Amount) AS minimum, MAX(Amount) AS maximum, AVG(Amount) AS average FROM Orders
/*
2. Create a user-defined function which will multiply 
   the given number by 10.
*/
	CREATE OR ALTER FUNCTION fn_Multiply(
		@num INT
	)
	RETURNS INT
	AS
	BEGIN
		RETURN(@num*10)
	END

	SELECT dbo.fn_Multiply(2)
/*
3. Use the CASE statement to check if 100 is less than 200, 
   greater than 200, or equal to 200 and print the corresponding value.
*/
	SELECT CASE 
		WHEN 100 < 200 THEN '100 < 200'
		WHEN 100 > 200 THEN '100 > 200'
		WHEN 100 = 200 THEN '100 = 200'
	END AS Result;
/*
4. Using a CASE statement, find the status of the amount. 
   Set the status of the amount as 'High Amount', 'Medium Amount', 
   or 'Low Amount' based upon the condition.
*/
	SELECT * , CASE
	WHEN Amount < 600 THEN 'Low Amount'
	WHEN Amount > 600 AND Amount < 2000 THEN 'Medium Amount'
	ELSE 'High Amount' END AS STATUS
	FROM Orders
/*
5. Create a user-defined function to fetch the amounts 
   greater than the given input.
*/
	CREATE OR ALTER FUNCTION fn_CheckAmounts(
		@amount INT
	)
	RETURNS TABLE
	AS
	RETURN( SELECT Amount FROM Orders WHERE Amount > @amount)

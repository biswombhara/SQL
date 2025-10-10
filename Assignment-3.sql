/*	
	Problem Statement:
	ABC Fashion is a leading retailer with a vast customer base and a team of dedicated sales 
	representatives. They have a Sales Order Processing System that helps manage customer 
	orders and interactions.
*/
CREATE TABLE Salesman(
	SalesmanId INT,
	SalesmanName VARCHAR(15),
	Commission INT,
	City VARCHAR(20),
	Age INT
)

INSERT INTO Salesman (SalesmanId, SalesmanName, Commission, City, Age)
SELECT 101, 'Joe', 50, 'California', 17 UNION ALL
SELECT 102, 'Simon', 75, 'Texas', 25 UNION ALL
SELECT 103, 'Jessie', 105, 'Florida', 35 UNION ALL
SELECT 104, 'Danny', 100, 'Texas', 22 UNION ALL
SELECT 105, 'Lia', 65, 'New Jersy', 30

CREATE TABLE Customer(
	SalesmanId INT,
	CustomerId INT,
	CustomerName VARCHAR(15),
	PurchaseAmount INT
)

INSERT INTO Customer (SalesmanId, CustomerId, CustomerName, PurchaseAmount)
SELECT 101, 2345, 'Andrew', 550 UNION ALL
SELECT 103, 1575, 'Lucky', 4500 UNION ALL
SELECT 104, 2355, 'Andrew', 4000 UNION ALL
SELECT 107, 3747, 'Remona', 2700 UNION ALL
SELECT 110, 4004, 'Julia', 4545

CREATE TABLE Orders(
	OrderId INT,
	CustomerId INT,
	SalesmanId INT,
	OrderDate DATE,
	Amount INT
)

INSERT INTO Orders (OrderId, CustomerId, SalesmanId, OrderDate, Amount)
SELECT 5001, 2345, 101, '2021-07-04', 550 UNION ALL
SELECT 5003, 1234, 105, '2022-02-15', 1500


-- ===========================================================
-- Tasks to be Performed
-- ===========================================================

-- 1. Insert a new record into the Orders table.

	INSERT INTO Orders (OrderId, CustomerId, SalesmanId, OrderDate, Amount)
	SELECT 5006, 4004, 105, '2021-03-14', 5500

-- 2. Add Constraints in Tables:
--    a. Add Primary Key constraint for SalesmanId column in Salesman table.

		ALTER TABLE Salesman
		ALTER COLUMN SalesmanId INT NOT NULL

		ALTER TABLE Salesman
		ADD CONSTRAINT PK_SalesmanId PRIMARY KEY (SalesmanId)
	
--    b. Add Default constraint for City column in Salesman table.

		ALTER TABLE Salesman
		ADD CONSTRAINT DF_City DEFAULT 'Bengaluru' FOR City

--    c. Add Foreign Key constraint for SalesmanId column in Customer table.
			-- Before adding a foreign key, make sure that every SalesmanId in the Customer table exists in the Salesman table
			SELECT DISTINCT c.SalesmanId
			FROM Customer c
			LEFT JOIN Salesman s ON c.SalesmanId = s.SalesmanId
			WHERE s.SalesmanId IS NULL

			-- If we find any value then 
					-- Option A — Add missing Salesmen (Recommended)
					INSERT INTO Salesman (SalesmanId, SalesmanName, Commission, City, Age)
					SELECT DISTINCT c.SalesmanId, 'Unknown', 0, 'Delhi', 0
					FROM Customer c
					LEFT JOIN Salesman s ON c.SalesmanId = s.SalesmanId
					WHERE s.SalesmanId IS NULL

					-- Option B — Remove invalid customers
					DELETE FROM Customer
					WHERE SalesmanId NOT IN (SELECT SalesmanId FROM Salesman)

			ALTER TABLE Customer
			ADD CONSTRAINT FK_SalesmanId
			FOREIGN KEY (SalesmanId) REFERENCES Salesman(SalesmanId)

	-- d. Add NOT NULL constraint for Customer_name column in Customer table.

			ALTER TABLE Customer
			ALTER COLUMN Customer_Name VARCHAR(50) NOT NULL


-- 3. Fetch the data where the Customer’s name is ending with ‘N’
--    and the Purchase Amount value is greater than 500.

	  SELECT * FROM Customer
	  WHERE RIGHT(CustomerName, 1) = 'N' AND PurchaseAmount > 500

-- 4. Using SET operators:
--    a. Retrieve unique SalesmanId values from two tables.
		
		SELECT SalesmanId FROM Salesman
		UNION
		SELECT SalesmanId FROM Customer
		
--    b. Retrieve duplicate SalesmanId values from two tables.
		
		SELECT SalesmanId FROM Salesman
		INTERSECT
		SELECT SalesmanId FROM Customer

-- 5. Display the below columns which have matching data:
--    OrderDate, SalesmanName, CustomerName, Commission, and City
--    where PurchaseAmount is between 500 and 1500.

   	  SELECT O.OrderDate, S.SalesmanName, C.CustomerName, S.Commission, S.City
	  FROM Salesman AS S
	  JOIN Customer AS C
	  ON S.SalesmanId = C.SalesmanId
	  JOIN Orders AS O
	  ON C.CustomerId = O.CustomerId

-- 6. Using RIGHT JOIN, fetch all the results from Salesman and Orders table.

	  SELECT * FROM Salesman
	  RIGHT JOIN Orders
	  ON Salesman.SalesmanId = Orders.SalesmanId

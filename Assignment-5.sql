/*
Problem Statement:
You have successfully cleared the second semester. 
In your third semester you will work with joins and update statements.
*/
-- Tasks To Be Performed:
-- 1. Create an ‘Orders’ table which comprises of these columns: ‘order_id’, ‘order_date’, ‘amount’, ‘customer_id’.

		CREATE TABLE Orders(
			order_id INT,
			order_date DATE,
			amount INT,
			customer_id INT
		)

-- 2. Insert 5 new records into the Orders table.

		INSERT INTO Orders (order_id, order_date, amount, customer_id)
		VALUES
		(1, '2025-10-01', 250, 1),   -- Tony Stark
		(2, '2025-10-02', 450, 2),   -- Steve Rogers
		(3, '2025-10-03', 600, 3),   -- Natasha Romanoff
		(4, '2025-10-04', 1200, 4),  -- Peter Parker
		(5, '2025-10-05', 800, 6);   -- G-One Khan

-- 3. Make an inner join on ‘Customer’ and ‘Orders’ tables on the ‘customer_id’ column.

		SELECT * FROM Customer AS C
		INNER JOIN Orders AS O
		ON C.customer_id = O.customer_id

-- 4. Make left and right joins on ‘Customer’ and ‘Orders’ tables on the ‘customer_id’ column.

-- 4. Make LEFT and RIGHT joins on ‘Customer’ and ‘Orders’ tables on the ‘customer_id’ column

-- LEFT JOIN: Returns all customers and their orders (if any)
		SELECT * FROM Customer C
		LEFT JOIN Orders O
		ON C.customer_id = O.customer_id

		SELECT * FROM Customer C
		RIGHT JOIN Orders O
		ON C.customer_id = O.customer_id

-- 5. Make a full outer join on ‘Customer’ and ‘Orders’ table on the ‘customer_id’ column.

		SELECT * FROM Customer C
		FULL OUTER JOIN Orders O
		ON C.customer_id = O.customer_id

-- 6. Update the ‘Orders’ table and set the amount to 100 where ‘customer_id’ is 3.

		UPDATE Orders
		SET amount = 100
		WHERE customer_id = 3

/*
Problem Statement:
You have successfully cleared the first semester. 
In your second semester you will learn how to create tables, 
work with WHERE clause and basic operators.
*/

-- Tasks To Be Performed:

/*
	1. Create a customer table which comprises of these columns: 
	   'customer_id', 'first_name', 'last_name', 'email', 'address', 
	   'city', 'state', 'zip'
*/

	  CREATE TABLE customer(
		customer_id INT,
		first_name VARCHAR(20),
		last_name VARCHAR(20),
		email VARCHAR(25),
		address VARCHAR(50),
		city VARCHAR(20),
		state VARCHAR(20),
		zip INT
	  )

-- 2. Insert 5 new records into the table

	  INSERT INTO Customer (customer_id, first_name, last_name, email, address, city, state, zip) VALUES
	  (1, 'Tony', 'Stark', 'tony.stark@gmail.com', '108 Genius Ave', 'New York', 'NY', '10001'),
	  (2, 'Steve', 'Rogers', 'steve.rogers@gmail.com', '569 Brooklyn St', 'Brooklyn', 'NY', '11201'),
	  (3, 'Natasha', 'Romanoff', 'natasha.romanoff@gmail.com', '77 Red Room Rd', 'San Francisco', 'CA', '94103'),
	  (4, 'Peter', 'Parker', 'peter.parker@gmail.com', '20 Queens Ln', 'Queens', 'NY', '11101'),
	  (5, 'Bruce', 'Banner', 'bruce.banner@gmail.com', '15 Hulk St', 'Dayton', 'OH', '45402'),
	  (6, 'G-One', 'Khan', 'gone.khan@gmail.com', '101 Hero St', 'San Jose', 'CA', '95112')

-- 3. Select only the 'first_name' and 'last_name' columns from the customer table

	  SELECT first_name, last_name FROM customer

-- 4. Select those records where 'first_name' starts with "G" and city is 'San Jose'

	  SELECT * FROM customer
	  WHERE LEFT(first_name,1) = 'G' AND city = 'San Jose'

-- 5. Select those records where Email has only 'gmail'

	  SELECT * FROM Customer
	  WHERE email LIKE '%@gmail.com'

-- 6. Select those records where the 'last_name' doesn't end with "A"

	  SELECT * FROM customer
	  WHERE RIGHT(last_name,1) <> 'A'
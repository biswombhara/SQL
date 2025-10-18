use August_Batch

/*
	According to given relational design that enlists various users, their roles, user accounts and their statuses
	First of all we have to make the tables which have no Foreign Key constraints then we will make the tables which 
	have Foreign Key constraints
*/

-- CREATING TABLE

CREATE TABLE role(
	id INT PRIMARY KEY,
	role_name VARCHAR(100)
)

CREATE TABLE user_account(
	id INT PRIMARY KEY,
	user_name VARCHAR(100),
	email VARCHAR(100),
	password VARCHAR(100),
	password_salt VARCHAR(100) NOT NULL,
	password_hash_algorithm VARCHAR(100)
)

CREATE TABLE status(
	id INT PRIMARY KEY,
	status_name VARCHAR(100),
	is_user_working BIT
)

CREATE TABLE user_has_role(
	id INT PRIMARY KEY,
	role_start_time DATETIME,
	role_end_time DATETIME NOT NULL,
	user_account_id INT,
	role_id INT,
	FOREIGN KEY(user_account_id) REFERENCES user_account(id),
	FOREIGN KEY(role_id) REFERENCES role(id)
)

CREATE TABLE user_has_status(
	id INT PRIMARY KEY,
	status_start_time DATETIME,
	status_end_time DATETIME NOT NULL,
	user_account_id INT FOREIGN KEY REFERENCES user_account(id),
	status_id INT FOREIGN KEY REFERENCES status(id)
)

-- INSERTING DATA INTO TABLES

INSERT INTO role (id, role_name) VALUES
(1, 'Avenger'),
(2, 'Justice League Member'),
(3, 'S.H.I.E.L.D. Agent'),
(4, 'Friendly Neighborhood Hero'),
(5, 'Amazon Warrior');

INSERT INTO user_account (id, user_name, email, password, password_salt, password_hash_algorithm) VALUES
(1, 'Tony Stark', 'tony.stark@avengers.com', 'ironman123', 'abc123', 'SHA256'),
(2, 'Bruce Wayne', 'bruce.wayne@wayneenterprises.com', 'batman456', 'xyz789', 'SHA512'),
(3, 'Natasha Romanoff', 'natasha.romanoff@shield.gov', 'blackwidow789', 'pqr555', 'MD5'),
(4, 'Peter Parker', 'peter.parker@dailybugle.com', 'spiderman007', 'mno888', 'SHA256'),
(5, 'Diana Prince', 'diana.prince@themyscira.gov', 'wonderwoman321', 'def222', 'SHA512');

INSERT INTO status (id, status_name, is_user_working) VALUES
(1, 'On Mission', 1),
(2, 'Retired', 0),
(3, 'Training', 1),
(4, 'Patrolling', 1),
(5, 'Embassy Duty', 1);

INSERT INTO user_has_role (id, role_start_time, role_end_time, user_account_id, role_id) VALUES
(1, '2012-05-04 09:00:00', '2025-10-19 20:00:00', 1, 1),
(2, '2016-03-25 10:00:00', '2025-10-19 20:00:00', 2, 2),
(3, '2010-04-26 08:00:00', '2025-10-19 20:00:00', 3, 3),
(4, '2018-07-07 09:00:00', '2025-10-19 20:00:00', 4, 4),
(5, '2017-06-02 09:00:00', '2025-10-19 20:00:00', 5, 5);

INSERT INTO user_has_status (id, status_start_time, status_end_time, user_account_id, status_id) VALUES
(1, '2024-06-01 08:00:00', '2025-10-19 20:00:00', 1, 1),
(2, '2023-01-01 00:00:00', '2025-10-19 20:00:00', 2, 2),
(3, '2025-03-15 07:30:00', '2025-10-19 20:00:00', 3, 3),
(4, '2025-05-10 09:00:00', '2025-10-19 20:00:00', 4, 4),
(5, '2025-04-01 10:00:00', '2025-10-19 20:00:00', 5, 5);


-- Deleting TABLE

DELETE FROM user_has_status
DELETE FROM user_has_role
DELETE FROM user_account
DELETE FROM role
DELETE FROM status
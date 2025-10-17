--Star Schema 

-- Dimension Tables
CREATE TABLE Dim_Date (
    DateKey INT PRIMARY KEY,
    Date DATE,
    Month INT,
    Year INT
);

CREATE TABLE Dim_Product (
    ProductKey INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Dim_Customer (
    CustomerKey INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50)
);

-- Fact Table
CREATE TABLE Fact_Sales (
    SaleID INT PRIMARY KEY,
    DateKey INT,
    ProductKey INT,
    CustomerKey INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey),
    FOREIGN KEY (ProductKey) REFERENCES Dim_Product(ProductKey),
    FOREIGN KEY (CustomerKey) REFERENCES Dim_Customer(CustomerKey))


   -- Insert into Dim_Date
INSERT INTO Dim_Date (DateKey, Date, Month, Year) VALUES
(20241001, '2024-10-01', 10, 2024),
(20241002, '2024-10-02', 10, 2024),
(20241003, '2024-10-03', 10, 2024);

select * from Dim_Date
-- Insert into Dim_Product
INSERT INTO Dim_Product (ProductKey, ProductName, Category, Price) VALUES
(1, 'Laptop', 'Electronics', 800.00),
(2, 'Phone', 'Electronics', 500.00),
(3, 'Table', 'Furniture', 150.00);

select * from Dim_Product
-- Insert into Dim_Customer
INSERT INTO Dim_Customer (CustomerKey, CustomerName, City, State) VALUES
(101, 'Alice', 'New York', 'NY'),
(102, 'Bob', 'Los Angeles', 'CA'),
(103, 'Charlie', 'Chicago', 'IL');

select * from Dim_Customer
-- Insert into Fact_Sales
INSERT INTO Fact_Sales (SaleID, DateKey, ProductKey, CustomerKey, Quantity, TotalAmount)
VALUES
(1, 20241001, 1, 101, 2, 1600.00),
(2, 20241002, 2, 102, 1, 500.00),
(3, 20241003, 3, 103, 4, 600.00);

select * from Fact_Sales

select * from Dim_Product

Create database Snowflake
Use Snowflake
-- ** Snoflake ** --
-- Category (normalized from Product)
CREATE TABLE Dim_Category (
    CategoryKey INT PRIMARY KEY,   -- 1  -- Office Supplies
    CategoryName VARCHAR(50)
);

-- Product
CREATE TABLE Dim_Product (
    ProductKey INT PRIMARY KEY,
    ProductName VARCHAR(50),
    CategoryKey INT,
    FOREIGN KEY (CategoryKey) REFERENCES Dim_Category(CategoryKey)  
);

-- Location (normalized from Customer)
CREATE TABLE Dim_Location (
    LocationKey INT PRIMARY KEY,   -- 1 , Bengaluru, KA -- 2, Chennai, TN
    City VARCHAR(50),
    State VARCHAR(50)
);

-- Customer
CREATE TABLE Dim_Customer (
    CustomerKey INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    LocationKey INT,      -- 1
    FOREIGN KEY (LocationKey) REFERENCES Dim_Location(LocationKey)
);

-- Date
CREATE TABLE Dim_Date (
    DateKey INT PRIMARY KEY,
    [Date] DATE
);

-- Fact Table
CREATE TABLE Fact_Sales (
    SaleID INT PRIMARY KEY,
    DateKey INT,
    ProductKey INT,
    CustomerKey INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey),
    FOREIGN KEY (ProductKey) REFERENCES Dim_Product(ProductKey),
    FOREIGN KEY (CustomerKey) REFERENCES Dim_Customer(CustomerKey)
);


-- Category
INSERT INTO Dim_Category VALUES (1, 'Electronics'), (2, 'Furniture');

-- Product
INSERT INTO Dim_Product VALUES 
(101, 'Laptop', 1),
(102, 'Table', 2);

-- Location
INSERT INTO Dim_Location VALUES 
(1, 'New York', 'NY'),
(2, 'Chicago', 'IL');

-- Customer
INSERT INTO Dim_Customer VALUES 
(201, 'Alice', 1),
(202, 'Bob', 2);

-- Date
INSERT INTO Dim_Date VALUES 
(20241001, '2024-10-01'),
(20241002, '2024-10-02');

-- Fact
INSERT INTO Fact_Sales VALUES 
(1, 20241001, 101, 201, 1, 1200.00),
(2, 20241002, 102, 202, 2, 500.00);


select * from Fact_Sales
Dim_Date
           (DateKey)
               |
          Fact_Sales
        (SaleID, Qty, Amount)
          /           \
   Dim_Product       Dim_Customer
   (ProductKey)      (CustomerKey)
        |                 |
   Dim_Category      Dim_Location
   (CategoryKey)     (LocationKey)
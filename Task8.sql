create database saless;
use saless;



-- 1. Create Tables
CREATE TABLE customers (
    customerID INT PRIMARY KEY,
    name VARCHAR(30),
    email VARCHAR(50) UNIQUE
);

CREATE TABLE orders (
    orderID INT PRIMARY KEY,
    customerID INT,
    product VARCHAR(30),
    category VARCHAR(20),
    amount DECIMAL(10,2),
    FOREIGN KEY (customerID) REFERENCES customers(customerID)
);

CREATE TABLE payments (
    paymentID INT PRIMARY KEY,
    orderID INT,
    status VARCHAR(20),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
);

-- 2. Insert Sample Data
INSERT INTO customers VALUES
(1, 'Jinesh', 'jinesh@example.com'),
(2, 'Akansh', 'akansh@example.com'),
(3, 'Vishwesh', 'vishwesh@example.com');

INSERT INTO orders VALUES
(101, 1, 'Laptop', 'Electronics', 60000.00),
(102, 1, 'Mouse', 'Electronics', 1000.00),
(103, 2, 'Keyboard', 'Electronics', 1500.00),
(104, 3, 'Shoes', 'Footwear', 2500.00),
(105, 3, 'Shirt', 'Clothing', 1200.00);

INSERT INTO payments VALUES
(1001, 101, 'Paid'),
(1002, 102, 'Pending'),
(1003, 103, 'Paid'),
(1004, 104, 'Paid'),
(1005, 105, 'Pending');

-- ============================================
-- 3. Stored Procedure
-- ============================================
-- Procedure: Get all orders of a customer by name
DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN customerName VARCHAR(30))
BEGIN
    SELECT c.name, o.product, o.amount, p.status
    FROM customers c
    JOIN orders o ON c.customerID = o.customerID
    JOIN payments p ON o.orderID = p.orderID
    WHERE c.name = customerName;
END //
DELIMITER ;

-- Call example:
-- CALL GetCustomerOrders('Jinesh');

-- ============================================
-- 4. Stored Function
-- ============================================
-- Function: Calculate total spending of a customer
DELIMITER //
CREATE FUNCTION GetTotalSpent(custID INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(amount) INTO total
    FROM orders
    WHERE customerID = custID;
    RETURN IFNULL(total,0);
END //
DELIMITER ;

-- Call example:
-- SELECT GetTotalSpent(1) AS TotalSpentByJinesh;



-- Get all orders for Jinesh
CALL GetCustomerOrders('Jinesh');

-- Get all orders for Akansh
CALL GetCustomerOrders('Akansh');

-- Check how much Jinesh has spent in total
SELECT GetTotalSpent(1) AS TotalSpentByJinesh;

-- Check how much Vishwesh has spent in total
SELECT GetTotalSpent(3) AS TotalSpentByVishwesh;

-- Show each customer with their total spending
SELECT c.name, GetTotalSpent(c.customerID) AS total_spent
FROM customers c;
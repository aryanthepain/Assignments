-- Create required tables
CREATE TABLE
    Customers (
        CustomerID INT PRIMARY KEY NOT NULL,
        FirstName VARCHAR(50) NOT NULL,
        LastName VARCHAR(50) NOT NULL,
        Email VARCHAR(100) NOT NULL,
        Phone VARCHAR(15) NOT NULL,
        City VARCHAR(50) NOT NULL,
        CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE
    Products (
        ProductID INT PRIMARY KEY NOT NULL,
        ProductName VARCHAR(100) NOT NULL,
        Category VARCHAR(50) NOT NULL,
        Price FLOAT (10, 2) NOT NULL,
        StockQuantity INT NOT NULL DEFAULT 1
    );

CREATE TABLE
    Orders (
        OrderID INT PRIMARY KEY NOT NULL,
        CustomerID INT NOT NULL,
        OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        TotalAmount FLOAT (10, 2),
        FOREIGN KEY (CustomerID) REFERENCES customers (CustomerID) ON DELETE CASCADE
    );

CREATE TABLE
    OrderDetails (
        OrderDetailID INT PRIMARY KEY NOT NULL,
        OrderID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity INT NOT NULL,
        Price FLOAT (10, 2) NOT NULL,
        FOREIGN KEY (OrderID) REFERENCES orders (OrderID) ON DELETE CASCADE,
        FOREIGN KEY (ProductID) REFERENCES products (ProductID) ON DELETE CASCADE
    );
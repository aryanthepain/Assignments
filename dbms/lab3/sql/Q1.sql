INSERT INTO
    Customers (
        CustomerID,
        FirstName,
        LastName,
        Email,
        Phone,
        City
    )
VALUES
    (
        1,
        'John',
        'Doe',
        'john.doe@example.com',
        '1234567890',
        'New York'
    ),
    (
        2,
        'Jane',
        'Smith',
        'jane.smith@example.com',
        '0987654321',
        'Los Angeles'
    ),
    (
        3,
        'Alice',
        'Johnson',
        'alice.johnson@example.com',
        '5555555555',
        'Chicago'
    ),
    (
        4,
        'Bob',
        'Brown',
        'bob.brown@example.com',
        '4444444444',
        'Houston'
    ),
    (
        5,
        'Charlie',
        'Davis',
        'charlie.davis@example.com',
        '3333333333',
        'Phoenix'
    );

INSERT INTO
    Products (
        ProductID,
        ProductName,
        Category,
        Price,
        StockQuantity
    )
VALUES
    (1, 'Laptop', 'Electronics', 999.99, 10),
    (2, 'Smartphone', 'Electronics', 499.99, 20),
    (3, 'Tablet', 'Electronics', 299.99, 15),
    (4, 'Headphones', 'Accessories', 199.99, 30),
    (5, 'Smartwatch', 'Accessories', 249.99, 25);

INSERT INTO
    Orders (OrderID, CustomerID, TotalAmount)
VALUES
    (1, 1, 999.99),
    (2, 2, 499.99),
    (3, 3, 299.99),
    (4, 4, 199.99),
    (5, 5, 249.99),
    (6, 2, 199.99);

INSERT INTO
    OrderDetails (
        OrderDetailID,
        OrderID,
        ProductID,
        Quantity,
        Price
    )
VALUES
    (1, 1, 1, 1, 999.99),
    (2, 2, 2, 1, 499.99),
    (3, 3, 3, 1, 299.99),
    (4, 4, 4, 2, 399.98),
    (5, 5, 4, 1, 199.99);
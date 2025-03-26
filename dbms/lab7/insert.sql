-- 1. Insert Sample Customers
INSERT INTO
    Customer (Name, Email, PhoneNumber, Address, Password)
VALUES
    (
        'John Doe',
        'john.doe@example.com',
        '9876543210',
        'IITG Hostel 5',
        'password123'
    ),
    (
        'Alice Smith',
        'alice.smith@example.com',
        '9876543211',
        'IITG Hostel 2',
        'alice123'
    ),
    (
        'Bob Brown',
        'bob.brown@example.com',
        '9876543212',
        'IITG Hostel 3',
        'bobpass'
    );

-- 2. Insert Sample Restaurants
INSERT INTO
    Restaurant (Name, Address, PhoneNumber, Email)
VALUES
    (
        'Tasty Bites',
        'IITG Market Area',
        '9999999991',
        'tastybites@example.com'
    ),
    (
        'Campus Cafe',
        'IITG Academic Block',
        '9999999992',
        'campuscafe@example.com'
    );

-- 3. Insert Sample Food Items
INSERT INTO
    Food_Item (RestaurantID, Name, Price, QuantityAvailable)
VALUES
    (1, 'Veg Burger', 120.00, 50),
    (1, 'Chicken Pizza', 250.00, 30),
    (1, 'Cold Coffee', 80.00, 100),
    (2, 'Grilled Sandwich', 90.00, 40),
    (2, 'Hot Chocolate', 70.00, 80);

-- 4. Insert Sample Drivers
INSERT INTO
    Driver (Name, PhoneNumber, VehicleDetails)
VALUES
    ('David Miller', '8888888881', 'Bike - AS01AB1234'),
    (
        'Emily Johnson',
        '8888888882',
        'Scooter - AS02BC5678'
    );

-- 5. Insert Sample Orders
INSERT INTO
    Orders (
        CustomerID,
        RestaurantID,
        OrderStatus,
        TotalAmount,
        DriverID
    )
VALUES
    (1, 1, 'Pending', 450.00, NULL);

INSERT INTO
    Orders (
        CustomerID,
        RestaurantID,
        OrderStatus,
        TotalAmount,
        DriverID
    )
VALUES
    (2, 2, 'Pending', 160.00, NULL);

-- 6. Insert Sample Order Items
INSERT INTO
    Order_Items (OrderID, FoodID, Quantity, Price)
VALUES
    (1, 1, 2, 240.00),
    (1, 2, 1, 250.00);

INSERT INTO
    Order_Items (OrderID, FoodID, Quantity, Price)
VALUES
    (2, 4, 1, 90.00),
    (2, 5, 1, 70.00);

-- 7. Insert Sample Discounts
INSERT INTO
    Discount (
        DiscountCode,
        Description,
        DiscountPercentage,
        ValidFrom,
        ValidUntil
    )
VALUES
    (
        'SAVE10',
        'Get 10% off your order',
        10.00,
        '2025-01-01',
        '2025-12-31'
    ),
    (
        'IITG50',
        'Special 50% off for IITG students',
        50.00,
        '2025-01-01',
        '2025-12-31'
    );
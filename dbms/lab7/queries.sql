-- 1. Customer Registration (Insert a New Customer)
INSERT INTO
    Customer (Name, Email, PhoneNumber, Address, Password)
VALUES
    (
        'Charlie Green',
        'charlie.green@example.com',
        '9876543213',
        'IITG Hostel Umiam',
        'charliepass'
    );

-- 2. Restaurant Registration (Insert a New Restaurant)
INSERT INTO
    Restaurant (Name, Address, PhoneNumber, Email)
VALUES
    (
        'Midnight Cravings',
        'IITG',
        '9999999993',
        'midnight@example.com'
    );

-- 3. Food Inventory (Add Food Items)
INSERT INTO
    Food_Item (RestaurantID, Name, Price, QuantityAvailable)
VALUES
    (3, 'Paneer Butter Masala', 150.00, 25),
    (3, 'Butter Naan', 30.00, 100);

-- 4. Ordering System (Place an Order and Add Items)
-- Place a new order for CustomerID=1 from RestaurantID=2
INSERT INTO
    Orders (
        CustomerID,
        RestaurantID,
        OrderStatus,
        TotalAmount,
        DriverID
    )
VALUES
    (1, 2, 'Pending', 120.00, NULL);

-- Add items to the newly created order (assume it's OrderID=3)
INSERT INTO
    Order_Items (OrderID, FoodID, Quantity, Price)
VALUES
    (3, 4, 1, 90.00),
    (3, 5, 1, 70.00);

-- Update total amount if needed (example for combined price)
UPDATE Orders
SET
    TotalAmount = 160.00
WHERE
    OrderID = 3;

-- 5. Feedback and Rating System for Restaurant, Driver, and Food
-- Feedback for Restaurant (RestaurantID=1)
INSERT INTO
    Feedback (CustomerID, RestaurantID, Rating, Comments)
VALUES
    (
        2,
        1,
        4.50,
        'Tasty Bites: Great taste and quick service!'
    );

-- Feedback for Driver (DriverID=1)
INSERT INTO
    Feedback (CustomerID, DriverID, Rating, Comments)
VALUES
    (
        1,
        1,
        5.00,
        'Driver was polite and delivered on time.'
    );

-- Feedback for Food Item (FoodID=2)
INSERT INTO
    Feedback (CustomerID, FoodID, Rating, Comments)
VALUES
    (
        3,
        2,
        4.00,
        'Chicken Pizza was delicious but a bit cold.'
    );

-- 6. Driver Registration, Assignment of Delivery
-- Register a new driver
INSERT INTO
    Driver (Name, PhoneNumber, VehicleDetails)
VALUES
    ('Frank Wilson', '8888888883', 'Car - AS03CD9999');

-- Assign a driver to an existing order (OrderID=1)
UPDATE Orders
SET
    DriverID = 2, -- Emily Johnson
    OrderStatus = 'Out for Delivery'
WHERE
    OrderID = 1;

-- 7. OTP System for Delivery of Items
-- Insert OTP for an order (OrderID=1, assigned to DriverID=2)
INSERT INTO
    Delivery (OrderID, DriverID, OTP, DeliveryStatus)
VALUES
    (1, 2, '123456', 'Out for Delivery');

-- Verify OTP at Delivery (static check example for OTP='123456')
SELECT
    CASE
        WHEN OTP = '123456' THEN 'Valid'
        ELSE 'Invalid'
    END AS OTP_Status
FROM
    Delivery
WHERE
    OrderID = 1;

-- Mark order as Delivered if OTP is valid
UPDATE Delivery
SET
    DeliveryStatus = 'Delivered'
WHERE
    OrderID = 1
    AND OTP = '123456';

UPDATE Orders
SET
    OrderStatus = 'Delivered'
WHERE
    OrderID = 1;

-- 8. Discount System
-- Apply a discount code (SAVE10) to an existing order (OrderID=2)
-- 1) Check if discount code is valid (simple check)
SELECT
    DiscountCode,
    DiscountPercentage
FROM
    Discount
WHERE
    DiscountCode = 'SAVE10'
    AND now () BETWEEN ValidFrom AND ValidUntil;

-- 2) Update the order with the discount code and recalculate total amount
UPDATE Orders
SET
    DiscountCode = 'SAVE10',
    TotalAmount = TotalAmount * (1 - (10 / 100))
WHERE
    OrderID = 2;
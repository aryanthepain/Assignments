-- Customers Table
CREATE TABLE
    Customer (
        CustomerID INT AUTO_INCREMENT PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Email VARCHAR(100) UNIQUE NOT NULL,
        PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
        Address TEXT NOT NULL,
        Password VARCHAR(255) NOT NULL
    );

-- Restaurants Table
CREATE TABLE
    Restaurant (
        RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Address TEXT NOT NULL,
        PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
        Email VARCHAR(100) UNIQUE NOT NULL,
        Rating DECIMAL(3, 2) DEFAULT 0.0
    );

-- Food Items Table
CREATE TABLE
    Food_Item (
        FoodID INT AUTO_INCREMENT PRIMARY KEY,
        RestaurantID INT,
        Name VARCHAR(100) NOT NULL,
        Price DECIMAL(10, 2) NOT NULL,
        QuantityAvailable INT NOT NULL,
        FOREIGN KEY (RestaurantID) REFERENCES Restaurant (RestaurantID) ON DELETE CASCADE
    );

-- Drivers Table
CREATE TABLE
    Driver (
        DriverID INT AUTO_INCREMENT PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
        VehicleDetails VARCHAR(100) NOT NULL,
        Rating DECIMAL(3, 2) DEFAULT 0.0
    );

-- Orders Table
CREATE TABLE
    Orders (
        OrderID INT AUTO_INCREMENT PRIMARY KEY,
        CustomerID INT,
        RestaurantID INT,
        OrderStatus VARCHAR(50) DEFAULT 'Pending',
        DiscountCode VARCHAR(50),
        TotalAmount DECIMAL(10, 2) NOT NULL,
        OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        DriverID INT DEFAULT NULL,
        FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON DELETE CASCADE,
        FOREIGN KEY (RestaurantID) REFERENCES Restaurant (RestaurantID) ON DELETE CASCADE,
        FOREIGN KEY (DriverID) REFERENCES Driver (DriverID) ON DELETE SET NULL
    );

-- Order Items Table
CREATE TABLE
    Order_Items (
        OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
        OrderID INT,
        FoodID INT,
        Quantity INT NOT NULL,
        Price DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) ON DELETE CASCADE,
        FOREIGN KEY (FoodID) REFERENCES Food_Item (FoodID) ON DELETE CASCADE
    );

-- Delivery Table (OTP System)
CREATE TABLE
    Delivery (
        DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
        OrderID INT UNIQUE,
        DriverID INT,
        OTP VARCHAR(6) NOT NULL,
        DeliveryStatus VARCHAR(50) DEFAULT 'Pending',
        FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) ON DELETE CASCADE,
        FOREIGN KEY (DriverID) REFERENCES Driver (DriverID) ON DELETE SET NULL
    );

-- Feedback Table
CREATE TABLE
    Feedback (
        FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
        CustomerID INT,
        FoodID INT NULL,
        RestaurantID INT NULL,
        DriverID INT NULL,
        Rating DECIMAL(3, 2) NOT NULL,
        Comments TEXT NOT NULL,
        FeedbackDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) ON DELETE CASCADE,
        FOREIGN KEY (FoodID) REFERENCES Food_Item (FoodID) ON DELETE SET NULL,
        FOREIGN KEY (RestaurantID) REFERENCES Restaurant (RestaurantID) ON DELETE SET NULL,
        FOREIGN KEY (DriverID) REFERENCES Driver (DriverID) ON DELETE SET NULL
    );

-- Discount Table
CREATE TABLE
    Discount (
        DiscountCode VARCHAR(50) PRIMARY KEY,
        Description TEXT,
        DiscountPercentage DECIMAL(5, 2),
        ValidFrom DATE,
        ValidUntil DATE
    );
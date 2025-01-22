CREATE VIEW
    CustomerOrderSummary AS
SELECT
    `CustomerID`,
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalAmount
FROM
    `orders`
GROUP BY
    CustomerID;

DELIMITER $$ CREATE PROCEDURE GetCustomerOrders (IN customer_id INT) BEGIN
SELECT
    o.OrderID,
    od.ProductID
FROM
    orders o
    JOIN orderdetails od ON o.OrderID = od.OrderID
WHERE
    o.CustomerID = customer_id;

END $$ DELIMITER;
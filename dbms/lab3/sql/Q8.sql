SELECT
    `CustomerID`,
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalAmount
FROM
    `orders`
GROUP BY
    CustomerID;

SELECT
    OrderID,
    ProductID
FROM
    `orderdetails`
WHERE
    OrderID IN (
        SELECT
            OrderID
        FROM
            orders
        WHERE
            customerid = customerid
    );
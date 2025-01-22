-- A
SELECT
    *
FROM
    `products`
ORDER BY
    Price DESC
LIMIT
    3;

-- B
SELECT
    *
FROM
    `customers`
WHERE
    `CustomerID` NOT IN (
        SELECT
            CustomerID
        FROM
            orders
    );

-- C
SELECT
    ProductID,
    SUM(Quantity) AS Quantity
FROM
    orderdetails
GROUP BY
    ProductID
ORDER BY
    Quantity DESC;
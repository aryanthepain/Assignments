SELECT
    CustomerID
FROM
    `orders`
GROUP BY
    CustomerID
HAVING
    SUM(TotalAmount) > 500;

SELECT
    *
FROM
    `products`
WHERE
    `ProductID` NOT IN (
        SELECT
            ProductID
        FROM
            orderdetails
    );
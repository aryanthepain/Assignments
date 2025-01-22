SELECT
    *
FROM
    customers,
    orders
WHERE
    customers.CustomerID = orders.CustomerID;

SELECT
    ProductName
FROM
    products p,
    orderdetails o
WHERE
    p.ProductID = o.ProductID
ORDER BY
    o.OrderID
SELECT
    ProductName,
    OrderID
FROM
    products p,
    orderdetails o
WHERE
    p.ProductID = o.ProductID
ORDER BY
    o.OrderID;
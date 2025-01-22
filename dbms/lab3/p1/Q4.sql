SELECT
    SUM(TotalAmount)
FROM
    `orders`;

SELECT
    COUNT(ProductID)
FROM
    `products`
WHERE
    StockQuantity = 0;
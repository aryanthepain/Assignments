SELECT
    *
FROM
    `customers`
WHERE
    `City` LIKE "New York";

SELECT
    *
FROM
    `products`
WHERE
    `Category` LIKE "Electronics";

SELECT
    *
FROM
    `orders`
WHERE
    `OrderDate` > (now () - INTERVAL 30 DAY);
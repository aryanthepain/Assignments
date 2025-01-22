-- to update specific product using variables
UPDATE `products`
SET
    `StockQuantity` = `StockQuantity` - Quantity
WHERE
    ProductID = ProductID;

-- to update all products
UPDATE `products`,
orderdetails
SET
    products.StockQuantity = products.StockQuantity - orderdetails.Quantity
WHERE
    products.ProductID = orderdetails.ProductID;

DELETE FROM `orders`
WHERE
    `OrderDate` < (now () - INTERVAL 1 YEAR);
-- 1) Sum of Sales by Year

SELECT YEAR(b.orderDate) AS Year,SUM(a.quantityOrdered*a.priceEach) AS Sum_Sales
FROM orderdetails a
LEFT JOIN orders b
ON a.orderNumber = b.orderNumber
GROUP BY YEAR(b.orderDate);

-- 2) Top 5 Sum of Sales by Customers

SELECT c.customerName, SUM(a.quantityOrdered*a.priceEach) AS Sum_Sales
FROM orderdetails a
LEFT JOIN orders b ON a.orderNumber = b.orderNumber
LEFT JOIN customers  c ON b.customerNumber=c.customerNumber
GROUP BY c.customerNumber
ORDER BY Sum_Sales DESC
LIMIT 5;

-- 3) Top 5 customers with most orders

SELECT c.customerName, c.country, COUNT(b.orderNumber) AS OrderCount
FROM orders b 
INNER JOIN customers  c ON b.customerNumber = c.customerNumber
GROUP BY c.customerNumber
ORDER BY OrderCount DESC
LIMIT 5;

-- 4) Top 5 most orders by a country

SELECT country, COUNT(country) AS CountryCount
FROM customers
GROUP BY country
ORDER BY CountryCount DESC
LIMIT 5;

-- 5) Number of distinct products by ProductLine 

SELECT productLine, COUNT(productLine) AS productLineCount
FROM products
GROUP BY productLine
ORDER BY productLineCount DESC;

-- 6) Average Cost Price per productLine

SELECT productLine, ROUND(AVG(buyPrice),2) AS AverageCost
FROM products
GROUP BY productLine
ORDER BY AverageCost DESC;

-- 7) Profit by Year

SELECT YEAR(b.orderDate) AS Year, SUM(a.quantityOrdered*(a.priceEach-buyPrice)) AS Profit
FROM orderdetails a
LEFT JOIN orders b ON a.orderNumber = b.orderNumber
LEFT JOIN products  c ON a.productCode = c.productCode
GROUP BY Year(b.orderDate);

-- 8) Profit contribution by customer

SELECT d.customerName, SUM(a.quantityOrdered*(a.priceEach-buyPrice)) AS Profit
FROM orderdetails a
LEFT JOIN orders b ON a.orderNumber = b.orderNumber
LEFT JOIN products  c ON a.productCode = c.productCode
LEFT JOIN customers  d ON b.customerNumber=d.customerNumber
GROUP BY b.customerNumber
ORDER BY Profit DESC
LIMIT 5;

-- 9) Profit margin by year

SELECT YEAR(b.orderDate) AS Year, ROUND(100*SUM(a.quantityOrdered*(a.priceEach-buyPrice))/SUM(a.quantityOrdered*a.priceEach),2) AS Percent_ProfitMargin
FROM orderdetails a
LEFT JOIN orders b ON a.orderNumber = b.orderNumber
LEFT JOIN products  c ON a.productCode = c.productCode
GROUP BY Year(b.orderDate);

-- 10) Profit Margin by quarter

SELECT QUARTER(b.orderDate) AS Quarter, ROUND(100*SUM(a.quantityOrdered*(a.priceEach-buyPrice))/SUM(a.quantityOrdered*a.priceEach),2) AS Percent_ProfitMargin
FROM orderdetails a
LEFT JOIN orders b ON a.orderNumber = b.orderNumber
LEFT JOIN products  c ON a.productCode = c.productCode
GROUP BY QUARTER(b.orderDate);

-- 11) Order Number with maximum ordered  products

SELECT orderNumber, COUNT(productCode) AS ProductCount, SUM(quantityOrdered) AS TotalQuantityOrdered
FROM orderdetails
GROUP BY orderNumber
ORDER BY ProductCount DESC, TotalQuantityOrdered DESC;

-- 12) Classic Cars profit by quarter 

SELECT QUARTER(b.orderDate) AS Quarter, SUM(a.quantityOrdered*(a.priceEach-c.buyPrice)) AS Profit_Classic_Cars
FROM orderdetails a 
INNER JOIN orders b ON a.orderNumber=b.orderNumber
INNER JOIN products c ON a.productCode=c.productCode
WHERE productLine = 'Classic Cars'
GROUP BY QUARTER(b.orderDate);

-- 13) Vintage Cars profit by quarter 

SELECT QUARTER(b.orderDate) AS Quarter, SUM(a.quantityOrdered*(a.priceEach-c.buyPrice)) AS Profit_Vintage_Cars
FROM orderdetails a 
INNER JOIN orders b ON a.orderNumber=b.orderNumber
INNER JOIN products c ON a.productCode=c.productCode
WHERE productLine = 'Vintage Cars'
GROUP BY QUARTER(b.orderDate);

-- 14) ProductLine with maximum sale price

SELECT b.productLine, MAX(a.priceEach) AS MaxSaleValue
FROM orderdetails a
LEFT JOIN products b
ON a.productCode = b.productCode
GROUP BY b.productLine
ORDER BY MaxSaleValue DESC;

-- 15) Product Name with Max cost price

WITH cte AS(
SELECT productLine,MAX(buyPrice) AS price
FROM products
GROUP BY productLine) 
SELECT p.productLine,p.productName,p.productName,p.buyPrice
FROM products p
INNER JOIN cte d 
ON p.productLine=d.productLine  AND p.buyPrice = d.price
ORDER BY p.buyPrice DESC;

-- 16) Sales representative of customers with max sales

WITH cte1 AS(
SELECT a.customerName, b.firstName,b.lastName
FROM customers a
LEFT JOIN employees b 
ON a.salesRepEmployeeNumber = b.employeeNumber),
cte2 AS( 
SELECT c.customerName, SUM(a.quantityOrdered*a.priceEach) AS Sum_Sales
FROM orderdetails a
LEFT JOIN orders b ON a.orderNumber = b.orderNumber
LEFT JOIN customers  c ON b.customerNumber=c.customerNumber
GROUP BY c.customerNumber
ORDER BY Sum_Sales DESC
LIMIT 5)
SELECT b.customerName, b.Sum_Sales, CONCAT(a.firstName," ",a.lastName) AS Sales_Representative
FROM cte1 a 
INNER JOIN cte2 b
ON a.customerName=b.customerName
ORDER BY Sum_Sales DESC;

-- 17) Count of customers represented by Sales employees

SELECT CONCAT(b.firstName," ",b.lastName) AS Sales_Representative,b.employeeNumber, COUNT(a.customerNumber) AS TotalCustomer
FROM customers a
INNER JOIN employees b
ON a.salesRepEmployeeNumber = b.employeeNumber
GROUP BY a.salesRepEmployeeNumber
ORDER BY TotalCustomer DESC;

-- 18) Orders on hold

SELECT Count(*) AS Orders_On_Hold, status
FROM orders
WHERE status='On Hold';

-- 19) Product name with maximum ordered quantity

SELECT b.productCode, b.productName, SUM(a.quantityOrdered) AS Total_Quantity
FROM orderdetails a
INNER JOIN products b
ON a.productCode = b.productCode 
GROUP BY b.productCode 
ORDER BY Total_Quantity DESC
LIMIT 1;

-- 20) City/country having maximum sales representative

SELECT CONCAT(b.firstName," ",b.lastName) AS Sales_Representative, b.employeeNumber, COUNT(a.customerNumber) AS TotalCustomer, c.city, c.country
FROM customers a
INNER JOIN employees b
ON a.salesRepEmployeeNumber = b.employeeNumber
INNER JOIN offices c 
ON b.officeCode = c.officeCode
GROUP BY a.salesRepEmployeeNumber
ORDER BY TotalCustomer DESC;

/* ---------------------------------------------- */



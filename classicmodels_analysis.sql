use classicmodels;
select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;

-- 1.  Who are the top 5 highest spending customers?
SELECT c.customernumber,c.customername,c.city,c.state,
		SUM( quantityOrdered * priceEach) AS total_spent,
		MAX(orderDate) AS lastorder FROM customers c
		JOIN orders o on 
		c.customernumber=o.customernumber
		JOIN orderdetails d on
		o.ordernumber=d.ordernumber
GROUP BY c.customernumber,c.customername,c.city,c.state
ORDER BY total_spent DESC;
-- 2.Which employees have the highest total sales volumes?
SELECT customers.salesRepEmployeenumber,
		firstname,lastname,email,
		email,SUM( quantityOrdered * priceEach) AS total_sales 
FROM 	orderdetails 
		join orders USING(ordernumber)
		join customers USING(customernumber)
		join employees ON customers.salesRepEmployeenumber=employees.employeenumber
GROUP BY customers.salesRepEmployeenumber
ORDER BY total_sales DESC;
-- 3.Which office had the highest sales volumes?
SELECT  officeCode,
        CONCAT(
                 COALESCE(CONCAT(o.addressLine2,' - '), ''), 
                 COALESCE(CONCAT(o.addressLine1, ', '), ''), 
                 COALESCE(CONCAT(o.city), ''), 
                 COALESCE(CONCAT(', ', o.state), ''),
                 COALESCE(CONCAT(', ', o.country), '')
              ) AS Address,
        o.phone,
        SUM(quantityOrdered*priceEach) AS totalSales
FROM    orderdetails JOIN orders USING (orderNumber)
        JOIN customers USING (customerNumber)
        JOIN employees ON
        customers.salesRepEmployeeNumber = employees.employeeNumber
        JOIN offices o USING (officeCode)
GROUP BY  officeCode
ORDER BY  totalSales DESC;
-- 4.Over the three years where data was collected, how many orders were there per year?
SELECT COUNT(*) num_of_orders,
YEAR(orderdate) AS Years
FROM orders
GROUP BY Years;
-- 5.Which month has the most orders?
SELECT MONTH(orderdate)as Months,
COUNT(*) as orders
FROM orders
GROUP BY months
ORDER BY orders DESC;
-- 5. Over the three years where data was collected, what was the total revenue each year?
SELECT YEAR(paymentDate) as years,
SUM(amount) as Total_Revenue_Recevied
FROM payments
GROUP BY years;
-- 6. Which product line has the highest sales volume?
SELECT p.productline,SUM(quantityordered*priceeach) AS total_sales FROM orderdetails o
JOIN products p ON o.productcode=p.productcode
GROUP BY p.productline
ORDER BY total_sales DESC;

-- 7. Which productname has the highest sales volume?
SELECT p.productname,SUM(quantityordered*priceeach) AS total_sales FROM orderdetails o
JOIN products p ON o.productcode=p.productcode
GROUP BY p.productname
ORDER BY total_sales DESC;
-- 8.Which product line has the highest quantity in stock?
SELECT p.productline,SUM(quantityordered) AS total_quantity FROM orderdetails o
JOIN products p ON o.productcode=p.productcode
GROUP BY p.productline
ORDER BY total_quantity DESC;

-- 9. Which products have the highest quantity in stock?
SELECT p.productcode,p.quantityinstock,SUM(quantityordered*priceeach) AS total_sales
 FROM products p
JOIN orderdetails o ON p.productcode=o.productcode
GROUP BY p.productcode
ORDER BY p.quantityinstock DESC;

-- 10.Which productline have the highest quantity in stock?
SELECT p.productcode,productline,p.quantityinstock,SUM(quantityordered*priceeach) AS total_sales
 FROM products p
JOIN orderdetails o ON p.productcode=o.productcode
GROUP BY p.productcode
ORDER BY p.quantityinstock DESC;


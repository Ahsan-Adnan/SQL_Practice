SELECT 
DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS

--Show all customer details and find the toatal orders of each customer

SELECT
c.* ,
o.TotalOrders
FROM Sales.Customers c
LEFT JOIN (
SELECT
CustomerID,
COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID

--Find the products that have a price haigher than the average price of all products

SELECT
ProductID,
Price
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

--Show the details of orders made by custoemrs in Germany 
SELECT
*
FROM Sales.Orders
WHERE CustomerID IN 
			(SELECT
			CustomerID
			FROM Sales.Customers
			WHERE Country = 'Germany')


--Find female employees whose salaries are greater
-- than the salaries of any male employees 

SELECT
EmployeeID,
FirstName,
Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

--Show all custome details and find the toatal orders of each custoemr
SELECT
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales
FROM Sales.Customers c

--Show teh details of orders made by customers in Germany
SELECT *
FROM Sales.Orders o
WHERE EXISTS (SELECT
				*
				FROM Sales.Customers c
				WHERE Country = 'Germany'
				AND o.CustomerID = c.CustomerID )

-- Step1 : Find the total sales per cutomer (standalone cte)
WITH CTE_Total_Sales AS
(
SELECT 
CustomerID,
SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
--Step2: Find the last order date for each customer(Satandalone cte)
, CTE_Last_Order AS 
(
SELECT
CustomerID,
MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
),
--Step3: Rank customers based on Total sales per customer(Nested cte)
CTE_Customer_Rank AS
(
SELECT
CustomerID,
TotalSales,
RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
FROM CTE_Total_Sales)
--Step4:Segment customers based on their total sales(Nested cte)
, CTE_Customer_Segments AS
(
SELECT
CustomerID,
TotalSales,
CASE WHEN TotalSales > 100 THEN 'High'
	WHEN TotalSales > 80 THEN 'Medium'
	ELSE 'LOW'
END CustomerSegments
FROM CTE_Total_Sales
)


--Main Query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order,
ccr.CustomerRank,
ccs.CustomerSegments
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID=c.CustomerID
LEFT JOIN CTE_Customer_Segments ccs
ON ccs.CustomerID = c.CustomerID

--Generate a Sequence of Numbers from 1 to 20
WITH Series AS (
	--Anchor Query
	SELECT
	1 AS MyNumber
	UNION ALL
	--Recursive Query
	SELECT
	MyNumber + 1
	FROM Series
	WHERE MyNumber <20
)
--Main Query
SELECT *
FROM Series
OPTION (MAXRECURSION 30)

-- Task : show the employee hierarchy by displaying each employee's level within the organization
WITH CTE_Emp_Hierarchy AS
(
--Anchor Query
SELECT
  EmployeeID,
  FirstName,
  ManagerID,
  1 AS Level
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL
--Recursive Query
SELECT
 e.EmployeeID,
  e.FirstName,
  e.ManagerID,
  Level +1
FROM Sales.Employees AS e
INNER JOIN CTE_Emp_Hierarchy ceh
ON e.ManagerID = ceh.EmployeeID

)
--Main Query
SELECT
*
FROM CTE_Emp_Hierarchy



--find the running total of sales for each month
WITH CTE_Monthly_Summary AS (
SELECT
DATETRUNC(month,OrderDate) OrderMonth,
SUM(Sales) TotalSales,
COUNT(OrderID) TotalOrders,
SUM(Quantity) TotalQuantities
FROM Sales.Orders
GROUP BY DATETRUNC(month,OrderDate)
)
SELECT
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary


--view
CREATE VIEW Sales.V_Monthly_Summary AS
(
SELECT
DATETRUNC(month,OrderDate) OrderMonth,
SUM(Sales) TotalSales,
COUNT(OrderID) TotalOrders,
SUM(Quantity) TotalQuantities
FROM Sales.Orders
GROUP BY DATETRUNC(month,OrderDate)
)

DROP VIEW V_Monthly_Summary

--Task:Provide view that combines details from orders , products, customers  and employees

CREATE VIEW Sales.V_Order_Details AS (
SELECT
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') CustomerName,
c.Country CustomerCountry,
COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') SalesName,
e.Department,
--SalesPersonID,
--SalesPersonID,
o.Sales,
o.Quantity
FROM sales.Orders o
LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.SalesPersonID
)

--Provide a view fro EU Sales Team
--that combines details from ALL tables
-- And excludes Data related to the USA
CREATE VIEW Sales.V_Order_Details_EU AS (
SELECT
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') CustomerName,
c.Country CustomerCountry,
COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') SalesName,
e.Department,
--SalesPersonID,
--SalesPersonID,
o.Sales,
o.Quantity
FROM sales.Orders o
LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.SalesPersonID
WHERE c.Country != 'USA'
)
--CTAS
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
DROP TABLE Sales.MonthlyOrders;
GO
SELECT
DATENAME(month,OrderDate) OrderMonth,
COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)

SELECT * FROM Sales.MonthlyOrders
--DROP TABLE Sales.MonthlyOrders

--Temporary Tables
SELECT
*
INTO #Orders
FROM Sales.Orders

SELECT
* 
FROM #Orders

DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

SELECT
* 
INTO Sales.OrdersTEST
FROM #Orders


-- Step 1: Write a query
-- For us Customers Find the total Number of Customers and the Average Score
SELECT
COUNT(*) TotalCustomers,
AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country ='USA'

--Step 2: Turning the Query Into a Stored Procedure
CREATE PROCEDURE GetCustomerSummury AS 
BEGIN
SELECT
COUNT(*) TotalCustomers,
AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country ='USA'
END

--Step 3: Execute the Stored Procedure
EXEC GetCustomerSummury

--For German Customers Find the Total Number of Customers and the Average Score
CREATE PROCEDURE GetCustomerSummuryGermany AS 
BEGIN
SELECT
COUNT(*) TotalCustomers,
AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country ='Germany'
END

EXEC GetCustomerSummuryGermany

--Define Stored Procedure
ALTER PROCEDURE GetCustomerSummury @Country NVARCHAR(50) AS 
BEGIN
SELECT
COUNT(*) TotalCustomers,
AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country
--Find the total Nr. of Orders and Total Sales
SELECT
COUNT(OrderID) TotalOrders,
SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country =@Country;
END
--Execute the stored Procedure
EXEC GetCustomerSummury @Country ='Germany'

EXEC GetCustomerSummury
DROP PROCEDURE GetCustomerSummuryGermany

--Total Customers from Germany : 2
--Average Score from Germany :425
ALTER PROCEDURE GetCustomerSummury @Country NVARCHAR(50) AS 
BEGIN

DECLARE @TotalCustomers INT,@AvgScore FLOAT;

SELECT
@TotalCustomers = COUNT(*) ,
@AvgScore =AVG(Score) 
FROM Sales.Customers
WHERE Country = @Country

PRINT 'Total Customers from ' + @Country + ':' +CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from' + @Country + ':' +CAST(@AvgScore AS NVARCHAR);
SELECT
COUNT(OrderID) TotalOrders,
SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country =@Country;
END
GO
--Execute the stored Procedure
EXEC GetCustomerSummury @Country ='Germany'

--Prepare & Cleanup Data

IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)

BEGIN
	PRINT('Updating NULL Scores to 0');
	UPDATE Sales.Customers
	SET Score = 0
	WHERE Score IS NULL AND Country = @Country;
END

ELSE
BEGIN
	PRINT('NO NULL Scores found')
END;

--Generating Reports
ALTER PROCEDURE GetCustomerSummury @Country NVARCHAR(50) AS 
BEGIN

DECLARE @TotalCustomers INT,@AvgScore FLOAT;

SELECT
@TotalCustomers = COUNT(*) ,
@AvgScore =AVG(Score) 
FROM Sales.Customers
WHERE Country = @Country

PRINT 'Total Customers from ' + @Country + ':' +CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from' + @Country + ':' +CAST(@AvgScore AS NVARCHAR);
SELECT
COUNT(OrderID) TotalOrders,
SUM(Sales) TotalSales,
1/0

FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country =@Country;
END
GO
--Execute the stored Procedure
EXEC GetCustomerSummury @Country ='USA'


--Error Handling Try Catch in Stored Procedure



ALTER PROCEDURE GetCustomerSummury @Country NVARCHAR(50) = 'USA' AS
    
BEGIN
    BEGIN TRY
        -- Declare Variables
        DECLARE @TotalCustomers INT, @AvgScore FLOAT;     

        /* --------------------------------------------------------------------------
           Prepare & Cleanup Data
        -------------------------------------------------------------------------- */

        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT('Updating NULL Scores to 0');
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END
        ELSE
        BEGIN
            PRINT('No NULL Scores found');
        END;

        /* --------------------------------------------------------------------------
           Generating Reports
        -------------------------------------------------------------------------- */
        SELECT
            @TotalCustomers = COUNT(*),
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT('Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR));
        PRINT('Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR));

        SELECT
            COUNT(OrderID) AS TotalOrders,
            SUM(Sales) AS TotalSales,
            1/0 AS FaultyCalculation  -- Intentional error for demonstration
        FROM Sales.Orders AS o
        JOIN Sales.Customers AS c
            ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;
    END TRY
    BEGIN CATCH
        /* --------------------------------------------------------------------------
           Error Handling
        -------------------------------------------------------------------------- */
        PRINT('An error occurred.');
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR));
        PRINT('Error State: ' + CAST(ERROR_STATE() AS NVARCHAR));
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
        PRINT('Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
    END CATCH;
END
GO

--Execute Stored Procedure
EXEC GetCustomerSummury @Country = 'Germany';
EXEC GetCustomerSummury @Country = 'USA';
EXEC GetCustomerSummury;


CREATE TABLE Sales.EmployeeLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate DATE 
    )


CREATE TRIGGER trig_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT
        EmployeeID,
        'New Employee Added = ' + CAST(EmployeeID AS VARCHAR),
        GETDATE()
        FROM INSERTED
END

SELECT * FROM Sales.EmployeeLogs

INSERT INTO Sales.Employees
VALUES
(6,'Maria','Doe','HR','1988-01-12','F',80000,3)


SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers

SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)

CREATE CLUSTERED INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName)

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

SELECT *
FROM Sales.DBCustomers
WHERE FirstName = 'Anna'

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName)

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName)


SELECt 
* 
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country,Score)

Select * FROM Sales.Customers;
Select * FROM Sales.Employees;
Select * FROM Sales.Orders;
Select * FROM Sales.OrdersArchive;
Select * FROM Sales.Products;
/*Using salesDB , Retrieve a list of all orders 
, along with
the related cutomer,product and employee details.
For each order,display:
order Id, Customer's name , product name , Sales,
Price, Sales person's
name*/
USE SalesDB

Select 
o.OrderID,
c.FirstName AS CustomerFirstName,
c.LastName AS CustomerLastName,
p.Product AS ProductName,
o.Sales,
p.Price,
e.FirstName AS EmployeeFirstName,
e.LastName AS EmployeeLastName

From Sales.Orders as o
LEFT JOIN Sales.Customers as c
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Products as p
ON O.ProductID = p.ProductID
LEFT JOIN Sales.Employees as e
ON o.SalesPersonID = e.EmployeeID

--Combine the data from employees and customers into one table

SELECT 
FirstName,
LastName
FROM Sales.Customers

UNION

SELECT
FirstName,
LastName
FROM Sales.Employees

--combine the data from employees and customers into one table,including duplicates
SELECT 
FirstName,
LastName
FROM Sales.Customers

UNION ALL

SELECT
FirstName,
LastName
FROM Sales.Employees
--Find the employees who are not customers at the same time
SELECT 
FirstName,
LastName
FROM Sales.Customers

EXCEPT

SELECT
FirstName,
LastName
FROM Sales.Employees
--Find the Employees , who are also customers
SELECT 
FirstName,
LastName
FROM Sales.Customers

INTERSECT

SELECT
FirstName,
LastName
FROM Sales.Employees

--Orders data are stored in separate tables (Orders and OrdersArchive)
--Combine all orders data into one report without duplicates

SELECT 
'Orders' AS SourceTable,
        [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT
'OrdersArchive' AS SourceTable,
        [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
 ORDER BY OrderID

 SELECT
 OrderID,
 OrderDate,
 ShipDate,
 CreationTime
 FROM Sales.Orders

 SELECT
 OrderID,
 CreationTime,
 '2025-08-20' HardCoded,
 GETDATE() Today
 FROM Sales.Orders

 SELECT
 OrderID,
 CreationTime,
 --DATETRUNC Examples
  DATETRUNC(year,CreationTime) Year_dt,
 DATETRUNC(day,CreationTime) Day_dt,
  DATETRUNC(minute,CreationTime) Minute_dt,
 --DATENAME Examples
 DATENAME(month,CreationTime) Month_dn,
  DATENAME(weekday,CreationTime) week_dn,
 -- DATEPART Examples
 DATEPART(year,CreationTime) Year_dp,
 DATEPART(month,CreationTime) Month_dp,
 DATEPART(day,CreationTime) Day_dp,
 DATEPART(hour,CreationTime) Hour_dp,
 DATEPART(quarter,CreationTime) Quarter_dp,
 DATEPART(week,CreationTime) Week_dp,
 YEAR(CREATIONTIME) YEAR,
 MONTH(CREATIONTIME) Month,
 DAY(CREATIONTIME) Day
 FROM Sales.Orders


 SELECT 
 DATETRUNC(month,CreationTime) Creation,
 COUNT(*)
 FROM Sales.Orders
 GROUP BY DATETRUNC(month,CreationTime)

 SELECT
 CreationTime,
 COUNT(*)
 FROM Sales.Orders
 GROUP BY CreationTime

 SELECT 
 DATETRUNC(year,CreationTime) Creation,
 COUNT(*)
 FROM Sales.Orders
 GROUP BY DATETRUNC(year,CreationTime)

 SELECT
 OrderID,
 CreationTime,
 EOMONTH(CreationTime) EndOfMonth, 
CAST( DATETRUNC(month,CreationTime) AS DATE) StartOfMonth
 FROM Sales.Orders

 --How many orders were placed each year?
 SELECT
YEAR( OrderDate),
 COUNT(*) NrofOrders
 FROM Sales.Orders
 GROUP BY YEAR(OrderDate)

 --How many orders were placed each month?
 SELECT
DATENAME(month,OrderDate) AS OrderDate,
 COUNT(*) NrofOrders
 FROM Sales.Orders
 GROUP BY DATENAME(month,OrderDate)

 --Show all orders that were placed during the month of February
 SELECT
 *
 FROM Sales.Orders
 WHERE MONTH(OrderDate) =2

 SELECT
 OrderID,
 CreationTime,
 FORMAT(creationTime,'MM-dd-yyyy') USA_Format,
 FORMAT(creationTime,'dd-MM-yyyy') EURO_Format,
 FORMAT(CreationTime,'dd') dd,
 FORMAT(CreationTime,'ddd') ddd,
 FORMAT(CreationTime,'dddd') dddd,
 FORMAT(CreationTime,'MM') MM,
 FORMAT(CreationTime,'MMM') MMM,
 FORMAT(CreationTime,'MMMM') MMMM
 FROM Sales.Orders
 --Show CreationTime using the following format:
 --Day Wed Jan Q1 2025 12:34:56 PM
 SELECT
 OrderID,
 CreationTime,
 'Day ' + FORMAT(CreationTime,'ddd MMM') + ' Q' +
 DATENAME(quarter,CreationTime) + ' ' +
 FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
 FROM Sales.Orders 

 SELECT
 FORMAT(OrderDate, 'MMM yy') OrderDate,
 COUNT(*)
 FROM Sales.Orders
 GROUP BY FORMAT(OrderDate,'MMM yy')

 SELECT
 --CONVERT(INT,'123') AS [String to Int CONVERT],
 --CONVERT(DATE,'2025-08-20') AS [String to date CONVERT],
 CreationTime,
 CONVERT(DATE,CreationTime) AS [Datetime to Date Convert],
 CONVERT(VARCHAR,CreationTime, 32) AS [USA Std. Style:32],
 CONVERT(VARCHAR, CreationTime,34) AS [EURO Std. Style:34]
 FROM Sales.Orders

SELECT
 CAST('123' AS INT) AS [String to Int],
 CAST(123 AS VARCHAR) AS [Int to String],
 CAST('2025-08-20'AS DATE) AS [String to Date],
 CAST('2025-08-20' AS DATETIME2) AS [String to Datetime],
 CreationTime,
 CAST(CreationTime AS DATE) AS [DateTime to Date]
 FROM Sales.Orders

 SELECT
 OrderID,
 OrderDate,
 DATEADD(day,-3,OrderDate) AS TenDaysBefore,
 DATEADD(month,3,OrderDate) AS ThreeMOnthsLater,
 DATEADD(year,2,OrderDate) AS TwoYearsLater
 FROM Sales.Orders

 --Calculate the age of employees
 SELECT
 EmployeeID,
 BirthDate,
 DateDIFF(year,BirthDate,GETDATE()) Age
 FROM Sales.Employees

 --Find the average shipping duration in days for each month
 SELECT
 MONTH(OrderDate) AS OrderDate,
AVG( DateDIFF(DAY,OrderDate,ShipDate)) AvgShip
 FROM Sales.Orders
 GROUP BY MONTH(OrderDate)

 --Time Gap Analysis
 --Find the number of days between each order and the previous order
 SELECT
 OrderID,
 OrderDate CurrentOrderDate,
 LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
 DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate),OrderDate) NrOfDays
 FROM Sales.Orders

 SELECT
 ISDATE('123') DateCheck1,
 ISDATE('2025-08-20') DateCheck2,
 ISDATE('20-08-2025') DateCheck3,
 ISDATE('2025') DateCheck4,
 ISDATE('08') DateCheck5

 SELECT
 --CAST(OrderDate AS DATE) OrderDate,
 OrderDate,
 ISDATE(OrderDate),
 CASE WHEN ISDATE(OrderDate) =1 THEN CAST(OrderDate AS DATE)
 ELSE '9999-01-01'
 END NewOrderDate
 FROM
 (
 SELECT '2025-08-20'  AS OrderDate UNION
 SELECT '2025-08-21' UNION
 SELECT '2025-08-23' UNION
 SELECT '2025-08'
 )t
 WHERE ISDATE(OrderDate)=0

 --Find the average scores of the customers
 SELECT
 CustomerID,
 Score,
 COALESCE(Score,0) Score2,
 AVG(Score) OVER () AcgScores,
 AVG(COALESCE(Score,0)) OVER() AvgScores2
 FROM Sales.Customers

 --Display teh full name of customers in single field 
 --by merging their first and last names 
 -- and add 10 bonus points to each customer's score

 SELECT
 CustomerID,
 FirstName,
 LastName,
 Score,
 FirstName + ' ' + COALESCE(LastName,'') AS FullName,
 COALESCE(Score,0) + 10 AS TotalScore
 FROM Sales.Customers

 --Sort the customers from lowest to highest scores,
 -- with null appearing last
 SELECT 
 CustomerID,
 Score,
 CASE WHEN Score IS NULL THEN 1 ELSE 0 END flag
 FROM Sales.Customers
 ORDER BY  COALESCE(Score,999999)

 -- Find the sales price for each order by dividing sales by quantity
 SELECT
 OrderID,
 Sales,
 Quantity,
 Sales / NULLIF(Quantity,0) AS Price
 FROM Sales.Orders

 --Identify the customers who have no scores
 SELECT
 *
 FROM Sales.Customers
 --WHERE Score IS NULL 
 WHERE Score IS NOT NULL

 --list all details for customers who have not placed any orders
 SELECT
 c.*,
 o.OrderID
 FROM  Sales.Customers c
 LEFT JOIN Sales.Orders o
 ON c.CustomerID = o.CustomerID
 WHERE OrderID IS NULL

 WITH Orders AS (
 SELECT 1 Id, 'A' Category UNION
 SELECT 2, NULL UNION
 SELECT 3, '' UNION
 SELECT 4, '  '
 )
 SELECT
 *,
 DATALENGTH (Category) CategoryLen,
 DATALENGTH (TRIM(Category)) Policy1
 FROM Orders

 WITH Orders AS (
 SELECT 1 Id, 'A' Category UNION
 SELECT 2, NULL UNION
 SELECT 3, '' UNION
 SELECT 4, '  '
 )
 SELECT
 *,
 --DATALENGTH (Category) CategoryLen,
 --DATALENGTH (TRIM(Category)) Policy1
 TRIM(Category) Policy1,
 NULLIF(TRIM(Category),'') Policy2,
 COALESCE(NULLIF(TRIM(Category),''),'unknown') Policy3
 FROM Orders

 --Create report showing total sales for each of the following categories
 --High (sales over 50) , Medium (Sales 21-50), and Low (Sales 20 or less)
 --Sort the categories from highest sales to lowest
 SELECT
 Category,
 SUM(Sales) AS TotalSales
 FROM(
     SELECT
     OrderID,
     Sales,
     CASE
     WHEN Sales > 50 THEN 'High'
     WHEN Sales > 20 THEN 'Medium'
     ELSE 'Low'
     END Category
     FROM Sales.Orders
)t
GROUP By Category
ORDER BY TotalSales DESC

-- Retrive employee details with gender displayed aas full text

SELECT
EmployeeID ,
FirstName,
LastName,
Gender,
CASE
    WHEN Gender = 'F' THEN 'Female'
    WHEN Gender = 'M' THEN 'Male'
    ELSE 'Not Available'

END GenderFullText
FROM Sales.Employees

--Retrieve customers details with abbreviated country code
SELECT
CustomerID,
FirstName,
LastName,
Country,
CASE
WHEN Country = 'Germany' THEN 'DE'
WHEN Country = 'USA' THEN 'US'
ELSE 'n/a'
END CountryAbbr
FROM Sales.Customers;

SELECT DISTINCT Country
FROM Sales.Customers;

--Find the average scores of customers and treat nulls as 0
--Additionally provide detakls such CustomerID and LastName
SELECT
CustomerID,
LastName,
Score,
CASE
WHEN Score IS NULL THEN 0
ELSE Score
END ScoreClean,
AVG(CASE 
    WHEN Score IS NULL THEN 0
    ELSE Score
    END)  OVER () AvgCustomerCLean,
AVG(Score) OVER() AvgCustomer
FROM Sales.Customers

--Count how many times each customer has made an order with sales greater than 30
SELECT
OrderID ,
CustomerID ,
Sales ,
CASE
WHEN Sales > 30 THEN 1
ELSE 0
END SalesFlag
FROM Sales.Orders
ORDER BY CustomerID

SELECT
CustomerID ,
SUM(CASE
WHEN Sales > 30 THEN 1
ELSE 0
END ) TotalOrdersHighSales,
COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID

--Find the total sales fof all orders
SELECT
customer_id,
COUNT(*) AS total_nr_orders,
SUM(sales) AS total_sales,
AVG(sales) AS avg_sales,
max(sales) AS Max_sales,
MIN(sales) AS MIN_sales
FROM orders
GROUP BY customer_id

--Analyze score with aggregating function

--Find the total sales across all orders
SELECT
SUM(Sales) TotalSales
FROM Sales.Orders

--Find the total sales for each product
SELECT
ProductID,
SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID

--Find the total sales for each product 
--Additionally provide details such order Id, order date

SELECT
OrderID,
OrderDate,
ProductID,
OrderStatus,
Sales,
SUM(Sales) OVER() TotalSales,
SUM(Sales) OVER (PARTITION BY ProductID) TotalSalesByProducts,
SUM(Sales) OVER (PARTITION BY ProductID,OrderStatus) SalesByProductAndStatus
FROM Sales.Orders

--Rank each order based on their sales from highest to lowest
--Additionally provide details such order Id,order date

SELECT
OrderID,
OrderDate,
Sales,
RANK() OVER (ORDER BY Sales DESC) RankSales
FROM Sales.Orders

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER(Partition BY OrderStatus Order BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING ) TotalSales
FROM Sales.Orders


SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING ) TotalSales
FROM Sales.Orders


SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) TotalSales
FROM Sales.Orders


SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
ROWS UNBOUNDED PRECEDING ) TotalSales
FROM Sales.Orders


SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate) TotalSales
FROM Sales.Orders

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) TotalSales
FROM Sales.Orders

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING ) TotalSales
FROM Sales.Orders

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus)
FROM Sales.Orders

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus)
FROM Sales.Orders
ORDER BY SUM(Sales) OVER (PARTITION BY OrderStatus) DESC

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus)
FROM Sales.Orders
WHERE ProductID IN (101,102)


--Rnak Customers based ontheir total sales
 SELECT
 CustomerID,
 SUM(Sales) TotalSales,
 RANK() OVER(ORDER BY SUM(Sales) DESC ) RankCustomers
 FROM Sales.Orders
 GROUP BY CustomerID


 SELECT
 CustomerID,
 SUM(Sales) TotalSales,
 RANK() OVER(ORDER BY CustomerID DESC ) RankCustomers
 FROM Sales.Orders
 GROUP BY CustomerID

 --Find the total number of Orders
 --Find the total number of Orders for each customers
 --Additionally procide details such order Id, order date
 SELECT
 OrderID,
 OrderDate,
 CustomerID,
 COUNT(*) OVER() TotalOrders,
 COUNT(*) OVER(Partition BY CustomerID) OrderByCustmers
 FROM Sales.Orders

 --Find the total number of customers 
 -- Additionally provide all customers details
 SELECT
 *,
 COUNT(*) OVER() TotalCustomersStar,
 COUNT(1) OVER () TotalCustomerOne,
 COUNT(Score) OVER() TotalScores,
 COUNT(Country) OVER() TotalCoutries
 FROM Sales.Customers

 --Check whether the table 'orders' contains any duplicate rows
 SELECT
 OrderID,
 COUNT(*) OVER (PARTITION BY OrderID) CheckPK
 FROM Sales.Orders


 SELECT
 *
 FROM(
 SELECT
 OrderID,
 COUNT(*) OVER (PARTITION BY OrderID) CheckPK
 FROM Sales.OrdersArchive
 )t WHERE CheckPK >1

 --Find the total sales across all orders
 --And the total sales fro each product 
 --Additionally procide details such order Id, order date
 SELECT
 orderID,
 orderDate,
 Sales,
 ProductID,
 SUM(Sales) OVER () TotalSales,
 SUM(Sales) OVER (PARTITION BY ProductID) SalesByProducts
 FROM Sales.Orders

 --Find the percentage contribution of each product's sales to
 --the total sales
 SELECT
 OrderID,
 ProductID,
 Sales,
 SUM(Sales) OVER() TotalSales,
 ROUND (CAST (Sales AS Float) / SUM(Sales) OVER() *100,2) PercentageOfTotal
 FROM Sales.Orders

 --Find the average sales across all orders
 --And fidn the average sales for each product
 --Additionally provide details such order Id, order date

  SELECT
  OrderID,
  OrderDate,
  Sales,
  ProductID,
  AVG(Sales) OVER () AvgSales,
  AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProducts
  FROM Sales.Orders

  --Find the average scores of customers
  --Additionally provide details such CustomerID and LastName

  SELECT
  CustomerID,
  LastName,
  Score,
  COALESCE(Score,0) CustomerScore,
  AVG(Score) OVER() AvgScore,
  AVG(COALESCE(Score,0)) OVER() AvgScoreWithoutNull
  FROM Sales.Customers

  --Find all orders whre sales are higher than the average sales 
  --across all orders

  SELECT
  *
  FROM(
  SELECT
  OrderID,
  ProductID,
  Sales,
  AVG(Sales) OVER() AvgSales
  FROM Sales.Orders
  )t WHERE Sales > AvgSales

  --Find the highest and lowest sales of all orders 
  --Find teh highest and lowest sales for each product
  -- Additionally provide details such order Id, orderdate

  SELECT
  OrderID,
  OrderDate,
  ProductID,
  Sales,
  MAX(Sales) OVER() HighestSales,
  MIN(Sales) OVER() LowestSales,
  MAX (Sales) OVER(PARTITION BY ProductID) HighestSalesByProduct,
  MIN(Sales) OVER(PARTITION BY ProductID) LowestSalesProduct
  FROM Sales.Orders

  --Shows the employees who have the highest salaries
  SELECT
  *
  FROM(
  SELECT *,
  MAX(Salary) OVER() HighestSalary
  FROM Sales.Employees
  )t WHERE Salary = HighestSalary

  --Find the deviation of each sales from the minimum and maximum
  --sales amount
  SELECT
  OrderID,
  OrderDate,
  ProductID,
  Sales,
  MAX(Sales) OVER() HighestSales,
  MIN(Sales) OVER() LowestSales,
  Sales - MIN(Sales) OVER() DeviationFromMin,
  MAX(Sales) OVER() - Sales DeviationFromMax
  FROM Sales.Orders

  --Calculate moving average of sales for each product over time 
  SELECT
  OrderID,
  ProductID,
  OrderDate,
  Sales,
  AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
  AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg
  FROM Sales.Orders

  --Calculate moving average of sales for each product over time
  --Calculate moving average of sales for each product over time, including only the next order
  SELECT
  OrderID,
  ProductID,
  OrderDate,
  Sales,
  AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
  AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
 AVG(sales) OVER (PARTITION BY ProductID Order BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
 
 FROM Sales.Orders

 --Rank the orders  based on theri sales from highest to lowest
 SELECT
 OrderID,
 ProductID,
 Sales,
 ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row,
 RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank,
 DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_Dense
 FROM Sales.Orders

 --Find the top highest sales fro each product
 SELECT *
 FROM (
 SELECT
 OrderID,
 ProductID,
 sales,
 ROW_NUMBER() OVER  (PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
 FROM Sales.Orders
 )t WHERE RankByProduct = 1

 --Find the lowest 2 customers based on their total sales
 SELECT *
 FROM(
 SELECT
 CustomerID,
 SUM(Sales) TotalSlaes,
 ROW_NUMBER() OVER (ORDER BY SUM(Sales) ) RankCustomers
 FROM Sales.Orders
 GROUP BY 
 CustomerID
 )t WHERE RankCustomers <=2

 --Assign unique IDs to the rows of the 'Orders Archive' table

 SELECT
 ROW_NUMBER() OVER (ORDER BY OrderID,OrderDate) UniqueID,
 *
 FROM Sales.OrdersArchive

 --Identify duplicate rows in the table 'Orders Archive'
 --and rwturn a clean result without any duplicates
 SELECT * FROM (
 SELECT 
 ROW_NUMBER() OVER (PARTITION BY OrderID Order BY CreationTime DESC) rn,
 *
 FROM Sales.OrdersArchive
 )t WHERE rn=1

 SELECT
 OrderID,
 Sales,
 NTILE(4) OVER (ORDER BY Sales DESC) FourBucket,
 NTILE(3) OVER (ORDER BY Sales DESC) ThreeBucket,
 NTILE(2) OVER (ORDER BY Sales DESC) TwoBucket,
 NTILE(1) OVER (ORDER BY Sales DESC) OneBucket
 FROM Sales.Orders

 --Segment all orders into 3 categories :high,nedium and lwo sales
 SELECT *,
 CASE WHEN Buckets =1 THEN 'High'
      WHEN Buckets = 2 THEN 'Medium'
      WHEN Buckets = 3 THEN 'Low'
END SalesSegmentations
FROM (
 
 
 SELECT
 OrderID,
 Sales,
 NTILE(3) OVER ( ORDER BY Sales DESC) Buckets
 FROM Sales.Orders
 )t

 --IN order to export the data,divide the orders into 2 groups
 SELECT
 NTILE(2) OVER (ORDER BY OrderID) Buckets,
 *
 FROM Sales.Orders

 --Find the products that fall within the highest 40% of the prices
 SELECT * ,
 CONCAT(DistRank *100 , '%') DistRankPerc
 FROM (

 
 SELECT
 Product,
 price ,
 CUME_DIST() OVER (ORDER BY Price DESC) DistRank
 FROM Sales.Products
 )t WHERE DistRank <= 0.4


 SELECT * ,
 CONCAT(DistRank *100 , '%') DistRankPerc
 FROM (

 
 SELECT
 Product,
 price ,
 PERCENT_RANK() OVER (ORDER BY Price DESC) DistRank
 FROM Sales.Products
 )t WHERE DistRank <= 0.4


 --Analyze the month-over-month performance by finding the percentage change
 --in sales between the current and pervious months
 SELECT
 *,
 CurrentMonthSales - PreviousMonthSales AS MoM_Change,
 ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT )/ PreviousMonthSales *100,1) AS MoM_Perc
 FROM (
 
 SELECT
 MONTH(OrderDate) OrderMonth,
 SUM(Sales) CurrentMOnthSales,
 LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales
 FROM Sales.Orders
 GROUP BY
 MONTH(OrderDate)
 )t

 --In order to analyze customer loyalty,
 --rank customers based on the average days between their orders
 SELECT
 CustomerID,
 AVG(DaysUntilNextOrder) AvgDays,
 RANK() OVER (ORDER BY COALESCE( AVG(DaysUntilNextOrder),99999)) RankAvg
 FROM(
 
 SELECT
 OrderID,
 CustomerID,
 OrderDate CurrentOrder,
 LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
 DATEDIFF(day,OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
 FROM Sales.Orders
 )t
 GROUP BY CustomerID

 --Find the lowest and highest sales for each product
 SELECT
 OrderID,
 ProductID,
 Sales,
 FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) LowestSlaes,
 LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales
 ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
 --FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales DESC) HighestSlaes2,
 --MIN(Sales) OVER(PARTITION BY ProductID) LowestSales2,
 --MAX(Sales) OVER(PARTITION BY ProductID) HighestSales3
 Sales-FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
 FROM Sales.Orders

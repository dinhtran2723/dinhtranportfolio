/* Lesson 5: Aggregate functions and Group by

Main Agenda:
    - Aggregate functions and GROUP BY
    - OVER Clause and Window functions */

--Classwork

/* Exercise 1: Write a query using the DimProduct table that displays the minimum, maximum, 
and average ListPrice of all product */

USE AdventureWorksDW2019
SELECT
    MIN(ListPrice) AS MinListPrice,
    MaX(ListPrice) AS MaxListPrice,
    AVG(ListPrice) AS AvgListPrice
FROM DimProduct

/* Excersice 2: Write a query to determine the number of products 
in the FactInternetSales table of all time */

USE AdventureWorksDW2019
SELECT 
    COUNT(DISTINCT ProductKey) AS CountDist,
    COUNT(*) AS CountAll
FROM FactInternetSale

/* Excersice 3: The company is about to run a loyalty scheme to retain customers having total 
value of orders greater than 5000 USD per year. From FactInternetSales table, retrieve the
list of qualified customers and the corresponding year.*/

USE AdventureWorksDW2019
SELECT
    FIS.CustomerKey,
    YEAR(FIS.OrderDate) AS YEAR,
    SUM(FIS.SalesAmount) AS TotalAmount
FROM FactInternetSales AS FIS
GROUP BY FIS.CustomerKey, YEAR(FIS.OrderDate)
HAVING SUM(FIS.SalesAmount) > 5000


--Homework

/* Exercise 1: From DimEmployee, calculate the average of BaseRate of each Title in the company  */  

USE AdventureWorksDW2019
SELECT 
    Title,
    AVG(BaseRate) AverageBaseRate
FROM DimEmployee
GROUP BY Title
 

/* Exercise 2: From FactInternetSales table, 
select TotalOrderQuantity column, 
use OrderQuantity column to calculate the total selling amount of each ProductKey and each OrderDate */ 

USE AdventureWorksDW2019
SELECT 
    ProductKey,
    OrderDate,
    Sum(OrderQuantity) TotalOrderQuantity
FROM FactInternetSales
GROUP BY ProductKey, OrderDate
ORDER BY ProductKey, OrderDate

/* Exercise 3: From DimProduct, FactInternetSales, DimProductCategory table and other relevant tables (if necessary) 
Select CategoryKey, EnglishCategoryName table
of the row that has OrderDate within 2012, and calculate:
- TotalRevenue using SalesAmount 
- TotalCost using TotalProductCost 
- TotalProfit using (TotalRevenue - TotalCost) 
Only show the outputs that have TotalRevenue > 5000  */  

SELECT 
    DPC.ProductCategoryKey,
    DPC.EnglishProductCategoryName,
    SUM(FIS.SalesAmount) AS TotalRevenue,
    SUM(FIS.TotalProductCost) AS TotalCost,
    SUM(FIS.SalesAmount - FIS.TotalProductCost) AS TotalProfit
FROM FactInternetSales AS FIS
LEFT JOIN DimProduct AS DP ON DP.ProductKey = FIS.ProductKey
LEFT JOIN DimProductSubcategory AS DPSC ON DP.ProductSubcategoryKey = DPSC.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS DPC ON DPSC.ProductCategoryKey = DPC.ProductCategoryKey
WHERE Year(FIS.OrderDate) = 2012
GROUP BY DPC.ProductCategoryKey, DPC.EnglishProductCategoryName
HAVING SUM(FIS.SalesAmount) > 5000

/* Exercise 4: From FactInternetSale, DimProduct table, 

- Create Color_group column, using Color column, 
if Color is 'Black' or 'Silver', then 'Basic' for Color_group column, if else, take the orginial value from Color column 
- Then, calculate TotalRevenue, using SalesAmount column, for each value in the Color_group column  */  

-- Using CTE
WITH Product_new AS 
(SELECT 
    ProductKey,
    Color,
    (CASE WHEN Color in ('Black', 'Silver') THEN 'Basic'
            ELSE Color 
            END) AS Color_group
FROM DimProduct)

SELECT
    DP.Color_group,
    SUM(FIS.SalesAmount) AS TotalSalesAmount
FROM FactInternetSales AS FIS 
LEFT JOIN Product_new AS DP 
ON FIS.ProductKey = DP.ProductKey
GROUP BY DP.Color_group

-- Not using CTE
SELECT 
	(CASE WHEN Color in ('Black', 'Silver') THEN 'Basic'
	    ELSE Color 
        END) AS Color_group,
    SUM(SalesAmount) AS TotalSalesAmount
FROM FactInternetSales AS FIS 
LEFT JOIN DimProduct AS DP 
ON FIS.ProductKey = DP.ProductKey
GROUP BY (CASE WHEN Color IN ('Black', 'Silver') THEN 'Basic'
    ELSE Color 
    END)

/* Ex 5 From FactInternetSales, FactResellerSales and other relevant tables (if necessary),
use SalesAmount to calculate monthly revenue for 2 selling sources, Internet and Reseller 

The outcome will include: Year, Month, InternSales, Reseller_Sales 

Hint: Calculate monthly revenue in 2 independent tables, FactInternetSales and FactResellersSales, by using CTE

NOTE: If using more than 1 CTE, syntax writing should be like this:  

WITH Name_CTE_1 AS (SELECT statement ) 

, Name_CTE_2 AS ( SELECT statement )  

SELECT statement  */  

WITH MonthlyInternetSales AS 
(SELECT 
    YEAR(OrderDate) AS YearNumber,
    MONTH(OrderDate) AS MonthNumber,
    SUM(SalesAmount) AS InternetSaleAmount
FROM dbo.FactInternetSales
GROUP BY YEAR(OrderDate), MONTH(OrderDate) ),
MonthlyResellerSales AS
(SELECT 
    YEAR(OrderDate) AS YearNumber,
    MONTH(OrderDate) AS MonthNumber,
    SUM(SalesAmount) AS ResellerSaleAmount
FROM dbo.FactResellerSales
GROUP BY YEAR(OrderDate), MONTH(OrderDate) )

SELECT 
    ISNULL(Internet.YearNumber, Reseller.YearNumber) AS YearNumber
    , ISNULL(Internet.MonthNumber, Reseller.MonthNumber) AS MonthNumber
    , InternetSaleAmount
    , ResellerSaleAmount
FROM MonthlyInternetSales AS Internet
    FULL OUTER JOIN MonthlyResellerSales AS Reseller 
        ON Reseller.MonthNumber = Internet.MonthNumber 
            AND Reseller.YearNumber = Internet.YearNumber
ORDER BY YearNumber DESC, MonthNumber ASC

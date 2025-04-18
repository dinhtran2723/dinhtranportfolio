/* Lesson 3: Using Joins and Unions

Main Agenda:
    - Using Logical Statement
    - Using Joins, Unions */

--Classwork

/* Ex1 (CASE WHEN)
From DimProduct, retrieve ProductKey, ListPrice and generate a new column named
ProductSegmentation based on the following rules: if ListPrice is greater than 2000 then
assign value “Premium”, ListPrice from 1000 to 2000 then assign value “Normal”, ListPrice is
lower than 1000 then assign value “Cheap”, in case ListPrice is NULL, assign value “Undefined” */

USE AdventureWorksDW2019
SELECT 
    ProductKey,
    ListPrice, 
        Case 
            When ListPrice > 2000 THEN 'Premium'
            When ListPrice >= 1000 AND ListPrice <= 2000 THEN 'Normal'
            WHEN ListPrice < 1000 THEN 'Cheap'
            ELSE 'Undefined'
            END AS 'ProductSegmentation'
FROM DimProduct

/* Ex2 (JOIN)
From DimCustomer, DimGeography
Retrieve CustomerKey, CustomerFullName (based on FirstName, MiddleName, LastName)
and their EnglishCountryRegionName, StateProvinceName */

USE AdventureWorksDW2019
SELECT
    DC.CustomerKey,
    CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) as CustomerFullName,
    DG.EnglishCountryRegionName,
    DG.StateProvinceCode
FROM DimCustomer AS DC
JOIN DimGeography AS DG
ON DC.GeographyKey = DG.GeographyKey

--Homework

/*Exercise 1: From dbo.FactInternetSales and dbo.DimSalesTerritory table, 
Select SalesOrd columnerNumber column, SalesOrderLineNumber column, ProductKey column, SalesTerritoryCountry column  
of all the outputs that have SalesAmount over 1000  */ 

USE AdventureWorksDW2019
SELECT 
    FIS.SalesOrderNumber,
    FIS.SalesOrderLineNumber,
    FIS.ProductKey,
    FIS.SalesAmount,
    DST.SalesTerritoryCountry
FROM dbo.FactInternetSales AS FIS
JOIN dbo.DimSalesTerritory AS DST
ON FIS.SalesTerritoryKey = DST.SalesTerritoryKey
WHERE FIS.SalesAmount > 1000

/*Exercise 2: From dbo.DimProduct and dbo.DimProductSubcategory table. 
Select ProductKey column, EnglishProductName column và Color column 
of all the products that has 'Bikes' in their EnglishProductSubCategoryName column   
and has 3399 as the integer part in ListPrice */ 

USE AdventureWorksDW2019
SELECT 
    DP.ProductKey,
    DP.EnglishProductName,
    DP.Color,
    DP.ListPrice,
    DPS.EnglishProductSubcategoryName
FROM dbo.DimProduct AS DP
JOIN dbo.DimProductSubcategory AS DPS
ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
WHERE DPS.EnglishProductSubcategoryName LIKE '%BIKE%' AND FLOOR(DP.Listprice) = 3399

/* Ex 3: From dbo.DimPromotion and dbo.FactInternetSales table, 
Select ProductKey column, SalesOrderNumber column, SalesAmount column of the output that has DiscountPct >= 20%  */ 

USE AdventureWorksDW2019
SELECT 
    FIS.ProductKey,
    FIS.SalesOrderNumber,
    FIS.SalesAmount
FROM dbo.DimPromotion AS DPM
JOIN dbo.FactInternetSales AS FIS
ON DPM.PromotionKey = FIS.PromotionKey
WHERE DPM.DiscountPct >= 0.2

/* Exercise 4: From dbo.DimCustomer and dbo.DimGeography table, 
Select Phone column, FullName column (taking FirstName column, MiddleName column, LastName column with space between) 
and City column of those cutomers that has YearlyInCome > 150000 and CommuteDistance lower than 5 Miles */ 

USE AdventureWorksDW2019
SELECT 
    DC.Phone,
    DC.FirstName + ISNULL(MiddleName,'') + ' ' + DC.LastName AS 'FullName',
    DG.City,
    DC.YearlyInCome,
    DC.CommuteDistance
FROM DimCustomer AS DC
JOIN DimGeography AS DG
ON DC.GeographyKey = DG.GeographyKey
WHERE DC.YearlyInCome > 150000 AND DC.CommuteDistance LIKE '%-5 Miles'

/* Exercise 5: From dbo.DimCustomer table, select CustomerKey column and follow the next requirements:  

a. Create a new column named YearlyInComeRange, following these conditions:  
- If YearlyIncome from 0 to 50000 then "Low Income"  
- If YearlyIncome from 50001 to 90000 then "Middle Income"  
- If YearlyIncome is over 90001 then "High Income"  

b. Create a new column named AgeRange, following these conditions:  
- If customers' age, till 31/12/2019, is 39 years old or younger, then "Young Adults"  
- If customers' age, till 31/12/2019, is from 40 to 59 years old, then "Middle-Aged Adults"  
- If customers' age, till 31/12/2019, is over 60 years old, then "Old Adults"  */

USE AdventureWorksDW2019
SELECT 
    CustomerKey,
    CASE
        WHEN YearlyIncome BETWEEN 0 AND 50000 THEN 'LowIncome'
        WHEN YearlyIncome BETWEEN 50001 AND 90000 THEN 'MiddleIncome'
        WHEN YearlyIncome > 90001 THEN 'HighIncome'
        ELSE 'Other'
        END AS 'YearlyIncomeRange',
    CASE
        WHEN DATEDIFF(year,BirthDate,'2019-12-31') <= 39 THEN 'YoungAdults'
        WHEN DATEDIFF(year,BirthDate,'2019-12-31') BETWEEN 40 AND 59 THEN 'Middle-AgedAdults'
        WHEN DATEDIFF(year,BirthDate,'2019-12-31') >= 60 THEN 'OldAdults'
        ELSE 'Other'
        END AS 'AgeRange'  
FROM dbo.DimCustomer 

/* Exercise 6: From FactInternetSales, FactResellerSales and DimProduct table. 
Find all the SalesOrderNumber that has 'Road' in their EnglishProductName and has Yellow color */ 


USE AdventureWorksDW2019
SELECT 
    FIRS.SalesOrderNumber
FROM DimProduct AS DP
JOIN (SELECT 
    FIS.SalesOrderNumber,
    FIS.ProductKey
FROM FactInternetSales AS FIS
Union ALL
SELECT 
    FRS.SalesOrderNumber,
    FRS.ProductKey
FROM FactResellerSales AS FRS) AS FIRS
ON DP.ProductKey = FIRS.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%' AND DP.Color='Yellow'
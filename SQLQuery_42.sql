/* Lesson 4: Using Joins and Subqueries

Main Agenda:
    - Using Joins and Subqueries
    - Using Subqueries */

-- Classwork

/*Exercise 1:
From dbo.DimProduct and dbo.DimProductSubcategory, dbo.DimProductCategrory
Write a query displaying the Product key, EnglishProductName, EnglishProductSubCategoryName ,
EnglishProductCategroyName and Color columns
of product which has EnglishProductCategoryName is 'Clothing'
*/

SELECT 
    DP.ProductKey,
    DP.EnglishProductName,
    DPS.EnglishProductSubCategoryName,
    DPS.EnglishProductCategoryName,
    DP.Color
FROM DimProduct AS DP
Left JOIN dbo.DimProductSubcategory AS DPS ON DP.ProductSubCategoryKey = DPS.ProductSubCategoryKey
LEFT JOIN dbo.DimProductCategory AS DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey
WHERE DPC.EnglishProductCategoryName = 'Clothing'

/* Exercise 2:
From dbo.DimDepartmentGroup, write a query display DepartmentGroupName and their parent
DepartmentGroupName */

USE AdventureworksDW2019
SELECT 
    Child.DepartmentGroupKey,
    Child.DepartmentGroupName,
    Parent.DepartmentGroupKey AS ParentName
FROM DimDeparmentGroup AS Child
LEFT JOIN DimDepartmentGroup AS Parent
ON Child.ParentDepartmentGroupKey = Parent.DepartmentGroupKey 

--Homework

/*Exercise 1: From dbo.DimProduct, dbo.DimPromotion and dbo.FactInternetSales table, 
Select ProductKey column, EnglishProductName column of those rows that has Discount Pct >= 20%  */ 

USE AdventureWorksDW2019
SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DPR.DiscountPct
FROM dbo.FactInternetSales AS FIS
LEFT JOIN dbo.DimProduct AS DP ON DP.ProductKey = FIS.ProductKey
LEFT JOIN dbo.DimPromotion AS DPR ON DPR.PromotionKey = FIS.PromotionKey
WHERE DPR.DiscountPct >= 0.2

/*Exercise 2: From DimProduct, DimProductSubcategory and DimProductCategory table, 
Select Product key column, EnglishProductName column, EnglishProductSubCategoryName column, EnglishProductCategoryName column 
of those products that has 'Clothing' in their EnglishProductCategoryName  */ 

USE AdventureWorksDW2019
SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DPS.EnglishProductSubcategoryName,
    DPC.EnglishProductCategoryName
FROM DimProduct AS DP
LEFT JOIN DimProductSubcategory AS DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey
WHERE DPC.EnglishProductCategoryName = 'Clothing'

/*Exercise 3: From FactInternetSales and DimProduct table, 
Select ProductKey column, EnglishProductName column, ListPrice column of those products that have not been sold.  
NOTE: Use 2 ways: IN and JOIN  */ 


-- Using IN
SELECT 
    ProductKey,
    EnglishProductName,
    ListPrice
FROM dbo.DimProduct
WHERE ProductKey NOT IN (SELECT DISTINCT ProductKey FROM dbo.FactInternetSales)

--Using JOIN
USE AdventureWorksDW2019
SELECT 
    DP.Productkey,
    DP.EnglishProductName,
    DP.ListPrice
FROM DimProduct AS DP
LEFT JOIN FactInternetSales AS FIS ON FIS.ProductKey = DP.ProductKey
WHERE FIS.SaleAmount IS NULL 

--Using JOIN 
SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DP.ListPrice
FROM dbo.DimProduct AS DP 
LEFT JOIN dbo.FactInternetSales AS FIS 
ON DP.ProductKey = FIS.ProductKey
WHERE FIS.SalesOrderNumber IS NULL

/*Exercise 4: From DimDepartmentGroup table, 
Select DepartmentGroupKey column, DepartmentGroupName column, ParentDepartmentGroupKey column 
and execute self-join, take ParentDepartmentGroupName */ 

USE AdventureWorksDW2019
SELECT 
    Child.DepartmentGroupName,
    Parent.DepartmentGroupName AS ParentDepartmentGroupName
FROM DimDepartmentGroup AS Child
LEFT JOIN DimDepartmentGroup AS Parent
ON Child.ParentDepartmentGroupKey = Parent.DepartmentGroupKey

/*Exercise 5: From FactFinance, DimOrganization, DimScenario table, 
Select OrganizationKey column, OrganizationName column, Parent OrganizationKey column,
and execute self-join, take Parent OrganizationName, Amount that has 'Actual' in their ScenarioName. */ 


/* Using CTE to create a temporary table (Temp), Organization + ParentOrganization -> self join */
WITH Temp AS 
(SELECT 
    childT.OrganizationKey,
    childT.OrganizationName,
    childT.ParentOrganizationKey,
    parentT.OrganizationName AS ParentOrganizationName
FROM dbo.DimOrganization AS childT
LEFT JOIN dbo.DimOrganization AS parentT 
ON childDO.ParentOrganizationKey = parentDO.OrganizationKey)

SELECT 
    FF.OrganizationKey,
    T.OrganizationName,
    T.ParentOrganizationKey,
    T.ParentOrganizationName,
    FF.Amount
FROM dbo.FactFinance AS FF 
LEFT JOIN dbo.DimScenario AS DS ON FF.ScenarioKey = DS.ScenarioKey
LEFT JOIN Temp AS T ON FF.OrganizationKey = T.OrganizationKey
WHERE DS.ScenarioName = 'Actual'

/* Using JOIN */

SELECT 
    DO.OrganizationKey,
    DO.OrganizationName,
    PDO.OrganizationKey AS ParentOrganizationKey,
    PDO.OrganizationName AS ParentOrganizationName,
    FF.Amount
FROM dbo.FactFinance AS FF 
LEFT JOIN dbo.DimScenario AS DS ON DS.ScenarioKey = FF.ScenarioKey
LEFT JOIN dbo.DimOrganization AS DO ON FF.OrganizationKey = DO.OrganizationKey
LEFT JOIN dbo.DimOrganization AS PDO ON DO.ParentOrganizationKey = PDO.OrganizationKey
WHERE DS.ScenarioName = 'Actual'
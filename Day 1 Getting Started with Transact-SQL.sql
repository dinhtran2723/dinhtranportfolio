/* Lesson 1: Getting Started with Transact-SQL

Main Agenda: 
    - Using the SELECT Statment
    - Sorting and Limiting Query Results */

/* Ex1. Write a query select top 10 percent customer informartion.  
Retrieve CustomerKey, Title, Gender columns only - DimCustomer */

Use AdventureWorksDW2019
Select
    TOP 10 PERCENT
        CustomerKey,
        Title,
        Gender
From dbo.DimCustomer

/* Ex2: Select the fields below from table DimEmployee:
EmployeeKey, FirstName, LastName, MiddleName
Generate a new field named “FullName” which is equal to: FirstName + ' ' + LastName */

Use AdventureWorksDW2019
SELECT
    EmployeeKey,
    FirstName,
    LastName,
    FirstName + ' ' + LastName as 'Full_Name',
    MiddleName
FROM dbo.DimEmployee

/*Homework*/

/* Exercise 1: From AdventureworksDW2019 database, DimEployee table,

Take out EmployeeKey, FirstName,  LastName, BaseRate, VacationHours, SickLeaveHours 

Then add:

a. FullName column, generated from: FirstName + '  ' + LastName 

b. VacationLeavePay column, generated from: BaseRate * VacationHours 

c. SickLeavePay column, generated from: BaseRate * SickLeaveHours  

d.  TotalLeavePay column, generated from: VacationLeavePay + SickLeavePay  */

USE AdventureWorksDW2019
SELECT
    EmployeeKey,
    FirstName,
    LastName,
    FirstName + ' ' + LastName AS 'FullName',
    BaseRate,
    VacationHours,
    BaseRate*VacationHours AS 'VacationLeavePay',
    SickLeaveHours,
    BaseRate*SickLeaveHours AS 'SickLeavePay',
    BaseRate*VacationHours+BaseRate*SickLeaveHours AS 'TotalLeavePay'
FROM dbo.DimEmployee

/* Exercise 2: From AdventureworksDW2019, FactInternetSales table,  

Take SalesOrderNumber, ProductKey, OrderDate 

Then add:  

a. TotalRevenue column, generated from: OrderQuantity * UnitPrice  

b. TotalCost column, generated from: ProductStandardCost + DiscountAmount 

c. Profit column, generated from: TotalRevenue - TotalCost  

d. Profit Margin column, generated from: (TotalRevenue - TotalCost)/TotalRevenue * 100   */  

USE AdventureWorksDW2019
SELECT
    SalesOrderNumber,
    ProductKey,
    OrderDate,
    OrderQuantity*UnitPrice AS 'TotalRevenue',
    ProductStandardCost+DiscountAmount AS 'TotalCost',
    OrderQuantity*UnitPrice-ProductStandardCost+DiscountAmount AS 'Profit',
    ((OrderQuantity*UnitPrice-(ProductStandardCost+DiscountAmount))/(OrderQuantity*UnitPrice))*100 AS 'ProfitMargin'
FROM dbo.FactInternetSales

/* Exercise 3: From AdventureworksDW2019 database, FactProductInventory table,  MovementDate column, ProductKey column and,  

a. NoProductEOD column, generated from: UnitsBalance + UnitsIn - UnitsOut  

b. TotalCost column, generated from: NoProductEOD * UnitCost  */  

USE AdventureWorksDW2019
SELECT
    MovementDate,
    ProductKey,
    UnitsBalance,
    UnitsIn,
    UnitsOut,
    UnitsBalance+UnitsIn-UnitsOut AS 'NoProductEOD',
    UnitCost,
    (UnitsBalance+UnitsIn-UnitsOut)*UnitCost AS 'TotalCost'
FROM dbo.FactProductInventory

/* Exercise 4: From AdventureworksDW2019 database, DimGeography table, EnglishCountryRegionName column, City column, StateProvinceName column. 
Eliminate repeat row, organize the table following the EnglishCountryRegionName column's ascending order. 
For those rows that have the same country, organize them in City column's descending order */ 

USE AdventureWorksDW2019
SELECT
    DISTINCT EnglishCountryRegionName,
    City,
    StateProvinceName
FROM dbo.DimGeography
Order by EnglishCountryRegionName ASC, City DESC

/* Ex5: From AdventureworksDW2019 database, DimProduct table, EnglishProductName column, 
take top 10% of the products that has highest ListPrice */  

USE AdventureWorksDW2019
SELECT
    TOP 10 Percent
        EnglishProductName,
        ListPrice
FROM dbo.DimProduct
Order by ListPrice DESC
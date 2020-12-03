--*************************************************************************--
-- Title: Assignment07
-- Author: EUtama
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2020-12-02,EUtama,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_EUtama')
	 Begin 
	  Alter Database [Assignment07DB_EUtama] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_EUtama;
	 End
	Create Database Assignment07DB_EUtama;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_EUtama;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
'NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5 pts): What function can you use to show a list of Product names, 
-- and the price of each product, with the price formatted as US dollars?
-- Order the result by the product!

-- <Put Your Code Here> --
SELECT 
P.ProductName, 
Format(P.UnitPrice, 'C', 'en-US') as 'UnitPrice'
	FROM vProducts P
ORDER BY P.ProductName;
go

-- Question 2 (10 pts): What function can you use to show a list of Category and Product names, 
-- and the price of each product, with the price formatted as US dollars?
-- Order the result by the Category and Product!

-- <Put Your Code Here> --
SELECT 
C.CategoryName,
P.ProductName, 
Format(P.UnitPrice, 'C', 'en-US') as 'UnitPrice'
	FROM vCategories C 
		Inner Join vProducts P
			On C.CategoryID = P.CategoryID
ORDER BY  C.CategoryName, P.ProductName;
go

-- Question 3 (10 pts): What function can you use to show a list of Product names, 
-- each Inventory Date, and the Inventory Count, with the date formatted like "January, 2017?" 
-- Order the results by the Product, Date, and Count!

-- <Put Your Code Here> --
SELECT 
P.ProductName,
DateName(mm, I.InventoryDate) + ', ' + DateName(YYYY, I.InventoryDate) as 'InventoryDate',
I.[Count] as 'InventoryCount'
	FROM vProducts P
		Inner Join vInventories I
			On P.ProductID = I.ProductID
ORDER BY P.ProductName, I.InventoryDate, I.[Count]
go

-- Question 4 (10 pts): How can you CREATE A VIEW called vProductInventories 
-- That shows a list of Product names, each Inventory Date, and the Inventory Count, 
-- with the date FORMATTED like January, 2017? Order the results by the Product, Date,
-- and Count!

-- <Put Your Code Here> --
Create View vProductInventories
AS
    SELECT 
        P.ProductName,
        DateName(mm, I.InventoryDate) + ', ' + DateName(YYYY, I.InventoryDate) as 'InventoryDate',
        I.[Count] as 'InventoryCount'
	FROM vProducts P
		Inner Join vInventories I
			On P.ProductID = I.ProductID
go

-- Check that it works: 
Select * From vProductInventories
ORDER BY 1, MONTH(InventoryDate), 3;
go

-- Question 5 (15 pts): How can you CREATE A VIEW called vCategoryInventories 
-- that shows a list of Category names, Inventory Dates, 
-- and a TOTAL Inventory Count BY CATEGORY, with the date FORMATTED like January, 2017?

-- <Put Your Code Here> --
Create View vCategoryInventories
AS
    SELECT 
	    C.CategoryName,
        DateName(mm, I.InventoryDate) + ', ' + DateName(YYYY, I.InventoryDate) as 'InventoryDate',
        SUM([Count]) as 'InventoryCountByCategory'
    FROM vCategories C 
		Inner Join vProducts P
			On C.CategoryID = P.CategoryID
		Inner Join vInventories I
			On P.ProductID = I.ProductID
    GROUP BY 
    C.CategoryName,
    I.InventoryDate
go
-- Check that it works: 
Select * From vCategoryInventories as v2
ORDER BY 1, MONTH(InventoryDate), 3;
go

-- Question 6 (10 pts): How can you CREATE ANOTHER VIEW called 
-- vProductInventoriesWithPreviouMonthCounts to show 
-- a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month
-- Count? Use a functions to set any null counts or 1996 counts to zero. Order the
-- results by the Product, Date, and Count. This new view must use your
-- vProductInventories view!

-- <Put Your Code Here> --
Create View vProductInventoriesWithPreviouMonthCounts
AS
SELECT 
    v3.ProductName,
    v3.InventoryDate,
    v3.InventoryCount,
    IIF(v3.InventoryDate Like 'January%%', 0, IsNull(LAG(v3.InventoryCount) Over(Order By v3.ProductName, Year(v3.InventoryDate)),0)) as 'PreviousMonthCount'
	FROM vProductInventories as v3 
go

-- Check that it works: 
Select * From vProductInventoriesWithPreviouMonthCounts
ORDER BY 1, MONTH(InventoryDate), 3, 4;
go

-- Question 7 (15 pts): How can you CREATE one more VIEW 
-- called vProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month 
-- Count and a KPI that displays an increased count as 1, 
-- the same count as 0, and a decreased count as -1? Order the results by the Product, Date, and Count!

-- <Put Your Code Here> --
Create View vProductInventoriesWithPreviousMonthCountsWithKPIs
AS
SELECT 
    v4.ProductName,
    v4.InventoryDate,
    v4.InventoryCount,
    v4.PreviousMonthCount,
    case 
        when v4.InventoryCount > v4.PreviousMonthCount then 1
        when v4.InventoryCount = v4.PreviousMonthCount then 0
        when v4.InventoryCount < v4.PreviousMonthCount then -1
    End as 'CountVsPreviousCountKPI'
FROM vProductInventoriesWithPreviouMonthCounts as v4
go 

-- Check that it works: 
Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs
ORDER BY 1, MONTH(InventoryDate), 3;
go

-- Question 8 (25 pts): How can you CREATE a User Defined Function (UDF) 
-- called fProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month
-- Count and a KPI that displays an increased count as 1, the same count as 0, and a
-- decreased count as -1 AND the result can show only KPIs with a value of either 1, 0,
-- or -1? This new function must use you
-- ProductInventoriesWithPreviousMonthCountsWithKPIs view!
-- Include an Order By clause in the function using this code: 
-- Year(Cast(v1.InventoryDate as Date))
-- and note what effect it has on the results.

-- <Put Your Code Here> --
Create Function fProductInventoriesWithPreviousMonthCountsWithKPIs(@CountVsPreviousCountKPI int)
 Returns Table 
 AS 
   Return(
   Select 
        ProductName,
        InventoryDate,
        InventoryCount,
        PreviousMonthCount,
        CountVsPreviousCountKPI
    From vProductInventoriesWithPreviousMonthCountsWithKPIs 
	 Where CountVsPreviousCountKPI = @CountVsPreviousCountKPI
   );
GO

/* Check that it works:*/
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1)
ORDER BY 1, Year(Cast(InventoryDate as Date)), 3;
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0)
ORDER BY 1, Year(Cast(InventoryDate as Date)), 3;
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1)
ORDER BY 1, Year(Cast(InventoryDate as Date)), 3;

go

/***************************************************************************************/
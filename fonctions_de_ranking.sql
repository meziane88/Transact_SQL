----- Les fonctions de RANKING
--=================================================
USE AdventureWorks2014
GO

----- La clause OVER avec le PARTITION BY 
	-- Fonctionne seulement avec SELECT et ORDER BY 
SELECT customerid, salesorderid, orderdate, 
ROW_NUMBER() over( order by customerid) as rownumber
from [Sales].[SalesOrderHeader]

SELECT customerid, salesorderid, orderdate, 
ROW_NUMBER() over( order by orderdate) as rownumber
from [Sales].[SalesOrderHeader]

SELECT customerid, salesorderid, orderdate, 
ROW_NUMBER() over( order by customerid, orderdate) as rownumber
from [Sales].[SalesOrderHeader]

SELECT customerid, salesorderid, orderdate, 
ROW_NUMBER() over(partition by customerid order by salesorderid ) as rownumber
from [Sales].[SalesOrderHeader]

SELECT customerid, salesorderid, orderdate, 
ROW_NUMBER() over(partition by orderdate, customerid order by salesorderid ) as rownumber
from [Sales].[SalesOrderHeader]

----- Les Ranking functions (fonctions de classement)

	----- ROW_NUMBER
SELECT sod.productid, soh.salesorderid,
	FORMAT(soh.orderdate,'yyyy-MM-dd') as orderdate,
	ROW_NUMBER() over(partition by sod.productid order by soh.salesorderid) as rownum
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod 
on soh.SalesOrderID = sod.SalesOrderID
where sod.ProductID between 710 and 720
order by sod.ProductID, soh.SalesOrderID

	----- ROW_NUMBER -- RANK -- DENSE_RANK
SELECT sod.productid, soh.salesorderid,
	FORMAT(soh.orderdate,'yyyy-MM-dd') as orderdate,
	ROW_NUMBER() over(partition by sod.productid order by soh.orderdate) as ROW_NUM_COL,
	RANK() over(partition by sod.productid order by soh.orderdate) as RANK_COL,
	DENSE_RANK() over(partition by sod.productid order by soh.orderdate) as DENSE_RANK_COL
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod 
on soh.SalesOrderID = sod.SalesOrderID
where sod.ProductID between 710 and 720
order by sod.ProductID, soh.SalesOrderID

----- NTILE
WITH sales as (
	select sod.productid, COUNT(*) as ordercount
	from Sales.SalesOrderHeader soh
	join Sales.SalesOrderDetail sod
	on soh.SalesOrderID = sod.SalesOrderID
	group by sod.ProductID)
select productid, ordercount,
NTILE(10) over(order by ordercount) as bucket
from sales

----- Exemple
with orders as (
SELECT sod.productid, soh.salesorderid,
	FORMAT(soh.orderdate,'yyyy-MM-dd') as orderdate,
	ROW_NUMBER() over(partition by sod.productid order by soh.salesorderid) as rownum
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod 
on soh.SalesOrderID = sod.SalesOrderID
where soh.OrderDate >= '2011-01-01' and soh.OrderDate <'2012-01-01')
select * from orders where rownum <= 4

----- Exemple
with sales as(
select		SUM(totaldue) as totalsales,
			customerid
from Sales.SalesOrderHeader
	where OrderDate >= '2014-01-01' and OrderDate < '2015-01-01'
	group by customerid
	) 
select totalsales, customerid, NTILE(4) over(order by totalsales) as classement, 
	case 
	when NTILE(4) over(order by totalsales) = 1 then 'a'
	when NTILE(4) over(order by totalsales) = 2 then 'b'
	when NTILE(4) over(order by totalsales) = 3 then 'c'
	when NTILE(4) over(order by totalsales) = 4 then 'd'
	end as indication
from sales

with sales as(
select		SUM(totaldue) as totalsales,
			customerid
from Sales.SalesOrderHeader
	where OrderDate >= '2014-01-01' and OrderDate < '2015-01-01'
	group by customerid
	), 
classe as(
	select totalsales, customerid, 
	NTILE(3) over(order by totalsales) as classement
	from Sales
)
select totalsales, customerid, 
	CHOOSE(classement, 'vendeur mediocre', 'vendeur en progression', 'meilleur vendeur')
	as customercategory 
from classe



----- L'agregation avec les fonctions de ranking 
select productid, name, listprice, finishedgoodsflag
from production.product
	--- 
SELECT Productid, name, listprice,
	COUNT(*) over() as contofproduct, 
	AVG(listprice) over() as avglistprice
from Production.Product
where FinishedGoodsFlag = 1


select p.productid,p.name as productname, 
		c.name as categoruname, listprice,
		COUNT(*) over(partition by p.productid) as countofproduct,
		AVG(listprice) over(partition by p.productid) as avglistprice,
		min(listprice) over(partition by p.productid) as minlistprice,
		max(listprice) over(partition by p.productid) as maxlistprice
from Production.Product as p
join Production.ProductSubcategory as s 
	on s.ProductCategoryID = p.ProductSubcategoryID
join production.productcategory as c 
	on c.productcategoryid = s.ProductCategoryID
where FinishedGoodsFlag = 1


----- Les fonction analytiques LAG et LEAD
	--- LEAD accède aux données à partir d'une ligne ultérieure dans le même jeu de réxultats 
select BusinessEntityID, YEAR(quotadate) as salesyear, salesquota as quota_effectif,
	LEAD(salesquota, 1, 0) over(order by year(quotadate)) as quota_suivant
from Sales.SalesPersonQuotaHistory
where BusinessEntityID = 275

	--- LAG accède aux données d'une ligne précédente dans le même jeu de résultats  
select BusinessEntityID, YEAR(quotadate) as salesyear, salesquota as quota_effectif,
	LAG(salesquota, 1, 0) over(order by year(quotadate)) as quota_suivant
from Sales.SalesPersonQuotaHistory
where BusinessEntityID = 275


----- ROWS / RANGE UNBOUNDED PRECEDING /FOLLOWING
	--- 

SELECT businessentityid as salespersonid, SUM(cast([rate] as decimal(10,0))) as salaire 
from [HumanResources].[EmployeePayHistory]
where BusinessEntityID <= 10 
group by [rate], BusinessEntityID, ModifiedDate order by 1 

with cte as (
SELECT businessentityid as salespersonid, SUM(cast([rate] as decimal(10,0))) as salaire, 
		[modifieddate] as saldate
from [HumanResources].[EmployeePayHistory]
where BusinessEntityID <= 10 
group by [Rate] , BusinessEntityID, ModifiedDate 
)
select salespersonid, saldate, salaire, 
SUM(salaire) over (order by salespersonid rows unbounded preceding) as cumulativesumby_rows,
SUM(salaire) over (order by salespersonid range unbounded preceding) as cumulativesumby_ranges
from cte 
order by salespersonid, saldate

	--- Faire le même calcul dans l'ordre inverse 

with ct as (
SELECT businessentityid as salespersonid, SUM(cast([rate] as decimal(10,0))) as salaire, 
		[modifieddate] as saldate
from [HumanResources].[EmployeePayHistory]
where BusinessEntityID <= 10 
group by [Rate] , BusinessEntityID, ModifiedDate 
)
select salespersonid, saldate, salaire, 
	SUM(salaire) over(order by salespersonid rows between current row and unbounded following) as 
	reversecumulativesumbyrows,
	sum(salaire) over(order by salespersonid range between current row and unbounded following) as 
	reversecumulativesumbyrange
from ct 
order by salespersonid, saldate

with c as (
SELECT businessentityid as salespersonid, SUM(cast([rate] as decimal(10,0))) as salaire, 
		[modifieddate] as saldate
from [HumanResources].[EmployeePayHistory]
where BusinessEntityID <= 10 
group by [Rate] , BusinessEntityID, ModifiedDate 
)
select salespersonid, saldate, salaire, 
SUM(salaire) over (order by salespersonid rows between 1 preceding and 1 following) as 
MovingSumByRowsPreCurrentNext, -- la ligne precedente et la ligne suivante
SUM(salaire) over (order by salespersonid rows between current row and 2 following) as 
MovingSumByRowsCurrentNext2 -- ligne actuelle et les deux suivantes 
from c
order by salespersonid, saldate



----- Les fonctions analytiques FIRST_VALUE et LAST_VALUE
	--- FIRST_VALUE retourne la première valeur dans un jeu de valeurs ordonné
	--- LAST_VALUE	retourne la dernière valeur dans un jeu de valeurs ordonné 
select customerid, CAST(orderdate as date) as orderdate, 
	salesorderid, totaldue,
	FIRST_VALUE(totaldue) over(partition by customerid order by salesorderid) as FirstOrderTotal,
	LAST_VALUE(totaldue) over(partition by customerid order by salesorderid
	rows between current row and unbounded following) as LastOrderTotal
from Sales.SalesOrderHeader order by CustomerID, TotalDue desc
----- Autres fonctions 
--============================================================

USE BDD1
GO
 ----- OFFSET -- après ORDER BY
	-- indique le nombre de lignes à ignorer 

SELECT * FROM contact ORDER BY nom OFFSET 10 ROWS  -- ignore les 10 premières lignes 
SELECT * FROM contact ORDER BY nom 

----- FETCH NEXT ROWS -- après ORDER BY
	-- indique le nombre de lignes à retourner après le traitement de la clause OFFSET 
SELECT * FROM contact ORDER BY nom OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY -- saute les 5 premières lignes et affiche les 5 suivantes
SELECT * FROM contact ORDER BY nom 

-----  DROP IF EXISTS 
CREATE TABLE test(id int)
SELECT * FROM sys.TABLES
DROP TABLE IF EXISTS dbo.test 
SELECT * FROM sys.TABLES

----- Le merge 
Use AdventureWorks2014
go
	--- Création de deux tables simples
IF OBJECT_ID ('BookOrder', 'U') IS NOT NULL
DROP TABLE dbo.BookInventory;

CREATE TABLE dbo.BookInventory  -- target
(
  TitleID INT NOT NULL PRIMARY KEY,
  Title NVARCHAR(100) NOT NULL,
  Quantity INT NOT NULL
    CONSTRAINT Quantity_Default_1 DEFAULT 0
);
 
IF OBJECT_ID ('BookOrder', 'U') IS NOT NULL
DROP TABLE dbo.BookOrder;
 
CREATE TABLE dbo.BookOrder  -- source
(
  TitleID INT NOT NULL PRIMARY KEY,
  Title NVARCHAR(100) NOT NULL,
  Quantity INT NOT NULL
    CONSTRAINT Quantity_Default_2 DEFAULT 0
);
 
INSERT BookInventory VALUES
  (1, 'The Catcher in the Rye', 6),
  (2, 'Pride and Prejudice', 3),
  (3, 'The Great Gatsby', 0),
  (5, 'Jane Eyre', 0),
  (6, 'Catch 22', 0),
  (8, 'Slaughterhouse Five', 4);
 
INSERT BookOrder VALUES
  (1, 'The Catcher in the Rye', 3),
  (3, 'The Great Gatsby', 0),
  (4, 'Gone with the Wind', 4),
  (5, 'Jane Eyre', 5),
  (7, 'Age of Innocence', 8);

  select * from BookInventory
  select * from BookOrder

  select bi.TitleID, bi.Quantity from BookInventory bi 
  inner join BookOrder  bo 
  on bi.TitleID = bo.TitleID

  merge 
  into -- facultatif
  bookinventory bi -- table de destination
  using bookorder bo -- table source
  on bi.titleid = bo.titleid --jointure sur les deux table
  when matched then -- quand ca matche
	update 
	set bi.quantity = bo.quantity + bi.quantity;

select bi.TitleID, bi.Quantity from BookInventory bi 
  inner join BookOrder  bo 
  on bi.TitleID = bo.TitleID

merge bookinventory bi 
using bookorder bo
on bi.titleid = bo.titleid
when matched 
	and bi.quantity + bo.quantity = 0 then
	delete
when not matched then 
	insert(titleid, title, quantity)
	values(bo.titleid, bo.title, bo.quantity);

select bi.TitleID, bi.Quantity from BookInventory bi 
inner join BookOrder  bo 
on bi.TitleID = bo.TitleID
select * from BookInventory

----- CASE WHEN 
USE BDD1
GO
SELECT *FROM contact 

SELECT *, 
CASE 
WHEN sexe = 'f' then 'mme'
WHEN sexe = 'm' then 'mr'
END AS sexe_1
FROM contact 

SELECT *, 
CASE 
WHEN sexe = 'f' then 0
WHEN sexe = 'm' then 1
END AS sexe_1
FROM contact 

select *, 
case 
when age between 16 and 20 then 'vive la jeunesse' else 'on a plus 20 ans :)'
end
from contact

----- CHOOSE
SELECT CHOOSE(1, 'france', 'belgique', 'angleterre') as pays -- retourne le premier élément de la liste de valeurs fournie
SELECT CHOOSE(2, 'france', 'belgique', 'angleterre') as pays -- le deuxième élément 

select date_de_naissance, CHOOSE(datepart(month, date_de_naissance), 
	'Janvier', 'Fevrier', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Aout',
	'Septembre', 'Octobre', 'Novembre', 'Decembre') as mois_naissance
From contact

declare @index as int = 3 
select CHOOSE(@index, 'a', 'b', 'c')

----- IIF 
	--- Sythaxe : IIF(boolean_expression, true_value, false_value)
select iif(sexe = 'f', 0,1) as sexe_b, sexe from contact

------ COALESCE 
	-- Evalue les arguments dans l'ordre et retourne la prmière valeur qui ne prend pas la valeur NULL 
SELECT COALESCE(NULL, 1,2)

create table personne (nom varchar (200), telephone_pro int,telephone_person int, telephone_maison int)

insert into personne values 
('olivier',0644332266,0721365489,01243569874),
('bruno',NULL,0621365477,01243569874),
('Alain',NULL,NULL,01243569874)

-- Que donne le select ? 

select * from personne

-- et avec coalesce

select nom, coalesce (telephone_pro,telephone_person,telephone_maison) as Numero_de_telephone
from personne

----- IF ELSE
IF DATENAME(weekday, GETDATE()) IN (N'Saturday', N'Sunday')
       SELECT 'Weekend';
ELSE 
       SELECT 'Weekday';

----- WAITFOR 
	-- Bloque l'exécution d'un traitement, d'une procédure stockée ou d'une tranxaction 
	-- jusqu'à ce que l'heure ou l'intervalle de temps spécifié soit atteint
begin 
waitfor delay'00:00:05'
select * from contact
end
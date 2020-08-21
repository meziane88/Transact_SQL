--------- Partie 1 : Transact Sql

----- Cr�ation d'une base de donn�es
CREATE DATABASE BDD1
USE BDD1

----- Modification d'une base de donn�es 
ALTER DATABASE BDD1 MODIFY NAME = BDD2			
DROP DATABASE BDD2


----- Cr�ation d'une table 
CREATE DATABASE BDD1
USE BDD1
CREATE TABLE ma_table (nom varchar(200), prenom varchar(200))

----- Renommer une table 								
SP_RENAME 'ma_table', 'ma_table1'	

----- Supprission d'une table
DROP TABLE ma_table1							

----- Insertion des donn�es
CREATE TABLE nom (nom varchar(200), prenom varchar(200))
INSERT INTO nom VALUES ('Meziane', 'Smail'), ('Chakif', 'Moustafa')

--- Insertion de plusieurs valeurs identiques d'un seul coup 
CREATE TABLE classique (ID int)
INSERT INTO classique VALUES (1)
go 10
SELECT * FROM classique 

-----S�lectionner des donn�es 
--- S�lectionner toute la table
SELECT * FROM nom

--- S�lectionner un colonne 
SELECT nom FROM nom
SELECT prenom FROM nom

--- Changer l'ordre des colonnes
SELECT prenom, nom FROM nom

----- Filtrer des donn�es
SELECT * FROM nom WHERE nom = 'Meziane'

----- Mettre � jour les donn�es 
UPDATE nom SET prenom = 'Lounis' WHERE nom = 'Meziane'
UPDATE nom SET nom = 'Chafik' WHERE nom = 'Chakif'
SELECT * FROM nom 

--- Mettre � jour sur deux colonnes 
UPDATE nom SET nom = 'Razi', prenom = 'Farid' WHERE nom = 'Meziane'
SELECT * FROM nom

----- Supprimer des valeurs 
DELETE FROM  nom WHERE nom = 'Razi' 
SELECT * FROM nom 

---------------------------------------------------------------------------------

----- Renommer les colonnes avec les ALIAS 
CREATE TABLE contact (
						nom VARCHAR(200), 
						prenom VARCHAR(200),
						age INT, 
						sexe CHAR(1),
						date_de_naissance DATE
						)
INSERT INTO contact VALUES 
('Marchand','Elisabeth',18,'F','04-08-1976'),
('Truchon','Melanie',16,'F','04-08-1978'),
('Teslu','Sandrine',17,'F','02-05-1987'),
('Portail','Bruno',23,'M','06-05-1970'),
('Virenque','Michel',22,'M','02-08-1983'),
('Dutruel','Pascal',22,'M','02-08-1983'),-- meme age que Virenque michel
('Virenque','Micheline',37,'M','02-08-1975'),
('Fournillet','Alain',22,'M','01-01-1983'),
('Faurnillet','Pascal',48,'M','12-06-1960'),
('Boutin','Ludivine',47,'F','22-01-1965'),
('Delors','Valerie',28,'M','24-09-1978'),
('Thuillier','olivier',41,'M','12-08-1976'),
('Chuillier','olivier',41,'M','12-08-1976'),
('Meilhac','Amelie',34,'F','08-05-1983'),
('Boutin','Ludivine',47,'F','22-01-1965')-- deux fois la meme valeur dans la table, c'est un doublon

SELECT * FROM contact

--- Renommer le nom d'une colonne 
SELECT nom AS surnom FROM contact

--- Renommer plusieurs colonne � la fois 
SELECT nom AS A, prenom AS B, age AS C FROM contact 

----- L'op�rature LIKE 
--- Selectionner toutes les valeurs qui commencent par une valeur
SELECT * FROM contact WHERE age  LIKE '2%'

--- S�lectionner toutes les valeurs qui terminent par une valeur
SELECT * FROM contact WHERE age LIKE '%8'

--- S�lectionner toutes les valeurs qui contiennent une certaine valeur 
SELECT * FROM contact WHERE nom LIKE '%a%'

--- S�lecionner toutes les valeurs qui se resemblent et diff�rent seulement par une valeur
SELECT *FROM  contact WHERE nom LIKE 'F[ao]urnillet'

----- S�lectionner un certain nombre de lignes avec TOP
SELECT TOP(5) * FROM contact
SELECT TOP 2 prenom FROM contact 

----- Enlever les doublons 
SELECT DISTINCT * FROM contact  
SELECT DISTINCT nom FROM contact 

----- Copier une table - permet de cr�er une nouvelle table
SELECT nom, prenom INTO contact_2 FROM contact
SELECT * FROM contact_2
SELECT * INTO contact_3 FROM contact WHERE nom = 'Virenque'
SELECT * FROM contact_3

----- Le tris des donn�es avec ORDER BY
SELECT * FROM contact ORDER BY age ASC -- de plus petit au plus grand (le tris par defaut)
SELECT * FROM contact ORDER BY age DESC -- de plus grand au plus petit 
SELECT * FROM contact ORDER BY nom -- tris selon un ordre alphabitique
SELECT * FROM contact ORDER BY YEAR(date_de_naissance)
SELECT * FROM contact ORDER BY MONTH(date_de_naissance)
SELECT * FROM contact ORDER BY DAY(date_de_naissance)

----- L'op�rateur BETWEEN 
SELECT * FROM contact WHERE age BETWEEN 16 AND 33
SELECT * FROM contact WHERE age NOT BETWEEN 16 AND 33 ORDER BY age 
SELECT * FROM contact WHERE YEAR(date_de_naissance) BETWEEN 1976 AND 1983 ORDER BY date_de_naissance 

-----  Regroupement des donn�es avec GROUP BY 
SELECT COUNT(*) AS Total FROM contact WHERE sexe = 'M'
SELECT COUNT(*) AS Total, sexe FROM contact GROUP BY sexe 

--- Nombre de personne de sexe masculin et qui son naient en 1976?
SELECT COUNT(*) AS TOTAL, sexe, date_de_naissance FROM contact 
WHERE sexe = 'M' AND YEAR(date_de_naissance) = 1976
GROUP BY sexe, date_de_naissance

--- Nombre de personne selon le sexe ?
SELECT COUNT(*), sexe FROM contact 
GROUP BY sexe

--- Nombre de personne selon le sexe et l'ann�e de naissance? 
SELECT COUNT(*), sexe, YEAR(date_de_naissance)  FROM contact
GROUP BY sexe, YEAR(date_de_naissance)
SELECT COUNT(*),YEAR(date_de_naissance),sexe FROM contact
GROUP BY YEAR(date_de_naissance), sexe

----- L'op�rateur HAVING 
--- Nombre de personne de sexe masculins et qui ont entre 20 et 25 ans ?
SELECT COUNT(*), sexe, age FROM contact
WHERE sexe = 'M' AND age BETWEEN 20 AND 25 
GROUP BY sexe, age 

--- et qui ont un total superieur ou egale 3
SELECT COUNT(*) AS Total, sexe, age FROM contact 
WHERE sexe = 'M'	AND age BETWEEN 20 AND 25
GROUP BY sexe, age 
HAVING COUNT(*) >=3

----- La commande print 
SELECT * FROM contact 
PRINT 'Selection de la table ok'

----- Les fonctions d'agregation 
SELECT MIN(age)	FROM contact
SELECT MAX(age) FROM contact
SELECT AVG(age) FROM contact WHERE YEAR(date_de_naissance) = 1976
SELECT MAX(nom) FROM contact

SELECT SUM(age) FROM contact
SELECT SUM(1) FROM contact WHERE sexe = 'F' -- nombre de femme 

SELECT COUNT(*) FROM contact
SELECT COUNT(*) FROM contact WHERE nom LIKE '%a%'
SELECT COUNT(DISTINCT prenom) FROM contact
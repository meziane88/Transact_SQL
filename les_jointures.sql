----- Les Jointures sur Sql 
------------------------------------------------------------------------------------

USE BDD1
GO

create table commande (Numerodecommande int,IDclient int)
insert into commande values 
('3712',1),
('4851',2),
('6712',3),
('3215',4),
('3218',5),
('3220',6),
('3221',7),
('3227',8),
('3238',9)
SELECT * FROM commande

create table client (
			nom varchar (200),
			prenom varchar (200), 
			IDclient int, 
			adresse varchar(2000),
			ville varchar(200))
insert into client values 
('Thuillier','Olivier',1,'7 Rue poirier','Dreux'),
('Thuillier','Luc',3,'78 avenue de paris','Paris'),
('Thuillier','Théodore',5,'15 Rue asterdam','Asterdam'),
('Thuillier','Zinédine',12,'7 Rue Prague','Prague'),
('Thuillier','Lucas',13,'7 Rue Vienne','Vienne')

SELECT * FROM client
SELECT * FROM commande
----- INNER JOIN -- affiche que les élements communs entre les deux tableaux
SELECT * FROM client cl 
INNER JOIN commande cm 
on cl.IDclient = cm.IDclient

SELECT 
cm.Numerodecommande, 
cm.IDclient,
cl.ville, 
cl.adresse, 
cl.IDclient,
cl.prenom, cl.nom 
FROM client cl 
INNER JOIN commande cm 
on cl.IDclient = cm.IDclient

----- LEFT JOIN 
	-- prend toutes les lignes de la table client et cherche les correspendence avec la table commande
	-- si pas de correspendence entre les deux, les lignes des colonnes de la table commande seront null
SELECT * FROM client cl 
LEFT JOIN commande cm 
ON cl.IDclient = cm.IDclient

SELECT * FROM client cl 
LEFT JOIN commande cm 
ON cl.IDclient = cm.IDclient
WHERE cm.IDclient IS NOT NULL

SELECT * FROM client cl 
LEFT JOIN commande cm 
ON cl.IDclient = cm.IDclient
WHERE cm.IDclient IS NULL

----- RIGHT JOIN
	-- prend toutes les lignes de la table COMMANDE et cherche les correspendence avec la table CLIENT
	-- si pas de correspendence entre les deux, les lignes des colonnes de la table CLIENT seront null
SELECT * FROM client cl 
RIGHT JOIN commande cm 
on cl.IDclient = cm.IDclient

----- FULL OUTER JOIN 
	-- prend toutes les lignes possibles 
	-- si pas de correspendance les cellules seront marquées null
SELECT * FROM client cl 
FULL OUTER JOIN commande cm 
on cl.IDclient = cm.IDclient

----- CROSS JOIN -- produit cartésien entre deux tables 
SELECT * FROM client cl
CROSS JOIN commande cm

SELECT * FROM commande cm 
CROSS JOIN client cl 

----- Jointure sur plusieurs tables
Create table carte_fidelité (Fidele char(3), IDCLIENT int)

insert into carte_fidelité values 
('OUI', 1),
('OUI', 2),
('NON', 3),
('OUI', 4),
('NON', 5),
('OUI', 6),
('NON', 7),
('OUI', 8),
('OUI', 9),
('NON', 10),
('OUI', 11),
('NON', 12)

SELECT * FROM commande cm
INNER JOIN client cl 
ON cm.IDclient = cl.IDclient
INNER JOIN carte_fidelité cf 
on cl.IDclient = cf.IDCLIENT
WHERE cf.Fidele = 'oui'

----- NOT IN
SELECT * FROM client
WHERE IDclient NOT IN 
(SELECT IDclient FROM commande)

SELECT * FROM client cl 
LEFT JOIN commande cm 
ON cl.IDclient = cm.IDclient
WHERE cm.IDclient IS NULL

SELECT * FROM commande
WHERE IDclient NOT IN 
(SELECT IDclient FROM client)

SELECT cm.Numerodecommande, cm.IDclient FROM commande cm 
LEFT JOIN client cl 
ON cm.IDclient = cl.IDclient
WHERE cl.IDclient IS NULL

----- NOT EXISTS
SELECT * FROM client cl 
WHERE NOT EXISTS 
(SELECT * FROM commande cm 
WHERE cl.IDclient = cm.IDclient)

SELECT * FROM commande cm 
WHERE NOT EXISTS 
(SELECT * FROM client cl 
WHERE cm.IDclient = cl.IDclient)


----- UPDATE avec les jointures
CREATE TABLE T1 (Colonne1 INT,Colonne2 VARCHAR(100))
INSERT INTO T1 (Colonne1,Colonne2) 
values (2,'Second'),
(3,'troisieme'),
(4,'Quatrieme')

CREATE TABLE T2 (Colonne1 INT,Colonne2 VARCHAR(100))
INSERT INTO T2 (Colonne1,Colonne2) 
values (1,'Premier'),
(2,'Second'),
(3,'Cinquieme'),
(4,'Sixieme')		

SELECT * FROM T1
SELECT * FROM T2

UPDATE T2 
SET Colonne2 = T1.Colonne2
FROM T1 t1
INNER JOIN T2 t2 
ON t1.Colonne1 = t2.Colonne1
WHERE t2.Colonne1 IN (3,4)

----- Les Hints dans les Jointures -- des options sur les jointures -- en général sql se charge de choix
--- HASH 
SELECT * FROM client CL 
INNER HASH JOIN commande CM 
ON CL.IDclient = CM.IDclient

--- MERGE
SELECT * FROM client CL 
INNER MERGE JOIN commande CM 
ON CL.IDclient = CM.IDclient

--- LOOP
SELECT * FROM client CL 
INNER LOOP JOIN commande CM 
ON CL.IDclient = CM.IDclient

----- INTERSECT -- comme un INNER JOIN 
SELECT IDclient FROM client
INTERSECT
SELECT IDclient FROM commande

----- EXECPT -- comme un LEFT JOIN 
SELECT IDclient FROM client
EXCEPT 
SELECT IDclient FROM commande

----- CROSS APPLY -- jointure interne (INNER JOIN)
SELECT * FROM client CL 
CROSS APPLY ( 
SELECT * FROM commande CM
WHERE CL.IDclient = CM.IDclient)
B

----- OUTER APPLY -- jointure externe (LEFT JOIN)
SELECT * FROM client CL 
OUTER APPLY (
SELECT * FROM commande CM 
WHERE CL.IDclient = CM.IDclient)
A

----- CTE Exemple simple

USE BDD1
GO
CREATE TABLE dbo.TB_DEPARTEMENTS ( 
  ID_DEPARTEMENT  INT PRIMARY KEY 
, NOM_DEPARTEMENT VARCHAR( 50 ) ); 
GO 
  
CREATE TABLE dbo.TB_EMPLOYES ( 
  ID_EMPLOYE      INT PRIMARY KEY 
, NOM_EMPLOYE     VARCHAR( 50 ) NOT NULL 
, AGE_EMPLOYE     INT 
, DEPARTEMENT_ID  INT 
, SALAIRE_EMPLOYE MONEY ); 
GO 
  
INSERT INTO dbo.TB_DEPARTEMENTS 
VALUES( 1, 'Administration'       ); 
INSERT INTO dbo.TB_DEPARTEMENTS 
VALUES( 2, 'Ressources Humaines'  ); 
INSERT INTO dbo.TB_DEPARTEMENTS 
VALUES( 3, 'Service Informatique' ); 
INSERT INTO dbo.TB_DEPARTEMENTS 
VALUES( 4, 'Comptabilité'         ); 
  
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 1, 'Georges', 74, 4, 2480.3 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 2, 'Pierre' , 17, 3, 1387.2 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 3, 'Bernard', 63, 1, 3499.8 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 4, 'John'   , 23, 3, 1876.9 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 5, 'Jérome' , 45, 2, 2286.6 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 6, 'Lina', 30, 3, 2230.4 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 7, 'Marie', 26, 3, 1980.4 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 8, 'Virginie', 37, 3, 2730.4 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES( 9, 'Héléne', 33, 3, 2430.4 ); 
INSERT INTO dbo.TB_EMPLOYES 
VALUES ( 10, 'Yuva', 28, 3, 2200.2 );
GO
SELECT * FROM TB_DEPARTEMENTS
SELECT * FROM TB_EMPLOYES

GO
;
--- les gens entre 20 et 40 et qui ont un salaire de plus de 2000 euros

SELECT nom_employe, age_employe 
FROM (
        SELECT nom_employe, age_employe, departement_id, salaire_employe
        FROM TB_EMPLOYES
        WHERE AGE_EMPLOYE BETWEEN 20 AND 40) 
        TD -- TABLE DERIVEE 
        INNER JOIN TB_DEPARTEMENTS D 
        ON TD.DEPARTEMENT_ID = D.ID_DEPARTEMENT
        WHERE SALAIRE_EMPLOYE > 2000
;
GO
SELECT nom_employe, age_employe FROM TB_EMPLOYES WHERE AGE_EMPLOYE BETWEEN 20 AND 40 AND SALAIRE_EMPLOYE > 2000;

SELECT e.nom_employe, e.age_employe, d.nom_departement 
FROM TB_EMPLOYES e 
INNER JOIN TB_DEPARTEMENTS d 
ON e.DEPARTEMENT_ID = d.ID_DEPARTEMENT
WHERE e.AGE_EMPLOYE BETWEEN 20 AND 40 AND e.SALAIRE_EMPLOYE > 2000
 
;
WITH cte 
AS 
(
    SELECT nom_employe, age_employe, departement_id, salaire_employe, NOM_DEPARTEMENT
    FROM TB_EMPLOYES e 
    INNER JOIN TB_DEPARTEMENTS d 
    ON e.DEPARTEMENT_ID = d.ID_DEPARTEMENT
    WHERE AGE_EMPLOYE BETWEEN 20 AND 40
)
SELECT nom_employe, age_employe FROM cte WHERE salaire_employe > 2000
;

----- Le point virgule dans le CTE
--================================

        -- il faut séparer le cte au début et à la fin avec un point virgule

----- Obligation de rajouter les colonnes dans les CTE
;
WITH cte 
(nom_employe, age_employe, departement_id, salaire_employe, NOM_DEPARTEMENT, [e.DEPARTEMENT_ID])
AS 
(
    SELECT nom_employe, age_employe, departement_id, salaire_employe, NOM_DEPARTEMENT, e.DEPARTEMENT_ID
    -- Erreure : La colonne 'DEPARTEMENT_ID' a été spécifiée plusieurs fois pour 'cte'
    FROM TB_EMPLOYES e 
    INNER JOIN TB_DEPARTEMENTS d 
    ON e.DEPARTEMENT_ID = d.ID_DEPARTEMENT
    WHERE AGE_EMPLOYE BETWEEN 20 AND 40
)
SELECT nom_employe, age_employe, departement_id, salaire_employe, NOM_DEPARTEMENT, [e.DEPARTEMENT_ID]
FROM cte WHERE salaire_employe > 2000
;


----- Plusieurs SELECT dans le CTE
--================================
    -- on peut mettre plusieurs requetes   SELECT dans le même CTE en utilisant le mots UNION
    -- pour les query multiple au sein du CTE on peur mettre UNION ALL, UNION, INTERSET, EXEPT
;
WITH cte 
AS 
(
    SELECT nom_employe, age_employe, departement_id, salaire_employe, NOM_DEPARTEMENT
    FROM TB_EMPLOYES e 
    INNER JOIN TB_DEPARTEMENTS d 
    ON e.DEPARTEMENT_ID = d.ID_DEPARTEMENT
    WHERE AGE_EMPLOYE BETWEEN 20 AND 40
UNION 
    SELECT nom_employe, age_employe, departement_id, salaire_employe, NOM_DEPARTEMENT
    FROM TB_EMPLOYES e 
    INNER JOIN TB_DEPARTEMENTS d 
    ON e.DEPARTEMENT_ID = d.ID_DEPARTEMENT
    WHERE AGE_EMPLOYE BETWEEN 20 AND 40
)
SELECT nom_employe, age_employe FROM cte WHERE salaire_employe > 2000
;
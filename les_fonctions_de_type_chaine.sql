----- Les fonctions de type chiane 
------------------------------------------------------------------------------------
USE BDD1
----- La fonction SUBSTRING 
--- Prendre la premi�re lettre du prenom 
SELECT nom, SUBSTRING(prenom, 1, 1) as initial, prenom FROM contact

--- Prendre les trois prmi�res lettres du prenom 
SELECT nom, SUBSTRING(prenom, 1,3)as initial, prenom FROM contact

--- Prendre la deuxi�me et la trois�me lettre du prenom 
SELECT nom, SUBSTRING(prenom, 2,2) as initial, prenom FROM contact

----- TRIM LTRIM RTRIM UPPER et LOWER 

---	LTRIM RTRIM TRIM suppriment les espaces respectivement de gauche de droite et des deux cot�s
DECLARE @espace_a_enlever varchar(60)
SET @espace_a_enlever = '     5 espaces � ma gauche'
SELECT @espace_a_enlever AS 'version originale', 
LTRIM(@espace_a_enlever) AS 'sans espace'

DECLARE @espace_a_enlever varchar(60);
SET @espace_a_enlever = '5 espaces apr�s ceci     '
SELECT @espace_a_enlever + 'fin' AS 'version originale', 
RTRIM(@espace_a_enlever) + 'fin' AS 'sans espace'

DECLARE @espace_a_enlever varchar(60)
SET @espace_a_enlever = '  deux espaces � ma gaushe et � ma droite  '
SELECT 'debut' + @espace_a_enlever + 'fin' AS 'version originale', 
'debut' + LTRIM(@espace_a_enlever) + 'fin' AS 'sans espace'

--- UPPER LOWER transforme de texte 
SELECT UPPER(nom) FROM contact 
SELECT LOWER(nom) FROM contact 

----- FORMAT date
--- Changer la date selon les r�gions
SELECT TOP (1) 
Date_de_naissance AS DATE,
FORMAT (Date_de_naissance,'d','fr-FR' ) AS Francais,
FORMAT (Date_de_naissance,'d','en-US' ) AS Anglais,
FORMAT (Date_de_naissance,'d', 'de-de') AS allemand
FROM Contact
--- Afficher le jour en lettre 
SELECT TOP (1) 
Date_de_naissance AS DATE,
FORMAT (Date_de_naissance,'D','fr-FR' ) AS Francais,
FORMAT (Date_de_naissance,'D','en-US' ) AS Anglais,
FORMAT (Date_de_naissance,'D', 'de-de') AS allemand
FROM Contact

----- FORMAT devise
create table table_devise (devise money)

insert into table_devise values ('1,5'), ('7,5'),('1458'),('3,68')
SELECT * FROM table_devise
SELECT
FORMAT (devise, 'C', 'en-US'  ) AS en_dollar,
FORMAT (devise,'C', 'fr-FR' ) AS en_euro,
FORMAT (devise,'C','en-GB' ) AS anglais,
FORMAT (devise,'C','sv-SE' ) AS suedois,
FORMAT (devise,'C','ar-SA' ) AS arabe,
FORMAT (devise,'C','th-TH' ) AS thailandais
FROM table_devise

--- Le langage SQL par d�faut
exec sp_configure 'default language'
exec sp_helplanguage 

----- LEFT et RIGHT 
SELECT nom, prenom, LEFT(nom, 2), RIGHT(prenom, 5) FROM contact
SELECT LEFT(nom, 2) + RIGHT(prenom, 5) FROM contact

----- REPLACE et LEN
SELECT REPLACE('Salut � vous', 'Salut', 'Bonjour')
SELECT prenom, REPLACE(prenom, 'melanie','nassima')  FROM contact

SELECT prenom, LEN(prenom) as langeur FROM contact

----- REPLICATE REVERSE CHARINDEX
SELECT REPLICATE('0',4) + nom	FROM contact
SELECT nom, REVERSE(nom) FROM contact
SELECT CHARINDEX('Teslu',nom) FROM contact
SELECT CHARINDEX('virenque',nom) FROM contact

----- STUFF / STRING SPLIT
SELECT * FROM string_split('1,2,3,4,5', ',')
SELECT STUFF('abcdef', 2, 3, 'ijklmn')

----- CONCAT / CONCAT_WS
SELECT CONCAT ( 'Happy ', 'Birthday ', 11, '/', '25' ) AS Result
SELECT CONCAT(nom, prenom) FROM contact
SELECT CONCAT_WS('-', nom, prenom) AS nom FROM contact
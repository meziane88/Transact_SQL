----- Les Fonctions de Date 
--===================================================

----- DATEADD/ DATEDIFF 
	--- DATEADD (datepart, number, date)
	-- Ajouter un mois à la date 
SELECT DATEADD(MONTH, 1, '20060830') 

	-- Ajouter 2 jours à la date
SELECT DATEADD(DAY, 2, '20060830')

----- DATEDIFF
	--- DATEDIFF (datepart, startdate, enddate)
	-- l'ecart entre deux heurs
SELECT DATEDIFF(hh, '09:00', '11:00')

	-- l'ecart en mois entre deux date 
SELECT DATEDIFF(mm, '2011-09-30', '2011-11-02')

----- DATENAME
SELECT DATENAME(yy,'2017-08-25') -- 2017
SELECT DATENAME(mm,'2017-08-25') -- aout
SELECT DATENAME(HOUR,'2017-08-25 08:36') -- 08
SELECT DATENAME(MINUTE,'2017-08-25 08:36') -- 36
SELECT DATENAME(DAY,'2017-08-25 08:36') -- 25

----- DATEPART
SELECT DATEPART(yy,'2017-08-25') -- 2017
SELECT DATEPART(mm,'2017-08-25') -- 8 Il affiche pas le nom du mois
SELECT DATEPART(HOUR,'2017-08-25 08:36') -- 08
SELECT DATEPART(MINUTE,'2017-08-25 08:36') -- 36
SELECT DATEPART(DAY,'2017-08-25 08:36') -- 25

----- GETDATE
SELECT GETDATE() -- donne la date et l'heure
SELECT GETUTCDATE() -- represente l'heure UTC time

----- EOMONTH 
SELECT EOMONTH(GETDATE()) -- donne le dernier jour du mois 
SELECT EOMONTH(GETDATE(),1) --	donne le dernier jour du mois suivant 
SELECT DATEADD(MM,DATEDIFF(MM, 0,GETDATE()),0) -- premier jour du mois 
SELECT DATEDIFF(MM, 0,GETDATE()) -- 1447
SELECT DATEADD(MM,1447,0) -- premier jour du mois d'aout
SELECT DATEADD(mm, datediff(mm, 0, getdate()) -1 , 0) -- premier jour du mois passé
SELECT DATEADD(MM,1446,0) -- premier jour du mois passé
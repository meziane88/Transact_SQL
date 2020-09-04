----- Les fonctions de conversion 
--=======================================================


---- TRY_CAST et TRY_CONVERT 
select TRY_CAST('abd' as int) as resulat -- affiche NULL si la conversion ne s'effectue pas 
select CAST('abd' as int) as resultat -- affiche une erreur si la conversion ne s'effectue pas 
select TRY_CAST('1' as int) as resultat

select TRY_CONVERT(int, 'abd')
select CONVERT(int, 'abd')

select case when try_CAST('abd' as int) IS null -- si ça echoue
			then 'ko'
			else 'ok'
			end

select case when try_CAST('1' as int) IS null -- si ça echoue
			then 'ko'
			else 'ok'
			end

select IIF(try_convert(int, 'a') is null, 'ko', 'ok') as resultat
select IIF(try_convert(int, '1') is null, 'ko', 'ok') as resultat



----- TRY_PARSE ET PARSE 
select TRY_PARSE('a' as int) as res
select TRY_PARSE('1' as int) as res

select PARSE('saturday, 08 june 2013' as datetime)
select PARSE('08-juin-2013' as datetime)
select PARSE('2013june08' as datetime)
select PARSE('08/jun/2013' as datetime)
select PARSE('08-jun-2013' as datetime)

--------- Partie 1 : Transact Sql
CREATE DATABASE BDD1							----- Cr�ation d'une base de donn�es

ALTER DATABASE BDD1 MODIFY NAME = BDD2			----- Modification d'une base de donn�es 

DROP DATABASE BDD2

USE BDD1

CREATE TABLE ma_table (nom varchar(200), prenom varchar(200))
												----- Cr�ation d'une table 
SP_RENAME 'ma_table', 'ma_table1'				----- Renommer une table 
DROP TABLE ma_table1							----- Supprission d'une table


USE master
GO
SET NOCOUNT ON

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'Diner_Restaurant_FAO'))
BEGIN
	/**Deconnexion de tous les utilsateurs sauf l'administrateur**/
	/**Annulation immediate de toutes les transactions**/
	ALTER DATABASE Diner_Restaurant_FAO SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

	/**Suppression de la base de données**/
	DROP DATABASE Diner_Restaurant_FAO;
END
GO

CREATE DATABASE Diner_Restaurant_FAO
 ON  PRIMARY 
( NAME = N'Diner_Restaurant_FAO', FILENAME = N'C:\Data\MSSQL\Diner_Restaurant_FAO.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Diner_Restaurant_FAO_LOG', FILENAME = N'C:\Data\MSSQL\Diner_Restaurant_FAO_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
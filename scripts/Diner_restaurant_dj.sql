/* This script creates a database for the management of booking and invoice of a restaurant
	The database is initialized with fake data and data coming from the restaurant "Hotel de Ville" in Echallens
*/
USE master
GO
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Suppression de la base de données
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

IF DB_ID (N'Diner_restaurant_DJ') IS NOT NULL
BEGIN
	alter database Diner_restaurant_DJ set single_user with rollback immediate;
	DROP DATABASE Diner_restaurant_DJ;
END
GO

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Création de la base de données
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

--CREATE DATABASE .....

CREATE DATABASE Diner_restaurant_DJ;
GO

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Création des tables
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

USE Diner_restaurant_DJ
GO

CREATE TABLE [Invoice] (
	idInvoice int IDENTITY(1,1),
	invoiceNumber varchar(45),
	totalAmountWithTaxes decimal(10,2),
	totalAmountWithoutTaxes decimal(10,2),
	invoiceDate datetime, 
	fkWaiter int,
	fkTable int,
	fkPaymentCond int);

CREATE TABLE InvoiceDetail (
	idInvoiceDetail int IDENTITY(1,1),
	quantity int,
	amountWithoutTaxes decimal(10,2),
	fkInvoice int, 
	fkTaxRate decimal(4,2),
	fkDish int);
	
CREATE TABLE Dish (
	idDish int IDENTITY(1,1),
	dishDescription varchar(100), 
	fkDishType int, 
	fkMenu int, 
	AmountWithTaxes decimal(5,2));

CREATE TABLE Menu (
	idMenu int IDENTITY(1,1),
	menuName varchar(50), 
	amountWithTaxes decimal (5,2));

CREATE TABLE DishType (
	idDishType int,
	DishTypeName varchar(100));

CREATE TABLE TaxRate (
	taxRateValue decimal(4,2), 
	[description] varchar(100) );

CREATE TABLE [Table] (
	idTable int IDENTITY(1,1),
	capacity tinyint);

CREATE TABLE Waiter (
	idWaiter int  IDENTITY(1,1),
	firstName varchar(35),
	lastName varchar(35));

CREATE TABLE Planning (
	idPlanning int IDENTITY(1,1),
	dateWork datetime,
	fkWaiter int);

CREATE TABLE Responsible (
	fkPlanning int,
	fkTable int);

CREATE TABLE PaymentCondition (
	idPaymentCond int IDENTITY(1,1),
	description varchar(100),
	reduction decimal(4,2));

CREATE TABLE Booking (
	idBooking int IDENTITY(1,1),
	dateBooking datetime,
	nbPers tinyint,
	phonenumber varchar(20),
	lastname varchar(35),
	firstname varchar(35),
	fkTable int);

GO



--data
insert into waiter(firstname, lastName) values ('Eva', 'Risselle');
insert into waiter(firstname, lastName) values ('Marylou', 'Koume');
insert into waiter(firstname, lastName) values ('Magali', 'Maçon');
insert into Waiter (firstName, lastName) values ('Harry', 'Cover');
insert into Waiter (firstName, lastName) values ('Tom', 'Hatte');
insert into Waiter (firstName, lastName) values ('Sam', 'Chatouille');

insert into PaymentCondition (description, reduction) values ('Passeport gourmand pour 2 personnes', 0.5);
insert into PaymentCondition (description, reduction) values ('Passeport gourmand pour 3 personnes', 0.33);
insert into PaymentCondition (description, reduction) values ('Passeport gourmand pour 4 personnes', 0.25);
insert into PaymentCondition (description, reduction) values ('CPNV', 0.1);
insert into PaymentCondition (description, reduction) values ('La Poste', 0.05);
insert into PaymentCondition (description, reduction) values ('Philip Morris', 0.1);

insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (6);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (6);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (4);
insert into [Table] (capacity) values (2);
insert into [Table] (capacity) values (6);

insert into TaxRate values (7.7, 'Taxe suisse standard');
insert into TaxRate values (2.5, 'Taxe réduit');
insert into TaxRate values (3.7, 'Taxe spécial hébergement');


INSERT INTO Invoice (invoiceNumber) VALUES (1);
INSERT INTO Invoice (invoiceNumber) VALUES (2);
INSERT INTO Invoice (invoiceNumber) VALUES (3);
INSERT INTO Invoice (invoiceNumber) VALUES (4);
INSERT INTO Invoice (invoiceNumber) VALUES (5);

INSERT INTO DishType (idDishType, DishTypeName) VALUES (1, 'Entrées');
INSERT INTO DishType (idDishType, DishTypeName) VALUES (2, 'Poissons');
INSERT INTO DishType (idDishType, DishTypeName) VALUES (3, 'Viande');
INSERT INTO DishType (idDishType, DishTypeName) VALUES (4, 'Fromages');
INSERT INTO DishType (idDishType, DishTypeName) VALUES (5, 'Dessert');

INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Risotto tessinois bio aux truffes de Bourgogne et mascarpone', 31, 1);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Gravlax de chevreuil aux citrons confits et câprons', 30, 1);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Terrine de foie gras aux figues et pain d’épices', 29, 1);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Tataki de thon aux pistaches de Bronte', 45, 2);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Scalopines de saumon du Tessin, beurre blanc', 46, 2);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Noix Saint-Jacques et gambas en brochette de romarin', 49, 2);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Médaillons de renne poivrade', 54, 3);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Suprême de canard sauvage à l’orange', 48, 3);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Ris de veau façon saltimbocca à la sauge', 45, 3);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Tournedos de boeuf, vierge automnale aux marrons et pignons', 50, 3);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Selle de chevreuil à la raisineé (dès 2 pers.)', 52, 3);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Assiette de fromages ', 21, 4);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Chaud-froid au chocolat noir, sorbet aux poires', 19, 5);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Opéra au café et chocolat', 20, 5);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Symphonie de crèmes brûlées aux saveurs différentes', 19, 5);
INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES ('Bavarois de poires en verrine, émiettée de spéculoos', 19, 5);

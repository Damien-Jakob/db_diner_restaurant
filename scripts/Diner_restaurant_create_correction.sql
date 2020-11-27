-- Diner_restaurant_FAO.sql:	This script creates a database for the management of booking and invoice of a restaurant
--				The database is initialized with fake data and data coming from the restaurant "Hotel de Ville" in Echallens
--				
-- Version:		1.0, november 2018
-- Author:		F. Andolfatto
--
-- History:
--			1.0 Database creation
--
--

USE master
GO
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Suppression de la base de données
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'Diner_Restaurant_FAO'))
BEGIN
	/**Deconnexion de tous les utilsateurs sauf l'administrateur**/
	/**Annulation immediate de toutes les transactions**/
	ALTER DATABASE Diner_Restaurant_FAO SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

	/**Suppression de la base de données**/
	DROP DATABASE Diner_Restaurant_FAO;
END
GO

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- CreationDatabase
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
--adapter le path des fichiers de données et des journaux de logs de la BD

CREATE DATABASE Diner_Restaurant_FAO
 ON  PRIMARY 
( NAME = N'Diner_Restaurant_FAO', FILENAME = N'C:\Data\MSSQL\Diner_Restaurant_FAO.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Diner_Restaurant_FAO_LOG', FILENAME = N'C:\Data\MSSQL\Diner_Restaurant_FAO_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Création des tables
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


USE Diner_restaurant_FAO
GO

CREATE TABLE [Invoice] (
	idInvoice int IDENTITY(1,1) PRIMARY KEY,
	invoiceNumber varchar(45) NOT NULL,
	totalAmountWithTaxes decimal(10,2) NOT NULL,
	totalAmountWithoutTaxes decimal(10,2) NOT NULL,
	invoiceDate datetime NOT NULL, 
	fkWaiter int NOT NULL,
	fkTable int NOT NULL,
	fkPaymentCond int);

CREATE TABLE InvoiceDetail (
	idInvoiceDetail int IDENTITY(1,1) PRIMARY KEY,
	quantity int NOT NULL,
	amountWithTaxes decimal(10,2) NOT NULL,
	fkInvoice int NOT NULL, 
	fkTaxRate decimal(4,2) NOT NULL,
	fkDish int, 
	fkMenu int);
	
CREATE TABLE Dish (
	idDish int IDENTITY(1,1) PRIMARY KEY,
	dishDescription varchar(100) NOT NULL, 
	fkDishType int NOT NULL, 
	fkMenu int, 
	amountWithTaxes decimal(5,2) NOT NULL);

CREATE TABLE Menu (
	idMenu int IDENTITY(1,1) PRIMARY KEY,
	menuName varchar(50) NOT NULL, 
	amountWithTaxes decimal (5,2) NOT NULL);

CREATE TABLE DishType (
	idDishType int primary key,
	dishTypeName varchar(100) NOT NULL);

CREATE TABLE TaxRate (
	taxRateValue decimal(4,2) PRIMARY KEY, 
	[description] varchar(100) );

CREATE TABLE [Table] (
	idTable int IDENTITY(1,1) PRIMARY KEY,
	capacity tinyint NOT NULL);

CREATE TABLE Waiter (
	idWaiter int  IDENTITY(1,1) PRIMARY KEY,
	firstName varchar(35) NOT NULL,
	lastName varchar(35) NOT NULL);

CREATE TABLE Planning (
	idPlanning int IDENTITY(1,1) PRIMARY KEY,
	dateWork datetime NOT NULL,
	fkWaiter int NOT NULL);

CREATE TABLE Responsible (
	fkPlanning int NOT NULL,
	fkTable int NOT NULL,
	PRIMARY KEY(fkPlanning, fkTable));

CREATE TABLE PaymentCondition (
	idPaymentCond int IDENTITY(1,1) PRIMARY KEY,
	description varchar(100) NOT NULL,
	reduction decimal(4,2) NOT NULL);

CREATE TABLE Booking (
	idBooking int IDENTITY(1,1) PRIMARY KEY,
	dateBooking datetime NOT NULL,
	nbPers tinyint NOT NULL,
	phonenumber varchar(20),
	lastname varchar(35) NOT NULL,
	firstname varchar(35),
	fkTable int NOT NULL);

GO


ALTER TABLE Invoice  WITH CHECK ADD  CONSTRAINT FK_invoice_waiter FOREIGN KEY(fkWaiter)
REFERENCES Waiter (idwaiter);

ALTER TABLE Invoice  WITH CHECK ADD  CONSTRAINT FK_invoice_table FOREIGN KEY(fkTable)
REFERENCES [Table] (idTable);

ALTER TABLE Invoice  WITH CHECK ADD  CONSTRAINT FK_invoice_paymcond FOREIGN KEY(fkPaymentCond)
REFERENCES PaymentCondition (idPaymentCond);
--on delete cascade;

ALTER TABLE InvoiceDetail  WITH CHECK ADD  CONSTRAINT FK_invoicedetail_invoice FOREIGN KEY(fkInvoice)
REFERENCES Invoice (idInvoice)

ALTER TABLE InvoiceDetail  WITH CHECK ADD  CONSTRAINT FK_invoicedetail_taxrate FOREIGN KEY(fkTaxRate)
REFERENCES TaxRate (taxRateValue)

ALTER TABLE InvoiceDetail  WITH CHECK ADD  CONSTRAINT FK_invoicedetail_dish FOREIGN KEY(fkDish)
REFERENCES Dish (idDish)

ALTER TABLE InvoiceDetail  WITH CHECK ADD  CONSTRAINT FK_invoicedetail_menu FOREIGN KEY(fkMenu)
REFERENCES Menu (idMenu)

ALTER TABLE Dish WITH CHECK ADD  CONSTRAINT FK_dish_dishtype FOREIGN KEY(fkDishType)
REFERENCES DishType (idDishType)

ALTER TABLE Dish WITH CHECK ADD  CONSTRAINT FK_dish_menu FOREIGN KEY(fkMenu)
REFERENCES Menu (idMenu)

ALTER TABLE Booking WITH CHECK ADD CONSTRAINT FK_booking_table FOREIGN KEY(fkTable)
REFERENCES [table] (idTable)
--ON DELETE CASCADE

ALTER TABLE Planning WITH CHECK ADD CONSTRAINT FK_planning_waiter FOREIGN KEY(fkWaiter)
REFERENCES waiter (idwaiter)
ON DELETE CASCADE

ALTER TABLE Responsible WITH CHECK ADD CONSTRAINT FK_resp_planning FOREIGN KEY(fkPlanning)
REFERENCES planning (idplanning)

ALTER TABLE Responsible WITH CHECK ADD CONSTRAINT FK_resp_table FOREIGN KEY(fkTable)
REFERENCES [table] (idtable)


alter table waiter add unique (firstname, lastname)

alter table booking add check (dateBooking > GETDATE() and datebooking < DATEADD(MONTH, 2, GETDATE()))

alter table planning add check (dateWork > GETDATE())

alter table InvoiceDetail add check (fkDish is not null or fkMenu is not null)


--Data

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

-- At least 5 invoices
insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable) 
values ('A12345', 107.7, 100.00, '2020-10-25', 1, 3)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable) 
values ('A12346', 86.16, 80.00, '2020-10-24', 1, 5)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable) 
values ('B78912', 215.4, 200.00, '2020-10-25', 2, 3)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable) 
values ('C89654', 80.77, 75.00, '2020-10-23', 2, 4)

insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable) 
values ('A12346', 215.4, 200.00, '2020-10-23', 1, 2)

insert into DishType (idDishType,DishTypeName) values (1, 'Entrées')
insert into DishType (idDishType,DishTypeName) values (2, 'Poissons')
insert into DishType (idDishType,DishTypeName) values (3, 'Viande')
insert into DishType (idDishType,DishTypeName) values (4, 'Fromages')
insert into DishType (idDishType,DishTypeName) values (5, 'Dessert')


insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Ravioles d''épinards et ricotta aux truffes ',28,1)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Gravlax de chevreuil aux citrons confits et câprons',30,1)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Opéra de foie gras aux fruits secs et betteraves',30,1)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Sole entière aux amandes, strudel aux légumes anciens',47,2)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Escalope de saumon à la crème de thym',19.5,2)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Daube d''encornets et Saint-Jacques',48,2)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Rouget barbet farci aux légumes et coquillages',51,2)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Médaillons de renne en croûte de fruits secs et poivre',51,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Carré de porc à la moutarde',19.5,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Mignons de sanglier en habit de lard',44,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Bœuf braisé à l''ancienne',19.5,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Râble de lapin aux truffes et foie gras chaud (par 2 pers.) ',48,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Steak haché bœuf et porc au poivre',19.5,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Selle de chevreuil aux spéculoos  (dès 2 pers.) ',52,3)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Assiette de fromages ',21,4)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Chaud-froid au chocolat noir, glace caramel et beurre salé',19,5)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Disque de gâteaux aux noix, ganache au lait',20,5)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Symphonie de crèmes brûlées aux saveurs différentes',19,5)
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Mille-feuilles chantilly aux châtaignes',20,5)

insert into Planning (dateWork, fkWaiter) values ('2020.11.21', 5)
insert into Planning (dateWork, fkWaiter) values ('2020.11.21', 2)

insert into Waiter (firstname, lastname) values ('Henri', 'Dupont')
insert into Planning (dateWork, fkWaiter) values ('2020.11.21', 7)

delete from waiter where idWaiter = (select idWaiter from waiter where firstname = 'Henri' and lastname = 'Dupont')

insert into responsible (fkPlanning, fkTable) values (2, 5)

/*
-- tests : ensemble des requêtes causant une erreur à cause des contraintes imposées aux colonnes, tables....

--création de la FK. requête pose problème
insert into dish (dishdescription, amountWithTaxes, fkDishType) values ('Gratin de pommes de terre',10,6)

--suppression du type de plat non autorisé car il est utilisé dans la liste des plats 
-- (FK fkDishType dans la table Dish paramétré en NO ACTION par défaut).
delete from dishtype where dishTypeName = 'Viande'
--insert into DishType (idDishType,dishType) values (6, 'Accompagnement')

--échoue : 2 mois dans le futur
insert into booking (dateBooking, nbPers, phonenumber, lastname, firstname, fkTable) values('2020.01.31 20:00', 4, '0216019917', 'Martin', 'Fred', 2)

-- insertion d'un plat dans le menu 15 inexistant
insert into dish (dishdescription, amountWithTaxes, fkDishType, fkMenu) values ('Entremet vanille, glace à la figue', 18, 5 , 15)

-- insertion dans la table 20 inexistante
insert into booking (dateBooking, nbPers, phonenumber, lastname, firstname, fkTable) 
values ('2020.12.05 20:00', 4, '0216019917', 'Dalton', 'Joe', 20)

-- insérer une facture pour le serveur 10 ou/et la table 20 ou/et pour la condition de paiement 10
insert into invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond) 
values ('A12345', 107.7, 100.00, '2020-10-25', 10, 20, 10)

-- insertion d'un planning pour un serveur inexistant 10
insert into Planning values ('2020.11.20', 10)

-- insertion d'un planning dans le passé
insert into Planning values ('2020.10.20', 4)

-- insertion d'un détail de factures pour une facture inexistante, un taux de TVA inexistant et un plat inexistant
insert into InvoiceDetail (quantity, amountWithTaxes, fkInvoice, fkTaxRate, fkDish) values (2, 50.00, 100, 20, 35)

-- insertion d'un détail de factures pour un plat et un menu vides
insert into InvoiceDetail (quantity, amountWithTaxes, fkInvoice, fkTaxRate) values (2, 50.00, 2, 7.7)

-- Attribution des tables par serveur : FK créée sur fkPlanning qui fait référence à idPlanning de Planning, FK créée sur fkTable qui fait référence à idTable de table
insert into responsible (fkPlanning, fkTable) values (2, 50)
insert into responsible (fkPlanning, fkTable) values (125, 5)


*/


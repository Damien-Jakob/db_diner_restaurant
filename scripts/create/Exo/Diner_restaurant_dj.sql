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
	--Disconnect everyone except the admin
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
CREATE DATABASE Diner_restaurant_DJ
 CONTAINMENT = NONE
 ON  PRIMARY 
 -- Set another directory for the db files, instead of the default one in Program Files
( NAME = N'test', FILENAME = N'C:\db\Diner_restaurant_DJ\Diner_restaurant_DJ.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'test_log', FILENAME = N'C:\db\Diner_restaurant_DJ\Diner_restaurant_DJ_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Création des tables
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

USE Diner_restaurant_DJ
GO

CREATE TABLE Menu (
	idMenu int IDENTITY(1,1) PRIMARY KEY,
	menuName varchar(50) NOT NULL, 
	amountWithTaxes decimal (5,2) NOT NULL,
);

CREATE TABLE DishType (
	idDishType int PRIMARY KEY,
	DishTypeName varchar(100) NOT NULL,
);

CREATE TABLE Dish (
	idDish int IDENTITY(1,1) PRIMARY KEY,
	dishDescription varchar(100) NOT NULL, 
	fkDishType int NOT NULL, 
	fkMenu int, 
	AmountWithTaxes decimal(5,2) NOT NULL,
	FOREIGN KEY (fkDishType) REFERENCES DishType(idDishType),
	FOREIGN KEY (fkMenu) REFERENCES Menu(idMenu),
);

CREATE TABLE TaxRate (
	taxRateValue decimal(4,2) PRIMARY KEY, 
	[description] varchar(100),
);

CREATE TABLE [Table] (
	idTable int IDENTITY(1,1) PRIMARY KEY,
	capacity tinyint NOT NULL,
);

CREATE TABLE Waiter (
	idWaiter int  IDENTITY(1,1) PRIMARY KEY,
	firstName varchar(35) NOT NULL,
	lastName varchar(35) NOT NULL,
	CONSTRAINT uniqueName UNIQUE (firstname, lastName)
);

CREATE TABLE Planning (
	idPlanning int IDENTITY(1,1) PRIMARY KEY,
	dateWork datetime NOT NULL,
	fkWaiter int NOT NULL,
	FOREIGN KEY (fkWaiter) REFERENCES Waiter(idWaiter) ON DELETE CASCADE,
	CONSTRAINT noPlanningInThePast CHECK (dateWork > GETDATE()), 
);

CREATE TABLE Responsible (
	fkPlanning int NOT NULL,
	fkTable int NOT NULL,
	PRIMARY KEY(fkPlanning, fkTable),
	FOREIGN KEY (fkPlanning) REFERENCES Planning(idPlanning),
	FOREIGN KEY (fkTable) REFERENCES [Table](idTable),
);

CREATE TABLE PaymentCondition (
	idPaymentCond int IDENTITY(1,1) PRIMARY KEY,
	description varchar(100) NOT NULL,
	reduction decimal(4,2) NOT NULL,
);

CREATE TABLE [Invoice] (
	idInvoice int IDENTITY(1,1) PRIMARY KEY,
	invoiceNumber varchar(45) NOT NULL,
	totalAmountWithTaxes decimal(10,2) NOT NULL DEFAULT 0,
	totalAmountWithoutTaxes decimal(10,2) NOT NULL DEFAULT 0,
	invoiceDate datetime NOT NULL, 
	fkWaiter int NOT NULL,
	fkTable int NOT NULL,
	fkPaymentCond int,
	FOREIGN KEY (fkWaiter) REFERENCES Waiter(idWaiter),
	FOREIGN KEY (fkTable) REFERENCES [Table](idTable),
	FOREIGN KEY (fkPaymentCond) REFERENCES PaymentCondition(idPaymentCond),
	-- ON DELETE CASCADE
);

CREATE TABLE InvoiceDetail (
	idInvoiceDetail int IDENTITY(1,1) PRIMARY KEY,
	quantity int NOT NULL,
	amountWithTaxes decimal(10,2) NOT NULL,
	fkInvoice int NOT NULL, 
	fkTaxRate decimal(4,2) NOT NULL,
	fkDish int,
	fkMenu int,
	FOREIGN KEY (fkInvoice) REFERENCES Invoice(idInvoice),
	FOREIGN KEY (fkTaxRate) REFERENCES TaxRate(taxRateValue),
	FOREIGN KEY (fkDish) REFERENCES Dish(idDish),
	FOREIGN KEY (fkMenu) REFERENCES Menu(idMenu),
	CONSTRAINT concernsAnItem CHECK (fkDish IS NOT NULL OR fkMenu IS NOT NULL), 
);

CREATE TABLE Booking (
	idBooking int IDENTITY(1,1) PRIMARY KEY,
	dateBooking datetime NOT NULL,
	nbPers tinyint NOT NULL,
	phonenumber varchar(20),
	lastname varchar(35) NOT NULL,
	firstname varchar(35),
	fkTable int NOT NULL,
	FOREIGN KEY (fkTable) REFERENCES [Table](idTable),
	-- ON DELETE CASCADE
	CONSTRAINT noBookingInThePast CHECK (dateBooking > GETDATE()),
	CONSTRAINT noBookingTooFarAway CHECK (dateBooking < DATEADD(MONTH, 2, GETDATE())), 
);
GO



-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- Data Insertion
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

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


INSERT INTO Menu (menuName, amountWithTaxes) VALUES
	('MEGA menu', 103.70)
;

INSERT INTO Planning (dateWork, fkWaiter) VALUES
	(
		'2150-01-01',
		(SELECT TOP(1) idWaiter FROM Waiter)
	),
	(
		'2150-01-02',
		(SELECT TOP(1) idWaiter FROM Waiter)
	)
;

INSERT INTO DishType (idDishType, DishTypeName) VALUES
	(1, 'Entrées'),
	(2, 'Poissons'),
	(3, 'Viande'),
	(4, 'Fromages'),
	(5, 'Dessert')
;

INSERT INTO Dish (dishDescription, AmountWithTaxes, fkDishType) VALUES
	('Risotto tessinois bio aux truffes de Bourgogne et mascarpone', 31, 1),
	('Gravlax de chevreuil aux citrons confits et câprons', 30, 1),
	('Terrine de foie gras aux figues et pain d’épices', 29, 1),
	('Tataki de thon aux pistaches de Bronte', 45, 2),
	('Scalopines de saumon du Tessin, beurre blanc', 46, 2),
	('Noix Saint-Jacques et gambas en brochette de romarin', 49, 2),
	('Médaillons de renne poivrade', 54, 3),
	('Suprême de canard sauvage à l’orange', 48, 3),
	('Ris de veau façon saltimbocca à la sauge', 45, 3),
	('Tournedos de boeuf, vierge automnale aux marrons et pignons', 50, 3),
	('Selle de chevreuil à la raisineé (dès 2 pers.)', 52, 3),
	('Assiette de fromages ', 21, 4),
	('Chaud-froid au chocolat noir, sorbet aux poires', 19, 5),
	('Opéra au café et chocolat', 20, 5),
	('Symphonie de crèmes brûlées aux saveurs différentes', 19, 5),
	('Bavarois de poires en verrine, émiettée de spéculoos', 19, 5)
;

INSERT INTO Invoice (
	invoiceNumber,
	invoiceDate, 
	fkWaiter,
	fkTable
) VALUES
	('A4', '2150-01-01', 1, 1),
	('U2', '2150-01-30', 3, 2),
	('C4', '2150-02-02', 2, 3),
	('R2D2', '2150-12-12', 2, 1),
	('C3PO', '2150-11-20', 1, 2)
;



INSERT INTO Booking (
	dateBooking,
	nbPers,
	phonenumber,
	lastname,
	firstname,
	fkTable
)
VALUES 
(
	DATEADD(DAY, 1, GETDATE()), 
	1,
	'0123456789',
	'Lennon',
	'Bob',
	1
),
(
	DATEADD(DAY, 1, GETDATE()), 
	1,
	'666',
	'Death',
	'Henry',
	1
)
;

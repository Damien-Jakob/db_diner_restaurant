USE Diner_restaurant_DJ;
GO

-- Should return at lest 5 elements
SELECT * FROM Invoice;

-- Should be 5
SELECT Count(*) FROM DishType;

-- Should be 16
SELECT Count(*) FROM Dish;

-- Should fail
INSERT INTO Dish (dishDescription, fkDishType, AmountWithTaxes) VALUES (
	'fake dish',
	(SELECT idDishType FROM DishType WHERE DishTypeName LIKE 'Accompagnement'),
	12.50
);

-- Insert should succeed
INSERT INTO Dish (dishDescription, fkDishType, AmountWithTaxes) VALUES (
	'Not a fake dish',
	(SELECT idDishType FROM DishType WHERE DishTypeName LIKE 'Viande'),
	12.50
);

-- Should fail
DELETE FROM DishType 
WHERE DishTypeName LIKE 'Viande';

-- Should fail
INSERT INTO waiter(firstname, lastName) 
SELECT TOP(1) firstname, lastName FROM waiter
;
-- Should fail
INSERT INTO waiter(lastName) 
VALUES ('Lennon');

-- Should fail
INSERT INTO waiter(firstname) 
VALUES ('Bob');

-- Should fail
-- Table 20 should not exist
INSERT INTO Booking (dateBooking, nbPers, lastname, fkTable)
VALUES (DATEADD(MONTH, 1, GETDATE()), 1, 'Lennon', 20);

-- Should fail
INSERT INTO Booking (dateBooking, nbPers, lastname, fkTable)
VALUES ('2000-01-01', 1, 'Lennon', 
	(SELECT TOP(1) idTable FROM [Table])
);

-- Should fail
-- Menu 15 should not exist
INSERT INTO Dish (dishDescription, fkMenu, fkDishType, AmountWithTaxes)
VALUES (
	'Soupe',
	15, 
	(SELECT TOP(1) idDishType FROM DishType),
	3.50
);

-- Should fail
-- Waiter 10 Should not exist
INSERT INTO Planning(fkWaiter, dateWork)
VALUES (10, '2150-01-01');

-- Should fail
INSERT INTO Planning (dateWork, fkWaiter)
VALUES (
	'2000-01-01',
	(SELECT TOP(1) idWaiter FROM Waiter)
);

-- All should fail
-- Waiter 10 Should not exist
-- Table 20 should not exist
-- PaymentCondition 10 should not exist
INSERT INTO Invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond)
VALUES (
	'RB12', 123.45, 110, '2150-01-01',
	10,
	(SELECT TOP(1) idTable FROM [Table]),
	NULL
);
INSERT INTO Invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond)
VALUES (
	'RB12', 123.45, 110, '2150-01-01',
	(SELECT TOP(1) idWaiter FROM Waiter),
	20,
	NULL
);
INSERT INTO Invoice (invoiceNumber, totalAmountWithTaxes, totalAmountWithoutTaxes, invoiceDate, fkWaiter, fkTable, fkPaymentCond)
VALUES (
	'RB12', 123.45, 110, '2150-01-01',
	(SELECT TOP(1) idWaiter FROM Waiter),
	(SELECT TOP(1) idTable FROM [Table]),
	10
);

-- All Should fail
-- Invoice 100 should not exist
-- TaxRate 20% should not exist
-- Dish 35 should not exist
INSERT INTO InvoiceDetail(fkInvoice, fkTaxRate, fkDish, quantity, amountWithTaxes)
VALUES (
	100,
	(SELECT TOP(1) taxRateValue FROM TaxRate),
	(SELECT TOP(1) idDish FROM Dish),
	1, 13.50
);
INSERT INTO InvoiceDetail(fkInvoice, fkTaxRate, fkDish, quantity, amountWithTaxes)
VALUES (
	(SELECT TOP(1) idInvoice FROM Invoice),
	20,
	(SELECT TOP(1) idDish FROM Dish),
	1, 13.50
);
INSERT INTO InvoiceDetail(fkInvoice, fkTaxRate, fkDish, quantity, amountWithTaxes)
VALUES (
	(SELECT TOP(1) idInvoice FROM Invoice),
	(SELECT TOP(1) taxRateValue FROM TaxRate),
	35,
	1, 13.50
);

-- Should fail
INSERT INTO InvoiceDetail(fkInvoice, fkTaxRate, quantity, amountWithTaxes)
VALUES (
	(SELECT TOP(1) idInvoice FROM Invoice),
	(SELECT TOP(1) taxRateValue FROM TaxRate),
	1, 13.50
);

-- All should succeed
INSERT INTO InvoiceDetail(fkInvoice, fkTaxRate, fkDish, quantity, amountWithTaxes)
VALUES (
	(SELECT TOP(1) idInvoice FROM Invoice),
	(SELECT TOP(1) taxRateValue FROM TaxRate),
	(SELECT TOP(1) idDish FROM Dish),
	1, 13.50
);

INSERT INTO InvoiceDetail(fkInvoice, fkTaxRate, fkMenu, quantity, amountWithTaxes)
VALUES (
	(SELECT TOP(1) idInvoice FROM Invoice),
	(SELECT TOP(1) taxRateValue FROM TaxRate),
	(SELECT TOP(1) idMenu FROM Menu),
	1, 13.50
);

-- Should fail
-- Table 50 should not exist
-- Planning 125 should not exist
INSERT INTO Responsible(fkPlanning, fkTable) VALUES (
	(SELECT TOP(1) idPlanning FROM Planning),
	50
);

-- Should fail
INSERT INTO Booking (dateBooking, nbPers, lastname, fkTable)
VALUES (
	DATEADD(MONTH, 2, GETDATE()),
	1, 'Lennon',
	(SELECT TOP(1) idTable FROM [Table])
);

-- Should succeed
INSERT INTO Waiter (firstName, lastName) 
VALUES ('Henry', 'Dupont');
INSERT INTO Planning (dateWork, fkWaiter) VALUES (
	DATEADD(DAY, 1, GETDATE()),
	(SELECT idWaiter FROM Waiter WHERE firstName LIKE 'Henry' AND lastName LIKE 'Dupont')
);

-- Should delete the planning
DELETE FROM Waiter
WHERE firstName LIKE 'Henry' AND lastName LIKE 'Dupont';
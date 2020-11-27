USE Diner_restaurant_DJ;
GO

-- Should return at lest 5 elements
SELECT * FROM Invoice;

-- Should be 5
SELECT Count(*) FROM DishType;

-- Should be 16
SELECT Count(*) FROM Dish;

-- Should fail
INSERT INTO Dish (fkDishType) VALUES (
	(SELECT idDishType FROM DishType WHERE DishTypeName LIKE 'Accompagnement')
);

-- Insert should succeed
INSERT INTO Dish (fkDishType) VALUES (
	(SELECT idDishType FROM DishType WHERE DishTypeName LIKE 'Viande')
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
INSERT INTO Booking (fkTable)
VALUES (20);

-- Should fail
INSERT INTO Booking (dateBooking)
VALUES ('2000-01-01');

-- Should fail
-- Menu 15 should not exist
INSERT INTO Dish (fkMenu, fkDishType)
VALUES (
	15, 
	(SELECT TOP(1) idDishType FROM DishType)
);

-- Should fail
-- Waiter 10 Should not exist
INSERT INTO Planning(fkWaiter)
VALUES (10);

-- Should fail
INSERT INTO Planning (dateWork)
VALUES ('2000-01-01');

-- All should fail
-- Waiter 10 Should not exist
-- Table 20 should not exist
-- PaymentCondition 10 should not exist
INSERT INTO Invoice (fkWaiter)
VALUES (10);
INSERT INTO Invoice (fkTable)
VALUES (20);
INSERT INTO Invoice (fkPaymentCond)
VALUES (10);

-- All Should fail
-- Invoice 100 should not exist
-- TaxRate 20% should not exist
-- Dish 35 should not exist
INSERT INTO InvoiceDetail(fkInvoice, fkDish)
VALUES (
	100,
	(SELECT TOP(1) idDishType FROM DishType)
);
INSERT INTO InvoiceDetail(fkTaxRate, fkDish)
VALUES (
	20,
	(SELECT TOP(1) idDishType FROM DishType)
);
INSERT INTO InvoiceDetail(fkDish)
VALUES (35);

-- Should fail
INSERT INTO InvoiceDetail(quantity)
VALUES (1);

-- All should succeed
INSERT INTO InvoiceDetail(fkDish) VALUES (
	(SELECT TOP(1) idDish FROM Dish)
);
INSERT INTO InvoiceDetail(fkMenu) VALUES (
	(SELECT TOP(1) idMenu FROM Menu)
);

-- Should fail
-- Table 50 should not exist
-- Table 125 should not exist
INSERT INTO Responsible(fkPlanning, fkTable) VALUES
	(
		(SELECT TOP(1) idPlanning FROM Planning),
		50
	)
;
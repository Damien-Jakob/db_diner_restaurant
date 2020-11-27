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
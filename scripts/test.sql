USE Diner_restaurant_DJ;
GO

-- Should return at lest 5 elements
SELECT * FROM Invoice;

-- Should be 5
SELECT Count(*) FROM DishType;

-- Should be 16
SELECT Count(*) FROM Dish;

-- Should fail
-- TODO update test
INSERT INTO Dish (fkDishType) VALUES (10);

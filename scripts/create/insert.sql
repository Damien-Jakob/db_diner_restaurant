insert into TaxRate values (2.5, 'Taxe réduit');
insert into TaxRate values (3.7, 'Taxe spécial hébergement');

insert into responsible (fkPlanning, fkTable) values (2, 5)

INSERT INTO DishType (idDishType, DishTypeName) VALUES
	(1, 'Entrées'),
	(2, 'Poissons'),
	(3, 'Viande'),
	(4, 'Fromages'),
	(5, 'Dessert')
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
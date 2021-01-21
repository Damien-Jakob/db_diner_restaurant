-- WITH CHECK : check the already existing data

ALTER TABLE Invoice  WITH CHECK ADD  CONSTRAINT FK_invoice_paymcond FOREIGN KEY(fkPaymentCond)
REFERENCES PaymentCondition (idPaymentCond);
--on delete cascade;

CREATE TABLE Dish (
	idDish int IDENTITY(1,1) PRIMARY KEY,
	dishDescription varchar(100) NOT NULL, 
	fkDishType int NOT NULL, 
	fkMenu int, 
	AmountWithTaxes decimal(5,2) NOT NULL,
	FOREIGN KEY (fkDishType) REFERENCES DishType(idDishType),
	FOREIGN KEY (fkMenu) REFERENCES Menu(idMenu),
);
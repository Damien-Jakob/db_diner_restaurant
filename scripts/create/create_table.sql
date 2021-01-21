CREATE TABLE [Invoice] (
	idInvoice int IDENTITY(1,1) PRIMARY KEY,
	invoiceNumber varchar(45) NOT NULL,
	totalAmountWithTaxes decimal(10,2) NOT NULL,
	totalAmountWithoutTaxes decimal(10,2) NOT NULL,
	invoiceDate datetime NOT NULL, 
	fkWaiter int NOT NULL,
	fkTable int NOT NULL,
	fkPaymentCond int);
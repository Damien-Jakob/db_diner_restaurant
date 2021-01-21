USE Diner_restaurant_DJ;

INSERT INTO InvoiceDetail(
	quantity,
	amountWithTaxes,
	fkInvoice,
	fkTaxRate,
	fkDish
)
VALUES 
	(1, 100, 1, 2.50, 1)
;

SELECT * FROM Invoice
WHERE idInvoice = 1; 

DELETE FROM InvoiceDetail
WHERE idInvoiceDetail = (SELECT MAX(idInvoiceDetail) FROM InvoiceDetail);

SELECT * FROM Invoice
WHERE idInvoice = 1;

INSERT INTO InvoiceDetail(
	quantity,
	amountWithTaxes,
	fkInvoice,
	fkTaxRate,
	fkDish
)
VALUES 
	(1, 100, 1, 2.50, 1)
;

UPDATE InvoiceDetail
SET amountWithTaxes = 200
WHERE idInvoiceDetail = (SELECT MAX(idInvoiceDetail) FROM InvoiceDetail);

SELECT * FROM Invoice
WHERE idInvoice = 1;
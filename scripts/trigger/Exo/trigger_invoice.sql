/*
	Update the Invoice amount (with and without taxes)
	When an InvoiceDetail is inserted/updated/deleted
*/
CREATE TRIGGER updateInvoiceAmounts
ON InvoiceDetail
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @amountWithTaxes AS DECIMAL(10,2);
	DECLARE @invoiceId AS INT;
	DECLARE @taxRate AS DECIMAL(4,2);
	DECLARE cursorInvoiceDetail CURSOR FOR
		SELECT amountWithTaxes, fkInvoice, fkTaxRate 
		FROM inserted;
	OPEN cursorInvoiceDetail;
	FETCH cursorInvoiceDetail INTO 
		@amountWithTaxes, @invoiceId, @taxRate
	WHILE (@@FETCH_STATUS=0) BEGIN
		UPDATE Invoice SET
			totalAmountWithoutTaxes = totalAmountWithoutTaxes + @amountWithTaxes / (1 + @taxRate/100),
			totalAmountWithTaxes = totalAmountWithTaxes + @amountWithTaxes
		WHERE idInvoice = @invoiceId;
		FETCH cursorInvoiceDetail INTO 
			@amountWithTaxes, @invoiceId, @taxRate;
	END;
	CLOSE cursorInvoiceDetail;
	DEALLOCATE cursorInvoiceDetail;
	DECLARE cursorInvoiceDetail CURSOR FOR
		SELECT amountWithTaxes, fkInvoice, fkTaxRate 
		FROM deleted;
	OPEN cursorInvoiceDetail;
	FETCH cursorInvoiceDetail INTO 
		@amountWithTaxes, @invoiceId, @taxRate
	WHILE (@@FETCH_STATUS=0) BEGIN
		UPDATE Invoice SET
			totalAmountWithoutTaxes = totalAmountWithoutTaxes - @amountWithTaxes / (1 + @taxRate/100),
			totalAmountWithTaxes = totalAmountWithTaxes - @amountWithTaxes
		WHERE idInvoice = @invoiceId;
		FETCH cursorInvoiceDetail INTO 
			@amountWithTaxes, @invoiceId, @taxRate;
	END;
	CLOSE cursorInvoiceDetail;
	DEALLOCATE cursorInvoiceDetail;
END;
GO
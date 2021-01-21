-- This script updates the invoice table according to the amount entered in the invoice detail.


-- inserted
-- deleted

USE Diner_Restaurant_FAO

drop trigger updateInvoice
go

create trigger updateInvoice
on invoicedetail
after insert, delete, update
as
begin
	declare @amountwithtaxes decimal(10,2),
			@invoiceid int,
			@taxrate decimal(4,2),
			@quantity int,
			@amountwithouttaxes decimal(10,2);

	--we look for all the data that have been modified (new values) or added
	declare c_insertinvoicedetail cursor for
		select quantity, amountWithTaxes, fkinvoice, fktaxrate from inserted;
	open c_insertinvoicedetail;
	-- ATTENTION : FETCH before WHILE, and at the end of WHILE
	fetch c_insertinvoicedetail into @quantity, @amountwithtaxes, @invoiceid, @taxrate;
	while (@@FETCH_STATUS = 0)
	begin
		--update the invoice amount with the line amount (+)
		set @amountwithouttaxes = @amountwithtaxes * 100 / (100 + @taxrate);		
		update invoice set totalAmountWithTaxes = totalAmountWithTaxes + @amountwithtaxes, 
			totalAmountWithoutTaxes =  totalAmountWithoutTaxes + @amountwithouttaxes where idInvoice = @invoiceid;

		fetch c_insertinvoicedetail into @quantity, @amountwithtaxes, @invoiceid, @taxrate;
	end
	close c_insertinvoicedetail; 
	deallocate c_insertinvoicedetail;

	--we look for all the data that have been modified (old values) or added
	declare c_deleteinvoicedetail cursor for
		select quantity, amountwithtaxes, fkinvoice, fktaxrate from deleted;
	open c_deleteinvoicedetail;
	fetch c_deleteinvoicedetail into @quantity, @amountwithtaxes, @invoiceid, @taxrate;
	while (@@FETCH_STATUS = 0)
	begin
		--update the invoice amount with the line amount (-)
		set @amountwithouttaxes = @amountwithtaxes * 100 / (100 + @taxrate);
		update invoice set totalAmountWithTaxes = totalAmountWithTaxes - @amountwithtaxes, 
			totalAmountWithoutTaxes = totalAmountWithoutTaxes - @amountwithouttaxes where idInvoice = @invoiceid;

		fetch c_deleteinvoicedetail into @quantity, @amountwithtaxes, @invoiceid, @taxrate;
	end
	close c_deleteinvoicedetail; 
	deallocate c_deleteinvoicedetail;
end
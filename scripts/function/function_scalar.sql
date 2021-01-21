drop function Recette
go

-- recette des @duration derniers jours (@duration = 1 -> recette du jour)

-- must have GO before and after
-- TODO generate error
CREATE FUNCTION Recette (@duration int)
returns decimal
as
begin

	declare @somme decimal(20,2);

	if @duration < 0 or @duration > 365
	begin
		-- hacky way to generate an error in a function
		return cast('Invalid duration' as int);
		-- set @somme = -1;
	end
	else
		select @somme = sum(totalAmountWithTaxes) from Invoice where DATEADD(DAY,@duration,invoiceDate) > GETDATE();
		
	return @somme;
end
go
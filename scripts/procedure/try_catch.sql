Begin Try
		Select Top 1 @madeByName = lastname, @madeByFirstName = firstname From [user] Order By NEWID();
		set @nbPers = (select capacity from [table] where idTable = @table);
		Insert Into booking (dateBooking, nbPers, lastname, firstname, fkTable) Values (@moment, @nbPers, @madeByName, @madeByFirstName, @table);
End Try
Begin catch
	Print ('Pas de bol');
End Catch
create function ListBookings() 
returns table
as
	return (select lastname, firstname, dateBooking, fkTable, nbPers 
		from booking 
		where dateBooking > GETDATE() )
CREATE VIEW Reservations7ProchainsJours AS   
SELECT firstname, dateBooking, fkTable, phonenumber
FROM Booking
WHERE dateBooking >= GETDATE() AND dateBooking < DATEADD(DAY, 7, GETDATE())
GO  
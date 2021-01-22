alter table waiter add unique (firstname, lastname)

alter table booking add check (dateBooking > GETDATE() and datebooking < DATEADD(MONTH, 2, GETDATE()))

alter table InvoiceDetail add check (fkDish is not null or fkMenu is not null)


CREATE TABLE Waiter (
	idWaiter int  IDENTITY(1,1) PRIMARY KEY,
	firstName varchar(35) NOT NULL,
	lastName varchar(35) NOT NULL,
	CONSTRAINT uniqueName UNIQUE (firstname, lastName)
);

CREATE TABLE Planning (
	idPlanning int IDENTITY(1,1) PRIMARY KEY,
	dateWork datetime NOT NULL,
	fkWaiter int NOT NULL,
	FOREIGN KEY (fkWaiter) REFERENCES Waiter(idWaiter) ON DELETE CASCADE,
	CONSTRAINT noPlanningInThePast CHECK (dateWork > GETDATE()), 
);
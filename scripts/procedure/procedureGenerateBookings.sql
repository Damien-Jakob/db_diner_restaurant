/*
	Generate random Bookings :
	* For the next 20 days
	* At 12:00 and 19:00
	* Without booking a table twice at the same time
	* Booking a random number of tables for each time
*/
/*
	Alternative solutioneasier 
	* start cursor over tables
	* and use random value to decide whether or not generate a booking for a specific moment
*/
USE Diner_restaurant_DJ
GO

DROP PROCEDURE IF EXISTS GenerateBookings;
-- NO ; AFTER THE GO
GO

CREATE PROCEDURE GenerateBookings
AS
BEGIN
	DECLARE @NOON TIME = '12:00:00',
			@EVENING TIME = '19:00:00';

	-- make boolean assignation and comparison more readable
	DECLARE @FALSE BIT = 0,
			@TRUE BIT = 1;

	-- FOR day FROM now + 1 TO now + 20
	DECLARE @day DATE = GETDATE();
	DECLARE	@MAX_DAY DATE = DATEADD(DAY, 20, @day);
	WHILE @day < @MAX_DAY
	BEGIN
		-- day += 1
		SET @day = DATEADD(DAY, 1, @day);

		-- FOR time IN [NOON, EVENING]
		DECLARE @time TIME = @NOON;
		DECLARE @eveningGenerated BIT = @FALSE;
		WHILE @eveningGenerated = @FALSE
		BEGIN
			DECLARE @datetime DATETIME = CAST(@day AS DATETIME) + CAST(@time AS DATETIME);

			-- Get the random number of bookings to generate, with a maximum of one booking per table
			DECLARE @TABLE_COUNT INT = (SELECT COUNT(*) FROM [Table]);
			-- RAND * n : 0 to n-1
			DECLARE @TABLES_QUANTITY_TO_GENERATE INT = RAND() * (@TABLE_COUNT + 1);
			
			-- Select the tables et random, and iterate amongst their ids
			DECLARE tableCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
			FOR 
			SELECT TOP(@TABLES_QUANTITY_TO_GENERATE) idTable, capacity
			FROM [Table]
			-- generate random order
			ORDER BY NEWID();

			DECLARE @tableId INT;
			DECLARE @capacity INT;
			OPEN tableCursor;
			FETCH NEXT FROM tableCursor INTO @tableId, @capacity;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @firstname VARCHAR(35),
						@lastname VARCHAR(35);
				-- get random name from previous customers
				SELECT	@firstname = firstname, 
						@lastname = lastname
				FROM Booking 
				ORDER BY NEWID();

				BEGIN TRY
					INSERT INTO Booking(dateBooking, nbPers, firstname, lastname, fkTable)
					VALUES (@datetime, @capacity, @firstname, @lastname, @tableId);
				END TRY
				BEGIN CATCH
					PRINT('Failed to generate a booking');
				END CATCH

				FETCH NEXT FROM tableCursor INTO @tableId, @capacity;
			END
			DEALLOCATE tableCursor;

			-- Update the loop variables
			IF @time = @NOON
				SET @time = @evening;
			ELSE
				SET @eveningGenerated = @TRUE;
		END
	END
END;
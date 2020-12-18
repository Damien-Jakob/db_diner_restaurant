CREATE PROCEDURE GenerateBookings
AS
BEGIN
	DECLARE @NOON TIME = '12:00:00';
	DECLARE @EVENING TIME = '19:00:00';
	DECLARE @FALSE BIT = 0;
	DECLARE @TRUE BIT = 1;

	-- FOR day FROM now + 1 TO now + 20
	DECLARE @day DATE = GETDATE();
	-- MAX_DAY = day + 20
	DECLARE @MAX_DAY DATE = DATEADD(DAY, 20, @day);
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
			DECLARE @TABLES_QUANTITY_TO_GENERATE INT = RAND() * @TABLE_COUNT;
			
			-- Select the tables et random, and iterate amongst their ids
			DECLARE tableCursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
			FOR 
			SELECT TOP(@TABLES_QUANTITY_TO_GENERATE) idTable 
			FROM [Table]
			-- random value generated for each row
			ORDER BY NEWID();
			DECLARE @tableId INT;
			OPEN tableCursor;
			FETCH NEXT FROM tableCursor INTO @tableId;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO Booking(dateBooking, nbPers, lastname, fkTable)
				VALUES (
					@datetime,
					1 + Rand() * 4,
					'testClient',
					@tableId
				);
				FETCH NEXT FROM tableCursor INTO @tableId;
			END
			DEALLOCATE tableCursor;

			-- TODO genrate data for that day and time
			-- Update the loop variables
			IF @time = @NOON
				SET @time = @evening;
			ELSE
				SET @eveningGenerated = @TRUE;
		END
	END
END;
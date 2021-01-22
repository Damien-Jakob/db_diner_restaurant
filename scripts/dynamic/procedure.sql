DROP PROCEDURE InsertDummyRecord
GO

CREATE PROCEDURE InsertDummyRecord
@table NVARCHAR(MAX),
@quantity INT = 1					-- default value
AS
BEGIN
while(@quantity > 0)
begin
	declare 
		@column NVARCHAR(MAX),
		@type NVARCHAR(MAX),
		@columnsList NVARCHAR(MAX) = '',
		@values NVARCHAR(MAX) = '',
		@request NVARCHAR(MAX)
		;

	declare cursor_columns cursor local for
		select COLUMN_NAME,DATA_TYPE
		from information_schema.columns
		where TABLE_NAME = @table
		and COLUMN_NAME not in 
			(SELECT name FROM sys.columns 
			WHERE OBJECT_NAME(object_id) = @table	
			AND COLUMNPROPERTY(object_id, name, 'IsIdentity') = 1);

	open cursor_columns;
	fetch cursor_columns into @column, @type;
	while (@@FETCH_STATUS = 0)
	begin
		set @columnsList += @column + ',';
		set @values += (case @type
			when 'int' then cast(RAND()*100 AS nvarchar)							-- float will be converted auto to int in the insert
			when 'float' then cast(RAND()*100 AS nvarchar)
			when 'varchar' then '''' + CAST(NEWID() AS VARCHAR(MAX)) + ''''			-- '' : single quote ¦ string too long will be automatically cut
			when 'datetime' then '''' + convert(nvarchar, GETDATE(), 120) + ''''    -- style 120 : ODBC canonical -> convertable
			else 'null'
		end)
		set @values += ','

		fetch cursor_columns into @column, @type;	
	end
	close cursor_columns; 
	deallocate cursor_columns;

	-- remove last char
	set @columnsList = SUBSTRING(@columnsList, 0, LEN(@columnsList))
	set @values = SUBSTRING(@values, 0, LEN(@values))

	-- select request
	-- set @request = 'select ' + @columnsList + ' from ' + @table

	-- insert request
	set @request = 'insert into ' + @table + '(' + @columnsList + ') values (' + @values + ')'

	-- execute request
	EXEC sp_executesql @request;

	set @quantity -= 1;
end;
END;
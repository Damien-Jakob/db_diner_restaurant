DROP PROCEDURE InsertDummyRecord
GO

CREATE PROCEDURE InsertDummyRecord
@table NVARCHAR(MAX),
@quantity INT = 10					-- default value
AS
BEGIN
	select COLUMN_NAME,DATA_TYPE
	from information_schema.columns
	where TABLE_NAME = @table
	and COLUMN_NAME not in 
		(SELECT name FROM sys.columns 
		WHERE OBJECT_NAME(object_id) = @table	
		AND COLUMNPROPERTY(object_id, name, 'IsIdentity') = 1)

	-- SELECT column_name, data_type FROM INFORMATION_SCHEMA
	-- DECLARE @request NVARCHAR(MAX) = 'SELECT * FROM ' + @table;

	-- EXEC sp_executesql @request;
END;
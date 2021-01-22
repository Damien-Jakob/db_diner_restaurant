-- InsertDummyRecords.sql:	This script inserts random data in a table 
-- Version:		1.0, jan. 2019
-- Author:		F. Andolfatto, X. Carrel

USE Diner_Restaurant_FAO
GO

DROP PROCEDURE InsertDummyRecords
GO

CREATE PROCEDURE InsertDummyRecords @TName varchar(20), @nbData int
AS
BEGIN

	Declare Fields Scroll Cursor For
		select COLUMN_NAME,DATA_TYPE from information_schema.columns
		where table_name = @TName and COLUMN_NAME not in 
			(SELECT name FROM sys.columns WHERE OBJECT_NAME(object_id) = @TName	AND COLUMNPROPERTY(object_id, name, 'IsIdentity') = 1)
	Declare @sqlRequest nvarchar(1000)
	Declare @sqlData varchar(1000)
	Declare @values varchar(1000)
	Declare @ColName varchar(30)
	Declare @DataType varchar(20)
	Declare @firstValue int
	Open Fields
	
	--we build the column's name string
	set @firstValue = 1;
	set @sqlData = '';
	Fetch First From Fields Into @ColName, @DataType -- Initiate the pump
	While @@FETCH_STATUS = 0
	Begin
		if (@firstValue = 1)
			begin
				set @values = '(' + @colName ;
					
			end
		else 
			begin
				set @values = @values + ',' + @colName;
					
			end

		set @firstValue = 0;

		Fetch Next From Fields Into @ColName, @DataType
	end

	--we build the data	
	while @nbData > 0
	begin
		Fetch First From Fields Into @ColName, @DataType -- Initiate the pump
		set @firstValue = 1;
		While @@FETCH_STATUS = 0
		Begin
			if (@firstValue = 1)
				set @sqlData = @sqlData + '(';
			else
				set @sqlData = @sqlData + ',';

			If @DataType in ('int','smallint','bigint', 'tinyint')
				Set @sqlData=@sqlData+ Convert(varchar,round(rand() * 4,0) + 1) 
			If @DataType in ('float','double','decimal')
				Set @sqlData=@sqlData+ Convert(varchar,rand() * 4)
			If @DataType in ('varchar','nvarchar','char')
				Set @sqlData=@sqlData+'''dummy'''
			If @DataType in ('Date','Time','datetime')
				Set @sqlData=@sqlData+''''+CONVERT(VARCHAR(10), getdate(), 102)+''''
			set @firstValue = 0;
			Fetch Next From Fields Into @ColName, @DataType
		end
			
		set @sqlData = @sqlData + ')'
		print @sqlData
		set @nbData = @nbData-1;
		if (@nbData > 0)
			set @sqlData = @sqlData + ','
	End
	close Fields
	deallocate Fields
	
	set @sqlRequest = 'Insert into ' + @TName + @values + ') values ' + @sqlData; 
	print @sqlRequest
	Exec sp_executesql @sqlRequest

END

exec InsertDummyRecords Invoice,2
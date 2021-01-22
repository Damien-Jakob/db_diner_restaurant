select COLUMN_NAME,DATA_TYPE from information_schema.columns
		where table_name = @TName and COLUMN_NAME not in 
			(SELECT name FROM sys.columns WHERE OBJECT_NAME(object_id) = @TName	AND COLUMNPROPERTY(object_id, name, 'IsIdentity') = 1)
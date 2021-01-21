DECLARE @day DATE = GETDATE();
DECLARE @time TIME = '12:00:00';
DECLARE @datetime DATETIME = CAST(@day AS DATETIME) + CAST(@time AS DATETIME);

Declare @zeday datetime = GETDATE();
Set @zeday = CAST(CAST(DATEPART(YEAR,@zeday) AS varchar) + '-' + CAST(DATEPART(MONTH,@zeday) AS varchar) + '-' + CAST(DATEPART(DAY,@zeday) AS varchar) AS DATETIME);
Set @hour = 12;
SET @moment = DATEADD(HOUR,@hour,@zeday);
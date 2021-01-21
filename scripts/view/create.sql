create view planificationLendemain as
select firstname, lastname, datework, fkTable, capacity  
from waiter w, planning p, responsible r, [table] t
where w.idWaiter = p.fkWaiter and p.idPlanning = r.fkPlanning and r.fkTable = t.idTable
and CONVERT(DATE,dateWork) =DATEADD(DAY,1,CONVERT(DATE, GETDATE()))
go
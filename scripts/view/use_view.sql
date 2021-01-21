select * from planificationLendemain

insert into planificationLendemain(firstname, lastname, fktable, datework) 
values ('Marylou', 'Koume', 6, '2018.12.07')

delete from planificationLendemain 
where firstname = 'Marylou' and lastName = 'Koume' and datework = '2018.12.07'

update planificationLendemain 
set firstname = 'Marylou', lastName = 'Koume', datework = '2018.12.07' 
where firstname = 'Eva' and lastName = 'Risselle' and fkTable = 11


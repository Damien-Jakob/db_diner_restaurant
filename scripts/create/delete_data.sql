delete from waiter 
where idWaiter = (select idWaiter from waiter where firstname = 'Henri' and lastname = 'Dupont')

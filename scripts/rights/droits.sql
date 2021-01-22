-- TODO detail login
-- see doc
-- see roles
-- roles can have roles ?
-- CHECK_POLICY ?
-- CHECK_EXPIRATION ?
-- GRANT CREATE VIEW : scope
-- GRANT ALTER ON SCHEMA::dbo : what ?
-- See delete / update

-- Procedure with params

-- Create login
CREATE LOGIN guest 
WITH PASSWORD = 'guest', 
DEFAULT_DATABASE = Diner_Restaurant_FAO, 
CHECK_POLICY = OFF, 
CHECK_EXPIRATION = OFF;

CREATE LOGIN Joe 
WITH PASSWORD = 'ch@Nge2-me' 
MUST_CHANGE,								-- must change password
DEFAULT_DATABASE = Diner_Restaurant_FAO, 
CHECK_POLICY = ON, 
CHECK_EXPIRATION = ON;

-- Create user
CREATE USER Restoguest FOR LOGIN guest;

-- Grant permissions to user
GRANT SELECT ON [booking] TO Restoguest;
GRANT SELECT ON Reservations7ProchainsJours to Restoguest	-- view
GRANT UPDATE ON Waiter (FirstName) TO Averell
DENY UPDATE, DELETE, INSERT ON Waiter TO Averell			-- DENY > GRANT
GRANT CREATE VIEW TO William
GRANT ALTER ON SCHEMA::dbo TO William

-- Create a role
CREATE ROLE RestoAdmin

-- Add users in the role
ALTER ROLE RestoAdmin add member Joe

-- Grant permissions to role
ALTER ROLE db_datareader add member RestoAdmin
ALTER ROLE db_datawriter add member RestoApp
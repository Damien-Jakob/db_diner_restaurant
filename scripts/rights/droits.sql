-- procedure vs function

-- roles : WITH NAME = new_name ?


-- Create login
CREATE LOGIN guest 
WITH PASSWORD = 'guest', 
DEFAULT_DATABASE = Diner_Restaurant_FAO, 
CHECK_POLICY = OFF,							-- apply Windows password policies, default ON
CHECK_EXPIRATION = OFF;						-- apply Windows expiration policies, default ON

CREATE LOGIN Joe 
WITH PASSWORD = 'ch@Nge2-me' 
MUST_CHANGE,								-- must change password
DEFAULT_DATABASE = Diner_Restaurant_FAO,	-- db
CHECK_POLICY = ON, 
CHECK_EXPIRATION = ON;

-- Create user
CREATE USER Restoguest FOR LOGIN guest;
-- alternative to FOR : FROM

-- Grant permissions to user
GRANT SELECT, INSERT, ALTER ON booking TO TCCtest
GRANT SELECT ON Reservations7ProchainsJours to Restoguest	-- view
GRANT EXECUTE ON myProcedre to bob							-- procedure
GRANT UPDATE ON Waiter (FirstName) TO Averell
GRANT SELECT on [user] to TCCtest WITH grant option		-- permet de passer droits
GRANT CREATE VIEW TO William

DENY UPDATE, DELETE, INSERT ON Waiter TO Averell			-- DENY > GRANT

REVOKE ALTER on booking to TCCtest
REVOKE SELECT ON employees FROM tom CASCADE;				-- remove the grants of the user too
-- can remvove DENY as well as GRANT

grant SELECT on DATABASE::TCCFAO to TCCtest						-- entire db
GRANT DELETE, INSERT, UPDATE ON DATABASE::TCCFAO to TCCtest	
GRANT ALTER ON SCHEMA::dbo TO William							-- entire schema (db contains : data, log, schemas), group tables, procedures, views


-- Create a role
CREATE ROLE RestoAdmin

-- Add users in the role
ALTER ROLE RestoAdmin add member Joe
-- WITH NAME = new_name

ALTER ROLE RestoAdmin drop member Joe


-- Grant permissions to role
GRANT SELECT, EXECUTE ON SCHEMA::[myschema] TO myRole;

-- Add roles in the role
ALTER ROLE db_datareader add member RestoAdmin
ALTER ROLE db_datawriter add member RestoApp
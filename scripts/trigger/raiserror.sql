-- - message
-- - severity
--    0-18 : any user
--    19-25 : specific rights, WITH LOG required
--    20-25 : fatal, co ends, logged
-- - state : 0-255 (helps to identify the place that has raised the error
RAISERROR ('Trop de tables',1,1)
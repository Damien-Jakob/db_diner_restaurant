-- Droits d accès
-- propriétaire table et vues créées par utilisateur
-- possibilité de donner droits aux autres utilisateurs de la db
-- possibilité de passer droits à d'autres utilisateurs
-- possibiliter de supprimer droits transmis

-- sa : system admininistrator

-- db_datareader : GRANT SELECT ON DATABASE::<name>
-- db_datawriter : GRANT DELETE, INSERT, UPDATE ON DATABASE::TCCFAO
-- db_denydatareader
-- db_denydatawriter
-- db_accessadmin : alter users, create schema
-- db_securityadmin : alter role, create schema
-- db_ddladmin
-- db_backupoperator : backups
--CREATE USER hive WITH PASSWORD 'hive';
--CREATE DATABASE metastore;
--GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;

CREATE EXTENSION dblink;

CREATE OR REPLACE FUNCTION f_create_db(dbname text)
  RETURNS void AS
$func$
BEGIN

IF EXISTS (SELECT 1 FROM pg_database WHERE datname = dbname) THEN
   RAISE NOTICE 'Database already exists';
ELSE
   PERFORM dblink_exec('dbname=' || current_database(), 'CREATE DATABASE ' || quote_ident(dbname));
END IF;

END
$func$ LANGUAGE plpgsql;

DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_roles
      WHERE  rolname = 'hive') THEN

      CREATE USER hive WITH PASSWORD 'hive';
      PERFORM f_create_db('metastore');
      GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;
   END IF;
END
$do$;

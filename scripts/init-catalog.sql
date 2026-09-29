-- DuckLake catalog database is already created by POSTGRES_DB.

-- Dedicated schema for the DuckLake metadata.
CREATE SCHEMA IF NOT EXISTS metadata;

-- The DuckLake catalog user owns the schema.
ALTER SCHEMA metadata OWNER TO dbadmin;

-- Prevent accidental creation in public.
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- Allow the DuckLake user to use the catalog schema.
GRANT USAGE, CREATE ON SCHEMA metadata TO dbadmin;

-- Default privileges for objects created later by DuckLake.
ALTER DEFAULT PRIVILEGES IN SCHEMA metadata
  GRANT SELECT, INSERT, UPDATE, DELETE
    ON TABLES TO dbadmin;

ALTER DEFAULT PRIVILEGES IN SCHEMA metadata
  GRANT USAGE, SELECT, UPDATE
    ON SEQUENCES TO dbadmin;



-- CREATE SCHEMA IF NOT EXISTS raw;

-- -- The DuckLake catalog user owns the schema.
-- ALTER SCHEMA raw OWNER TO dbadmin;

-- -- Allow the DuckLake user to use the catalog schema.
-- GRANT USAGE, CREATE ON SCHEMA raw TO dbadmin;

-- -- Default privileges for objects created later by DuckLake.
-- ALTER DEFAULT PRIVILEGES IN SCHEMA raw
--   GRANT SELECT, INSERT, UPDATE, DELETE
--     ON TABLES TO dbadmin;

-- ALTER DEFAULT PRIVILEGES IN SCHEMA raw
--   GRANT USAGE, SELECT, UPDATE
--     ON SEQUENCES TO dbadmin;
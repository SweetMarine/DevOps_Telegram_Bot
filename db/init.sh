#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_DATABASE" <<-EOSQL
    ALTER USER "$DB_USER" WITH PASSWORD '$DB_PASSWORD';
    CREATE ROLE $DB_REPL_USER WITH REPLICATION LOGIN PASSWORD '$DB_REPL_PASSWORD';
    CREATE TABLE phone_data (id SERIAL PRIMARY KEY, phone_number VARCHAR(18) NOT NULL);
    CREATE TABLE email_data (id SERIAL PRIMARY KEY, email VARCHAR(255) NOT NULL);
    INSERT INTO phone_data (phone_number) VALUES ('81234567890');
    INSERT INTO email_data (email) VALUES ('test@test.ok');
EOSQL

echo "host replication ${DB_REPL_USER} ${DB_REPL_HOST}/24 md5" >> /var/lib/postgresql/data/pg_hba.conf

exec "$@"
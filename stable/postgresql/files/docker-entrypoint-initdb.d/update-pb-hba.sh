#!/bin/bash
PG_HBA_FILE=$PGDATA/data/pg_hba.conf
# Modify access policy to allow access to PostgreSQL from outside of the Docker container
echo "" >> $PG_HBA_FILE
echo "# Allow access from outside the Docker container" >> $PG_HBA_FILE
echo "host    all             all             172.17.0.1/32           md5" >> $PG_HBA_FILE
echo "host    all             all             0.0.0.0/32              md5" >> $PG_HBA_FILE

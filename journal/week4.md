# Week 4 — Postgres and RDS
## Postgrest / RDS Required Homework

- SETUP RDS AND POSTGRESS ON YOUR DOCKER-COMPOSE FILE FROM WEEK 1 CODE 
Setup an RDS Instance running using the CLI via [AWS CLI RDS COMMANDS](https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html)

#### RDS NEEDED COMMANDS

```
aws rds create-db-instance \
  --db-instance-identifier cruddur-db-instance \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version  14.7 \
  --master-username CruddurR \
  --master-user-password Cru******************\
  --allocated-storage 20 \
  --availability-zone us-west-2a \
  --backup-retention-period 0 \
  --port 5432 \
  --no-multi-az \
  --db-name cruddur \
  --storage-type gp2 \
  --publicly-accessible \
  --storage-encrypted \
  --enable-performance-insights \
  --performance-insights-retention-period 7 \
  --no-deletion-protection
  --character-set-name (string)
  --timezone (string)
```

To Install Postgres client on codespaces
```
sudo apt-get update
sudo apt-get install postgresql-client
psql --version
```
##### Start Up Postgres client on the cli

```
psql -Upostgres --host localhost

passworn == password
```


##### PSQL Commands:

```
\x on -- expanded display when looking at data
\q -- Quit PSQL
\l -- List all databases
\c database_name -- Connect to a specific database
\dt -- List all tables in the current database
\d table_name -- Describe a specific table
\du -- List all users and their roles
\dn -- List all schemas in the current database
CREATE DATABASE database_name; -- Create a new database
DROP DATABASE database_name; -- Delete a database
CREATE TABLE table_name (column1 datatype1, column2 datatype2, ...); -- Create a new table
DROP TABLE table_name; -- Delete a table
SELECT column1, column2, ... FROM table_name WHERE condition; -- Select data from a table
INSERT INTO table_name (column1, column2, ...) VALUES (value1, value2, ...); -- Insert data into a table
UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition; -- Update data in a table
DELETE FROM table_name WHERE condition; -- Delete data from a table
```

##### Create Database in postgres client
```
create
CREATE database cruddur;
```
Add UUID Extension (Universally unique Identifier) add to the schema.sql file
```
create extension "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```
and RUN

```
from the home directory
psql cruddur < backend-flask/db/schema.sql --host localhost -Upostgres
or from the backend-flask directory
psql cruddur < db/schema.sql --host localhost -Upostgres
```
CREATE CONNECTION_URL STRINGS

```
export CONNECTION_URL = 'postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]'

e.g postgres://postgres:123456@127.0.0.1:5432/dummy

```


# Week 4 — Postgres and RDS
## Postgrest / RDS Required Homework

<!-- (curl ifconfig.me) --> to get your own ip address GITPOD_IP=$(curl ifconfig.me)

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
createdb cruddur -host localhost -Upostgres (inside the postgres terminal)
```
Add UUID Extension (Universally unique Identifier) add to the `schema.sql` file
```
create extension "uuid-ossp";
`CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`
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

create a folder in the backend (bin) for bash 
- create a file to creat database and drop database file

```
#!/bin/bash

echo "db-create"
NO_DB_CONNECTION_URL=$(sed 's/\/cruddur//g' <<<"$CONNECTION_URL")
psql $NO_DB_CONNECTION_URL -c "create database cruddur;"

```
Drop database

```
#!/bin/bash
echo "db-drop"
NO_DB_CONNECTION_URL=$(sed 's/\/cruddur//g' <<<"$CONNECTION_URL")
psql $NO_DB_CONNECTION_URL -c "drop database cruddur;"

```

create schema load file for bash 

```
#!/bin/bash

echo "db-schema-load"
schema_path="$(realpath .)/db/schema.sql"
echo $schema_path

if [ "$1" = "prod" ]; then
    echo "using production key"
    URL=$PROD_CONNECTION_URL
else
    URL=$CONNECTION_URL
fi

psql $URL cruddur < db/schema.sql 

```
Create a db-connect file (in bin folder) to access the database

```
#!/bin/bash

psql $CONNECTION_URL
```

Creat a db-seed file to load data into the database

```
#! /usr/bin/bash

CYAN='\033[1;36m'
NO_COLOR='\033[0m'
LABEL="db-seed"
printf "${CYAN}== ${LABEL}${NO_COLOR}\n"

seed_path="$(realpath .)/db/seed.sql"
echo $seed_path

if [ "$1" = "prod" ]; then
  echo "Running in production mode"
  URL=$PROD_CONNECTION_URL
else
  URL=$CONNECTION_URL
fi

psql $URL cruddur < $seed_path
```
Create Postgress drivers (add to requirement.txt)

```
psycopg[binary]
psycopg[pool]
```

DB Object and connection Pool
-creat a file db.py in the backend lib folder

Modifiy The security group

set env for aws security group

```
export DB_SG_ID="sg-"
gp env DB_SG_ID="sg-"

export DB_SG_RULE_ID="sgr-"
gp env DB_SG_RULE_ID="sgr-"
```

```
#! /usr/bin/bash

aws ec2 modify-security-group-rules \
    --group-id $DB_SG_ID \
    --security-group-rules "SecurityGroupRuleId=$DB_SG_RULE_ID,SecurityGroupRule={IpProtocol=tcp,FromPort=5432,ToPort=5432,CidrIpv4=$GITPOD_IP/32}"
```

#### AWS Lambda 

Create a Lambda Post confirmation post by adding the code below. Created a Lambda Function by using psycopg3 lib. https://pypi.org/project/psycopg2-binary/#files



lambda fucntion

```
import json
import psycopg2
import os

def lambda_handler(event, context):
    user = event['request']['userAttributes']

    user_display_name  = user['name']
    user_email         = user['email']
    user_handle        = user['preferred_username']
    user_cognito_id    = user['sub']
    try:
        sql = f"""
            INSECT INTO public.users (
                display_name,
                email,
                handle,
                cognito_user_id
                )
            VALUES(
                '{user_display_name}',
                '{user_email}',
                '{user_handle}',
                '{user_cognito_id}'
            )
            """
        conn = psycopg2.connect(
            host=(os.getenv('PG_HOSTNAME')),
            database=(os.getenv('PG_DATABASE')),
            user=(os.getenv('PG_USERNAME')),
            password=(os.getenv('PG_SECRET'))
        )
        cur = conn.cursor()
        cur.execute(sql)
        conn.commit() 

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        
    finally:
        if conn is not None:
            cur.close()
            conn.close()
            print('Database connection closed.')
    return event
    ```
    
## SETTING LAMBDA FUNCTION VIA THE CLI
 i could not set lambda via the aws console due to the issue i experience below. I was able to find a walk around using the aws cli example from ![](https://www.cockroachlabs.com/blog/aws-lambda-function-python-cockroachdb-serverless/) 

 ```
 aws lambda create-function \
    --function-name cruddur-post-confirmation \
    --region us-west-2  \
    --zip-file fileb://cruddur-post-confirmation.zip \
    --handler lambda_handler \
    --description cruddur \
    --runtime python3.8 \
    --role arn:aws:iam::051107296320:role/lambda-ex \
    --environment "Variables={PG_HOSTNAME=database url.rds.amazonaws.com,PG_DATABASE=database name ,PG_USERNAME=username,PG_PASSWORD=password}"
    
 ```

 Development
https://github.com/AbhimanyuHK/aws-psycopg2

This is a custom compiled psycopg2 C library for Python. Due to AWS Lambda missing the required PostgreSQL libraries in the AMI image, we needed to compile psycopg2 with the PostgreSQL libpq.so library statically linked libpq library instead of the default dynamic link.

EASIEST METHOD

Some precompiled versions of this layer are available publicly on AWS freely to add to your function by ARN reference.

https://github.com/jetbridge/psycopg2-lambda-layer

Just go to Layers + in the function console and add a reference for your region
arn:aws:lambda:ca-central-1:898466741470:layer:psycopg2-py38:1

Alternatively you can create your own development layer by downloading the psycopg2-binary source files from https://pypi.org/project/psycopg2-binary/#files

Download the package for the lambda runtime environment: psycopg2_binary-2.9.5-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl

Extract to a folder, then zip up that folder and upload as a new lambda layer to your AWS account

Production
Follow the instructions on https://github.com/AbhimanyuHK/aws-psycopg2 to compile your own layer from postgres source libraries for the desired version.

Add the function to Cognito
Under the user pool properties add the function as a Post Confirmation lambda trigger.
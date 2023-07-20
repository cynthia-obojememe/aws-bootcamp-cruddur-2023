# Week 5 — DynamoDB and Serverless Caching

- [Data Modelling](#data-modelling)
- [Dynamodb Security](#Dynamodb-Security)
- [Backend Preparation](#backend-preparation)
- [DynamoDB Utility Scripts](#dynamodb-utility-scripts)
- [Implement Conversations with DynamoDB Local](#implement-conversations-with-dynamodb-local)
- [Errors](#Errors)
- [Implement DynamoDB Stream with AWS Lambda](#implement-dynamodb-stream-with-aws-lambda)


## Data Modelling
A data modelling technique called single table design stores all relevant data in a single database table. For the Direct Messaging System in our Cruddur application, we use DynamoDB. Four patterns of data access can be distinguished in this context:
`Pattern A` for displaying messages. A list of messages that are a part of a message group are visible to users. For displaying message groups, use `Pattern B`. Users can check the other people they have been communicating with by viewing a list of messaging groups. For composing a fresh message in a fresh message group, use `Pattern C`. For adding a new message to an existing message group, use `Pattern D`.

- There are 3 types of items to put in dynamoDB table.

```python
my_message_group = {
    'pk': {'S': f"GRP#{my_user_uuid}"},
    'sk': {'S': last_message_at},
    'message_group_uuid': {'S': message_group_uuid},
    'message': {'S': message},
    'user_uuid': {'S': other_user_uuid},
    'user_display_name': {'S': other_user_display_name},
    'user_handle':  {'S': other_user_handle}
}

other_message_group = {
    'pk': {'S': f"GRP#{other_user_uuid}"},
    'sk': {'S': last_message_at},
    'message_group_uuid': {'S': message_group_uuid},
    'message': {'S': message},
    'user_uuid': {'S': my_user_uuid},
    'user_display_name': {'S': my_user_display_name},
    'user_handle':  {'S': my_user_handle}
}

message = {
    'pk':   {'S': f"MSG#{message_group_uuid}"},
    'sk':   {'S': created_at},
    'message': {'S': message},
    'message_uuid': {'S': message_uuid},
    'user_uuid': {'S': my_user_uuid},
    'user_display_name': {'S': my_user_display_name},
    'user_handle': {'S': my_user_handle}
}
```
** **

- Recreate Backend Activities

We need to install Boto - AWS SDK for Python. Add to ```requirements.txt```.

```
boto3	
python-dateutil
```
- move all postgres bin file to db folder and recheck the path contained in the setup file and others.
- Set DynamoDB (`backend-flask/bin/db`), 

- set the  aws rds (`backend-flask/bin/rds`),

- set the aws cognito  (`backend-flask/bin/cognito`).

** Rearrange the bin folder and create ddb folder. create drop, schemea-load , list-table and seed bash script for dynamo ddb folder

- SETUP local dynamoBD 
first uncomment the dynamo DB setup in docker-compose file
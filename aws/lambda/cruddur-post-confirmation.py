import json
import psycopg2
import os

def lambda_handler(event, context):
    print("handler")
    user = event['request']['userAttributes']
    print(" USERS INFO")
    user_display_name  = user['name']
    user_email         = user['email']
    user_handle        = user['preferred_username']
    user_cognito_id    = user['sub']
    
    conn = None  # Initialize connection outside the try-except block
    
    try:
        sql = f"""
            INSERT INTO public.users (
                display_name,
                email,
                handle,
                cognito_user_id
            )
            VALUES (
                '{user_display_name}',
                '{user_email}',
                '{user_handle}',
                '{user_cognito_id}'
            )
        """
        
        conn = psycopg2.connect(
            host=os.getenv('PG_HOSTNAME'),
            database=os.getenv('PG_DATABASE'),
            user=os.getenv('PG_USERNAME'),
            password=os.getenv('PG_SECRET')
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
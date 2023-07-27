-- this file was manually created
INSERT INTO public.users (display_name, email, handle, cognito_user_id)
VALUES
  ('Cynthia obojememe','cynthialearning3@gmail.com' , 'yee' ,'MOCK'),
  ('cynthia','cynthia562013@gmail.com' , 'testt' ,'MOCK');
  

INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'yee' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )
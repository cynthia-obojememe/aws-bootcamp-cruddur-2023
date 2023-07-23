-- this file was manually created
INSERT INTO public.users (display_name, email, handle, cognito_user_id)
VALUES
  ('Cynthia obojememe','cynthialearning3@gmail.com' , 'yee' ,'MOCK'),
  ('Andrew Bayko','cynthia562013@gmail.com' , 'bayko' ,'MOCK');
  

INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'Firdous' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )
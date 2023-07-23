-- this file was manually created
INSERT INTO public.users (display_name, handle, cognito_user_id, email)
VALUES
  ('cynthia t', 'yee' ,'test@email','MOCK'),
  ('jane t', 'testt' ,'test@email','MOCK'),
  ('Andrew Bayko', 'cynthia o' , 'test@email','MOCK');

INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'andrewbrown' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )
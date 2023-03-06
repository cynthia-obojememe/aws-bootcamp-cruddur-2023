# Week 1 — App Containerization

# Docker and Cruddur app Containerization


- Step 1, Install Docker on your local machine or install Docker extension on Vscode from Gitpod/ Codespaces CDE.
To install Docker and Docker deamon on local machine (Mac), I had to download and install docker.dmg application from the  [`www.docker.com url`](https://docs.docker.com/desktop/install/mac-install/)

- Step 2, Open a vscode from your prefrreed CDE and install the docker extension.
![](assest/week-1/docker%20extension.png)

- P.S: Each line of code can be run on your local machine from the terminal to execute the code without creating a dockerfile with the instructions 
```
cd backend-flask
export FRONTEND_URL="*"
export BACKEND_URL="*"
python3 -m flask run --host=0.0.0.0 --port=4567
cd ..
```
- confirm that the assigned port= 4567 is open and lunch the browers. Append `/api/activities/home` to see the json file


### Create a Dockerfile for the Backend-flask

- Step 3, Containerized the backend-flast application file by right clicking the backend-flask folder and create a new file title Dockerfile.
- Each line of code in the dockerfile provides instruction that is to run inside of the container from the backend-flask folder
-   This creates and docker image
-   
````
{Paste the below script in the dockerfile}


FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

ENV FLASK_ENV=development 

EXPOSE ${PORT}
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]
````

##### Run the docker command to build a docker image from this dockerfile

`docker build -t  backend-flask:new ./backend-flask`

output 
![]()

##### Create a the docker container that runs the backend-flask application using the docker image created

`docker run -it -d -p 4567:4567 backend-flask`

-set the enviroment variable for the backend and run the container. ** make sure to unlock the port and append /api/activites/hom/ to the browser url **

` docker run -d -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask`



### Create Dockerfile for the frontend-react-js

- Step 1, create a dockerfile in the frontend-react-js folder.
`FROM node:16.18

ENV PORT=3000

COPY . /frontend-react-js
WORKDIR /frontend-react-js
RUN npm install
EXPOSE ${PORT}
CMD ["npm", "start"]
`

- cd into the frontend-react-js folder on the terminal and do an npm install

- step 3, run docker build to build the image for the frontend
`docker build -t frontend-react-js ./frontend-react-js`
- setp 4, run the image to create a container. 

` docker run -p 3000:3000 -d frontend-react-js'

#### Create a Docker compose file to run multiple containers at the same time (backend and frontend application)

```
version: "3.8"
services:
  backend-flask:
    environment:
      FRONTEND_URL: "https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
      BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./backend-flask
    ports:
      - "4567:4567"
    volumes:
      - ./backend-flask:/backend-flask
  frontend-react-js:
    environment:
      REACT_APP_BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./frontend-react-js
    ports:
      - "3000:3000"
    volumes:
      - ./frontend-react-js:/frontend-react-js
  dynamodb-local:
    # https://stackoverflow.com/questions/67533058/persist-local-dynamodb-data-in-volumes-lack-permission-unable-to-open-databa
    # We needed to add user:root to get this working.
    user: root
    command: "-jar DynamoDBLocal.jar -sharedDb -dbPath ./data"
    image: "amazon/dynamodb-local:latest"
    container_name: dynamodb-local
    ports:
      - "8000:8000"
    volumes:
      - "./docker/dynamodb:/home/dynamodblocal/data"
    working_dir: /home/dynamodblocal   db:
    image: postgres:13-alpine
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data # the name flag is a hack to change the default prepend folder
# name when outputting the image names
networks: 
  internal-network:
    driver: bridge
    name: cruddur volumes:
  db:
    driver: local  

```

# Homework Challanges

### 1. Run the Dockerfile command as an external script.

- I cd into backend-flask folder, i created an external script for the CMD "flask.sh" in backend-flask folder

Run on terminal `nano flask.sh`
add the below script to the nano file
```
#!bin/sh
python3 -m flask run --host=0.0.0.0 --port=4567
```
- I added the flask script to the backend-flask Dockerfile CMD 
`CMD ["./flask-python.sh "]`
- Create a docker image from the backend-flask dockerfile
` docker build -t backend-flask:V2 ./backend-flask`
- Run container `docker run -it -d -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask:V2` 

I had some error when trying to run the CMD script

![]()

[Ref](https://stackoverflow.com/questions/44687685/getting-permission-denied-in-docker-run)

I was able to resolve this by changing the permission of the sh. script  this code on the dockerfile
`RUN chmod +x flask-python.sh`





3. Push and tag a image to DockerHub (they have a free tier).
4. Use multi-stage building for a Dockerfile build.
5. Implement a healthcheck in the V3 Docker compose file.
6. Research best practices of Dockerfiles and attempt to implement it in your Dockerfile.
7. Learn how to install Docker on your local machine and get the same containers running outside of Gitpod / Codespaces.
8. Launch an EC2 instance that has docker installed, and pull a container to demonstrate you can run your own docker processes.

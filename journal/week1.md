# Week 1 — App Containerization

## Docker and Cruddur app Containerization

- Step 1, install Docker extension on Vscode from Gitpod/ Codespaces CDE.


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


### _Create a Dockerfile for the Backend-flask_

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
---
- I cd into backend-flask folder, i created an external script for the CMD "flask.sh" in backend-flask folder

Run on terminal `nano flask-python.sh`
add the below script to the nano file
```
#!bin/sh
python3 -m flask run --host=0.0.0.0 --port=4567
```
- I added the flask script to the backend-flask Dockerfile CMD 
`CMD ["./flask-python.sh "]`
- Create a docker image from the backend-flask dockerfile
` docker build -t backend-flask:new ./backend-flask`
- Run container `docker run -it -d -p 4567:4567 -e BACKEND_URL='*' backend-flask:new` 

I had a permission error when trying to run the CMD script

I was able to resolve this by changing the permission of the sh. script this code on the dockerfile
`RUN chmod +x flask-python.sh`

##### ![Output ](assest/week-1/Output.png)
---


### 2. Push and tag a image to DockerHub (they have a free tier).

---

first i had to login to my dockerhub account ```docker login```

- Tag the docker image 
```
docker tag  backend-flask:new k12cambel/backend-flask:V2
```
- Push the docker image
```
docker push k12cambel/backend-flask:V2
```
![Dockhub](assest/week-1/Screenshot%202023-03-07%20at%209.31.46%20PM.png)

---

### 3. Use multi-stage building for a Dockerfile build.


---


### 4. Implement a healthcheck in the V3 Docker compose file.

---
i was able to setup a healthcheck on the docker-compose yml file with the code below.

![Healthcheck code added to the docker-compose yaml file](assest/week-1/Screenshot%202023-03-07%20at%209.24.18%20PM.png)

```
healthcheck:
      test: ["CMD", "curl", "-f", "https://${CODESPACE_NAME}-4567.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}/api/activities/home"]
      interval: 30s
      timeout: 10s
      retries: 3
```
![Output](assest/week-1/Screenshot%202023-03-07%20at%209.14.49%20PM.png)

---


### 5. Research best practices of Dockerfiles and attempt to implement it in your Dockerfile.

---

### 6. Learn how to install Docker on your local machine and get the same containers running outside of Gitpod / Codespaces.
**I Install Docker on MacOS** , To install Docker desktop and Docker deamon on local machine (Mac), I had to download and install docker.dmg application from the  [`www.docker.com url`](https://docs.docker.com/desktop/install/mac-install/)
![docker desktop](assest/week-1/Screenshot%202023-03-07%20at%209.56.15%20PM.png)

- I cloned my git repo into my mac desktop 
- 
- `Local Terminal actions`
```
- cd desktop
- mkdir aws-bootcamp-local
- git clone [my aws-bootcamp-cruddur repo] https://github.com/cynthia-obojememe/aws-bootcamp-cruddur-2023.git
- brew install npm
- cd frontend-react-js
- npm install
```
- code . docker-compose.yml to change the environment variable to localhost endpoint
```
version: "3.8"
services:
  backend-flask:
    environment:
      FRONTEND_URL: "http://localhost:3000" 
      BACKEND_URL: "http://localhost:4567" 
    build: ./backend-flask
    ports:
      - "4567:4567"
    volumes:
      - ./backend-flask:/backend-flask
    healthcheck:
      test: curl --fail http://localhost:4567/api/activities/home  <-----
      interval: 30s
      timeout: 10s
      retries: 3


  frontend-react-js:
    environment:
      REACT_APP_BACKEND_URL: "http://localhost:4567"
    build: ./frontend-react-js
    ports:
      - "3000:3000"
    volumes:
      - ./frontend-react-js:/frontend-react-js
  ```

![Output of the running docker container in my local desktop](assest/week-1/local%20running%20dcoker.png)

---

### 6. Launch an EC2 instance that has docker installed, and pull a container to demonstrate you can run your own docker processes.

---



** Lunch an EC2 T2 micro instance and allow ports http:40 ,ssh: ,backend:3000, frontend: 4567

1. `Is` to start up an Ec2 instance, I used Aws linux image
2. I created a security group with ports open for 3000, 4567 and http:80
3. I connect the ec2 instance using ssh key and clone the aws-bootcamp-cruddur- folder

![Output](assest/week-1/ec2%20setup.png)()

** Ssh into the instance using ssh keypair**
![](assest/week-1/Screenshot%202023-03-08%20at%201.10.56%20AM.png)
1. Install docker `sudo amazon-linux-extras install docker`
2. Start the docker engine `sudo service docker start`
3. Grant permission for the user group of ec2 to have access to the docker engine `sudo usermod -a -G docker ec2-user`
4. Make a new directory for the cruder files `mkdir aws-cruddur`
5. Cd into the new directory
6. Install git `sudo yum install git`
7. Clone from my branch the  aws-bootcamp-cruddur-2023 files into the new directory `git clone -b week-1-test https://github.com/cynthia-obojememe/aws-bootcamp-cruddur-2023.git`
8. `Cd` into the docker.compose.yaml file and nano into the file, Change the environment variable IPv4 of the frontend-react-js and backend endpoint to the public IPv4 of the ec2 instance (P.s, You can choose to use a static IP if you intent to access the docker for a longer duration)
9. I was had some issues installing npm on the frontend folder, however, I got a script that worked

`sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
sudo yum install -y nodejs `

I was able to run npm install afterwards

I got the script from the stack overflow website [](https://stackoverflow.com/questions/72544861/install-node-in-amazon-linux-2)

10. To run the docker compose up command, I had to install the 


```
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```
![Backend-flask output](assest/week-1/backend.png)
![Frontend](assest/week-1/frontend.png)

### P.S: I could not get the frontend-react-js to communicated with the backend-flasks as seen in the image above. i intend to search more for answers on how to resolve this.


REFERENCE 
1. youtube: https://www.youtube.com/watch?v=2_yOif1JlW0
2. Github:  https://github.com/coreos/bugs/issues/1848
3. Stackoverflow: https://stackoverflow.com/questions/44687685/getting-permission-denied-in-docker-run
4. Github:  https://github.com/nickda/aws-bootcamp-cruddur-2023/blob/main/journal/week1.md

# Week 1 — App Containerization

# Docker and Cruddur app Containerization


- Step 1, Install Docker on your local machine or install Docker extension on Vscode from Gitpod/ Codespaces CDE.
To install Docker and Docker deamon on local machine (Mac), I had to download and install docker.dmg application from the  [`www.docker.com url`](https://docs.docker.com/desktop/install/mac-install/)

- Step 2, Open a vscode from your prefrreed CDE and install the docker extension.
![](assest/week-1/docker%20extension.png)

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

- Each line of code can be run on your local machine from the terminal to execute the code without creating a dockerfile with the instructions 
```
cd backend-flask
export FRONTEND_URL="*"
export BACKEND_URL="*"
python3 -m flask run --host=0.0.0.0 --port=4567
cd ..
```
- confirm that the assigned port= 4567 is open and lunch the browers. Append `/api/activities/home` to see the json file
- 
### Create Dockerfile for the frontend-react-js


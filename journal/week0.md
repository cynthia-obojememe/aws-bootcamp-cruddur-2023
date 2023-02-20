# Week 0 — Billing and Architecture

## Getting started with creating a Lucidchart with a logical framework of the project.

#### Step 1, Creating a conceptual diagram with the applications needed for the Cruddur application

![Conceptual Diagram](cruddur-assests/week-0/conceptual%20Diagram.png)
    
https://lucid.app/lucidchart/6b28c44d-7cc7-45b4-ae5f-ffb1d43c0dae/edit?viewport_loc=-344%2C-1666%2C3775%2C2020%2C0_0&invitationId=inv_fa33fb3a-54ca-42a3-9314-984cf29a5cc8

#### Step 3: Create AWS account with MFA

- I created an  AWS user account (different from the root user) with full administrative permission and MFA setup
- A programatic access was created to use for access via the command line of my local machine and VS code


#### Step 4: Install  AWS CLI V2 on my local Machine and on setup on my gitpod using vs code and auto installation on the gitpod.yml file

I was able to install aws CLi v2 on my local machine using the below command [AWS documentations for CLI installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```
It was successful and i got the below output.


It was successful and i got the below output.

I was setup the aws cli installation to start 
```
Tasks:
  - name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial
    init: |
      cd /workspace
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      cd $THEIA_WORKSPACE_ROOT
vscode:
  extensions:
    - 42Crunch.vscode-openapi
```
See proof of 
![proof of installation](cruddur-assests/week-0/Gitpod.yml%20aws%20cli%20installation.jpg)

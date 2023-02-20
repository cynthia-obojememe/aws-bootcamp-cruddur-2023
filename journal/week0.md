# Week 0 — Billing and Architecture

## Getting started with creating a Lucidchart with a logical framework of the project.

#### Step 1: Creating a conceptual diagram with the applications needed for the Cruddur application

![Conceptual Diagram](assest/conceptual%20Diagram.png)
    
### [Link to the Lucidchart](https://lucid.app/lucidchart/6b28c44d-7cc7-45b4-ae5f-ffb1d43c0dae/edit?viewport_loc=-344%2C-1666%2C3775%2C2020%2C0_0&invitationId=inv_fa33fb3a-54ca-42a3-9314-984cf29a5cc8)


#### Step 3: Create AWS account with MFA

- I created an  AWS user account (different from the root user) with full administrative permission and MFA setup
- A programatic access was created to use for access via the command line of my local machine and gitpod and VS code

PS: I had some issues using gitpod with a guest ssh passphase cause it kept timing out. I was able to resolve this by creating SSH key with personalized passpharse.This SHA256 key was added to the Gitpod SSH keys to get access to the Vs-code

```
ssh-keygen -t ed25519  
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/cynthia/.ssh/id_ed25519): gitpodaccess
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in gitpodaccess
Your public key has been saved in gitpodaccess.pub
The key fingerprint is:
SHA256:************************************
```



#### Step 4: Install  AWS CLI V2 on my local Machine and also setup on my gitpod using Vs-code to on the gitpod.yml file

I was able to install aws CLi v2 on my local machine using the below command [AWS documentations for CLI installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```
[see proof of image]
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
![proof of installation](a

#### Step 5: Configure Budget using the CLI and Json script

- The billing notification was setup with the below json script added to a new file title 
"budget.json


```
"BudgetLimit": {
        "Amount": "70",
        "Unit": "USD"
    },
    "BudgetName": "Example Tag Budget",
    "BudgetType": "COST",
    "CostFilters": {
        "TagKeyValue": [
            "user:Key$value1",
            "user:Key$value2"
        ]
    },
    "CostTypes": {
        "IncludeCredit": true,
        "IncludeDiscount": true,
        "IncludeOtherSubscription": true,
        "IncludeRecurring": true,
        "IncludeRefund": true,
        "IncludeSubscription": true,
        "IncludeSupport": true,
        "IncludeTax": true,
        "IncludeUpfront": true,
        "UseBlended": false
    },
    "TimePeriod": {
        "Start": 1477958399,
        "End": 3706473600
    },
    "TimeUnit": "MONTHLY"
}
```

This ran successfull with output below. **![Screenshot form the aws account](assest/Billing%20threshold.png)**

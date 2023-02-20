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
![proof of installation](assest/gitpod.yml%20aws%20installation.png)

#### Step 5: Configure Budget using the CLI and Json script

- The billing notification was setup with the below json script added to a new file title 
"budget.json


[AWS documentation on budget example](https://docs.aws.amazon.com/cli/latest/reference/budgets/create-budget.html#examples)
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

- i created an budget notifications using the json script i got from the [AWS documentation on budget notification example](https://docs.aws.amazon.com/cli/latest/reference/budgets/create-budget.html#examples)
```
[
    {
        "Notification": {
            "ComparisonOperator": "GREATER_THAN",
            "NotificationType": "ACTUAL",
            "Threshold": 80,
            "ThresholdType": "PERCENTAGE"
        },
        "Subscribers": [
            {
                "Address": "cynthia************@**.com",
                "SubscriptionType": "EMAIL"
            }
        ]
    }
]
```

I ran the command on the aws cli using this command to setup the budget

```
aws budgets create-budget \
    --account-id=$AWS_ACCOUNT_ID \
    --budget file://aws/json/budget.json \
    --notifications-with-subscribers file://aws/json/budget-notification-with-subscribers.json
```
This ran successfull with output below. **![Screenshot form the aws account](assest/Billing%20threshold.png)**

#### Step 6: Create Billing Alarm using cloudwatch and SNS Topic
- I created an sns topic using the default region setup my aws  (us-west-2)

```
aws sns create-topic --name billing-alarm
```

- i applied the below command to setup a billing alarm notification
```
aws sns subscribe \
    --topic-arn "arn:aws:sns:us-west-2:051107296320:billing-alarm" \
    --protocol email \
    --notification-endpoint cynthia***************
```

- create the Cloudwatch alarm using the json script from Exampro

```
"AlarmName": "DailyEstimatedCharges",
    "AlarmDescription": "This alarm would be triggered if the daily estimated charges exceeds 1$",
    "ActionsEnabled": true,
    "AlarmActions": [
        "arn:aws:sns:us-west-2:051107296320:billing-alarm"
    ],
    "EvaluationPeriods": 1,
    "DatapointsToAlarm": 1,
    "Threshold": 1,
    "ComparisonOperator": "GreaterThanOrEqualToThreshold",
    "TreatMissingData": "breaching",
    "Metrics": [{
        "Id": "m1",
        "MetricStat": {
            "Metric": {
                "Namespace": "AWS/Billing",
                "MetricName": "EstimatedCharges",
                "Dimensions": [{
                    "Name": "Currency",
                    "Value": "USD"
                }]
            },
            "Period": 86400,
            "Stat": "Maximum"
        },
        "ReturnData": false
    },
    {
        "Id": "e1",
        "Expression": "IF(RATE(m1)>0,RATE(m1)*86400,0)",
        "Label": "DailyEstimatedCharges",
        "ReturnData": true
    }]
  }
  
```

- Run the below cli command to setup the cloudwatch alarm

```
aws  cloudwatch put-metric-alarm --cli-input-json file://aws/json/alarm-config.json
```
![proof of the billing alarm configuration](assest/billing%20alarm.png)

#### Create Eventbridge Trigger to Health dashboard link to SNS to send notification of service issues

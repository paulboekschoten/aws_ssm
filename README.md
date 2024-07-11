# Repository to show how to get Session Manager enabled on AWS with Terraform.

# Run the code

Initialise Terraform
```
terraform init
```

Provision the resources
```
terraform apply
```

# In AWS 

The created role `my-ec2-role` with the `SecurityComputeAccess` policy attached
![](media/2024-07-11-09-37-36.png)

The EC2 instance with the instance profile attached
![](media/2024-07-11-09-39-21.png)

## Open Session Manager
![](media/2024-07-11-09-40-25.png)
Under you EC2 instances, select the instance you want to connect to and click `Connect`

![](media/2024-07-11-09-41-06.png)
Select `Session Manager` and click `Connect`

![](media/2024-07-11-09-41-41.png)
You will get a prompt in a new tab.
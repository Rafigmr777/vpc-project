# vpc-project
# Deploying an AWS Infrastructure with Terraform

## Overview
This project provisions a highly available web application using Terraform. It includes an AWS **VPC, EC2 instances, an Application Load Balancer (ALB), Security Groups, and an S3 Bucket**. The infrastructure is designed for scalability and fault tolerance.

## Prerequisites
- AWS account
- Terraform installed ([Download here](https://www.terraform.io/downloads))
- AWS CLI installed and configured
- SSH key pair (for EC2 access)

## Infrastructure Components
1. **VPC & Subnets**:
   - Creates a VPC with CIDR defined in `variables.tf`
   - Two public subnets across different availability zones
   
2. **Internet Gateway & Route Tables**:
   - Attaches an Internet Gateway to allow public access
   - Configures route tables to enable internet connectivity for subnets

3. **Security Group**:
   - Allows inbound HTTP (port 80) and SSH (port 22) traffic
   - Allows all outbound traffic

4. **EC2 Instances**:
   - Two EC2 instances in different subnets (with a user data script for automation)

5. **Application Load Balancer (ALB)**:
   - Distributes traffic across EC2 instances
   - Uses a target group for health checks

6. **S3 Bucket**:
   - Creates an S3 bucket for potential static content storage

## Deployment Steps
### 1️⃣ Clone the Repository
```sh
git clone <repo-url>
cd <project-directory>
```

### 2️⃣ Initialize Terraform
```sh
terraform init
```

### 3️⃣ Plan the Infrastructure
```sh
terraform plan
```

### 4️⃣ Apply the Configuration
```sh
terraform apply -auto-approve
```

### 5️⃣ Get the Load Balancer DNS
```sh
echo "Load Balancer URL: $(terraform output loadbalancerdns)"
```

### 6️⃣ Access the Web Application
Open the **Load Balancer DNS** in a browser to verify the deployment.

## Cleanup
To destroy all resources:
```sh
terraform destroy -auto-approve
```

## Troubleshooting
### 🔹 ALB Targets Unhealthy?
- Ensure EC2 instances are running and listening on port 80:
  ```sh
  sudo netstat -tulnp | grep :80
  ```
- Check user data execution logs:
  ```sh
  cat /var/log/cloud-init-output.log
  ```
- Verify Security Group allows HTTP traffic

### 🔹 VPC Deletion Fails?
- Ensure all associated resources (EC2, ALB, TG, IGW) are destroyed before deleting the VPC

## Next Steps
- Add auto-scaling for EC2 instances
- Implement HTTPS with an SSL certificate
- Enable logging for ALB and S3

# Happy Terraforming! 🚀

Please select ami id of ubuntu machine in case you are using userdata.sh and userdata1.sh


Lucid chart for this:  https://lucid.app/lucidchart/abffaac5-2ac1-4a2b-97e0-c37998419dfc/edit?view_items=IAt1_g-~1Z2D&invitationId=inv_4a60d33d-45e8-44f4-b3cc-9fc100b28356



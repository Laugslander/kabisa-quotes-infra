# Kabisa Quotes Infrastructure

The Kabisa Quotes Infrastructure repository is part of the Kabisa cloud native development assignment, and contains the
Terraform code used for deploying the [Kabisa Quotes Service](https://github.com/Laugslander/kabisa-quotes-service)
application on AWS. It creates an ECS Fargate cluster that runs the Dockerized Spring Boot application.

### Resources

- VPC with public and private subnet
    - Internet Gateway for public subnets
    - NAT Gateways for private subnets
- ECS cluster with Fargate service that runs the application
    - Application Load Balancer
    - Auto scaling policies for CPU and memory

### Prerequisites

- Terraform
- AWS CLI (configured for the correct AWS account)

### Configuration

- Configure all secret variables in `secrets.auto.tfvars.example` and rename the file to `secrets.auto.tfvars`.

### Deployment

1. Initialize Terraform:
   ```
   ./terraform-init
   ```

2. Apply Terraform:
   ```
   terraform apply
   ```
3. Access the application by navigating to the `kabisa-quotes-service` output value.

### Cleanup

1. Destroy environment with Terraform:
   ```
   terraform destroy
   ```

2. Manually remove the following resources in AWS:
    - S3 Bucket `kabisa-quotes-state`, created manually to store Terraform state.
    - ECR repository `kabisa-quotes-service`, created manually to store Docker images.
    - DynamoDB table(s), created automatically by the Spring Boot application.
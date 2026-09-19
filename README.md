The architecture

                         Internet
                            │
                            ▼
                     ┌─────────────┐
                     │ API Gateway │
                     └──────┬──────┘
                            │
                         Lambda
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
          SQS Queue                  EventBridge
              │                           │
              ▼                    ┌──────┴──────┐
      Order Processor              │             │
          Lambda                  SNS         Step Functions
              │                    │             │
              ▼                    ▼             ▼
         DynamoDB             Email/SMS     Invoice Workflow
              │
              ▼
             S3
        Invoice / Reports


🏗️ Terraform structure


cloudops-platform/
│
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── iam/
│   │   ├── s3/
│   │   ├── dynamodb/
│   │   ├── lambda/
│   │   └── api-gateway/
│   │
│   ├── environments/
│   │   └── dev/
│   │
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
│
├── application/
│   ├── api/
│   ├── order-processor/
│   └── invoice-service/
│
├── Jenkinsfile
│
├── README.md
│
└── .gitignore


Terraform Infrastructure
Terraform
   │
   ├── 1. Provider + backend
   ├── 2. VPC
   │     ├── VPC
   │     ├── Public subnets
   │     ├── Private subnets
   │     ├── Route tables
   │     ├── IGW
   │     └── NAT Gateway
   │
   ├── 3. VPC Endpoints
   │     └── S3 + DynamoDB
   │
   ├── 4. IAM
   ├── 5. S3 + KMS
   ├── 6. DynamoDB
   ├── 7. SQS / SNS
   ├── 8. Lambda
   ├── 9. EventBridge
   ├── 10. Step Functions
   └── 11. API Gateway

terraform/
├── modules/
│   ├── vpc/
│   ├── iam/
│   ├── s3/
│   ├── dynamodb/
│   ├── sqs/
│   ├── lambda/
│   └── api-gateway/
│
└── environments/
    └── dev/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── providers.tf
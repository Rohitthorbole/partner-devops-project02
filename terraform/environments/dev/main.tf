module "VPC" {
  source               = "../../modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  vpc_name             = "dev-vpc"
  create_public_subnet = true
  public_subnet_cidr = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  }

  create_private_subnet = true
  private_subnet_cidr = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1a"
  }
  create_nat_gateway = true
}

module "s3" {
  source = "../../modules/s3"
  bucket_name = "partner-devops-project02-bucket"
  environment = "dev"
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  table_name = "partner-devops-table"
  environment = "dev"
}
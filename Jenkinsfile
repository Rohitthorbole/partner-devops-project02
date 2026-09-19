pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }
    stages {
        stage('Terraform Init') {
            steps {
                script {
                    dir('terraform/environments/dev/') {
                        echo 'Initializing Terraform...'
                        sh 'terraform init'
                        echo 'Terraform initialization complete.'
                        echo 'Validating Terraform configuration...'
                        sh 'terraform validate'
                        echo 'Terraform configuration is valid.'
                        echo 'Formatting Terraform configuration...'
                        sh 'terraform fmt'
                        echo 'Terraform configuration is formatted.'
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    dir('terraform/environments/dev/') {
                        echo 'Planning Terraform changes...'
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    dir('terraform/environments/dev/') {
                        echo 'Provisioning the infrastructure...'
                        sh 'terraform apply tfplan'
                    }
                }
            }
        }
    }
}
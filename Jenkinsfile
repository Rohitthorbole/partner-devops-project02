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
                        sh 'terraform validate'
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
    }
}
pipeline {
    agent any
    stages {
        stage('Terraform Init') {
            steps {
                script {
                    dir('terraform/environments/dev/') {
                        echo 'Initializing Terraform...'
                        sh 'terraform init'
                        sh 'terraform validate'
                        sh 'terraform fmt'
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
        stage('Terraform Apply') {
            steps {
                script {
                    dir('terraform/environments/dev/') {
                        echo 'Applying Terraform changes...'
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }
}
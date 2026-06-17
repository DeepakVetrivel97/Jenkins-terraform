pipeline {
    agent any

    stages {

        stage('checking directory') {
            steps {
                sh '''
                pwd
                ls -R
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('01_VPC_terraform-manifests') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('01_VPC_terraform-manifests') {
                    sh 'terraform plan'
                }
            }
        }

    }
}


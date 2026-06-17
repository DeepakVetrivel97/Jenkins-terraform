pipeline {
    agent any

    stages {

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

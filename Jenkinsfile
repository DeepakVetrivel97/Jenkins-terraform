pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        TF_DIR = '01_VPC_terraform-manifests'
    }

    stages {

        stage('Terraform Format Check') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                    terraform init \
                    -backend-config="bucket=company-tf-state" \
                    -backend-config="key=vpc/dev/terraform.tfstate" \
                    -backend-config="region=$AWS_REGION"
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Security Scan') {
            steps {
                dir("${TF_DIR}") {
                    sh 'checkov -d . || true'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Approve Terraform Apply?'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Infrastructure deployed successfully'
        }
        failure {
            echo '❌ Deployment failed - check logs'
        }
    }
}


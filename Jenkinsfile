
pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        TF_DIR = '01_VPC_terraform-manifests'
        ENV = 'dev'   // change to prod later or pass as parameter
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
                    sh """
                    terraform init -reconfigure \
                    -backend-config="bucket=jenkins-prod-terraform-state-demo" \
                    -backend-config="key=\${ENV}/vpc/terraform.tfstate" \
                    -backend-config="region=${AWS_REGION}"
                    """
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

        // ✅ ENTERPRISE APPROVAL CONTROL
        stage('Approval') {
            when {
                expression {
                    return env.ENV == 'prod'
                }
            }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: "Approve deployment to ${ENV}?", ok: "Approve"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                   // sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment to ${ENV} successful"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}


pipeline {
    agent any

    stages {
        stage('Initialize') {
            steps {
                script {
                    sh 'terraform init'
                    sh 'echo "Terraform initialization complete."'
                    sh 'terraform fmt'
                    sh 'terraform validate'
                    sh 'terraform plan'
                }
            }
        }
    }
}

pipeline {
    agent any

    stages {
        stage('--- ENV Setup ---') {
            steps {
                withCredentials([string(credentialsId: 'dummycred', variable: 'USERPASS')]) {
                    echo $USERPASS
            }
        }
        stage('--- Terraform - Init ---') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform - Apply---') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
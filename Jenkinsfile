pipeline {
    agent any

    stages {
        stage('--- ENV Setup ---') {
            steps {
                sh 'echo SHELL; echo $SHELL'
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
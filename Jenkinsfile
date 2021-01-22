pipeline {
    agent any

    stages {
        stage('--- ENV Setup ---') {
            steps {
                withCredentials([string(credentialsId: 'dummycred', variable: 'USERPASS')]) {
                    sh 'echo -n "CREDS-";echo $USERPASS'
                }
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
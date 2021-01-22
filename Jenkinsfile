pipeline {
    agent any

    stages {
        stage('--- ENV Setup ---') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'vault', usernameVariable: 'VAULT_USER', passwordVariable: 'VAULT_PASS')]) {
                    sh '/var/jenkins_home/vault_config'
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
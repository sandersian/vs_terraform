pipeline {
    agent any

    stages {
        stage('--- Terraform - Init ---') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform - Apply---') {
            steps {
                withCredentials([[$class: 'VaultTokenCredentialBinding', addrVariable: 'VAULT_ADDR', credentialsId: 'vault_terraform_deploy', tokenVariable: 'VAULT_TOKEN', vaultAddr: 'https://vault01.hq.vs:8200']]) {
                    sh 'env > /var/jenkins_home/env.txt; terraform apply -auto-approve'
                }
            }
        }
    }
}

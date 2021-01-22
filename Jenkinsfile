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
                withVault(configuration: [engineVersion: 2, timeout: 60, vaultCredentialId: 'vault', vaultUrl: 'https://vault01.hq.vs:8200'], vaultSecrets: [[path: 'secret/ansible/consul_basic_read', secretValues: [[envVar: 'CONSUL_HTTP_TOKEN', vaultKey: 'token'], [envVar: 'CONSUL_HTTP_ADDR', vaultKey: 'consul_http_addr'], [envVar: 'CONSUL_HTTP_SSL', vaultKey: 'consul_http_ssl']]]]) {
                    sh 'env > /var/jenkins_home/env.txt; terraform apply -auto-approve'
                }
                
            }
        }
    }
}
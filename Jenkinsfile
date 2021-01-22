pipeline {
    agent any
    parameters {
        string(name: 'VAULT_CAPATH', defaultValue: '/var/jenkins_home/CA_cert.pem', description: 'Vault CA Cert Path')
        string(name: 'VAULT_ADDR', defaultValue: 'https://vault01.hq.vs:8200', description: 'Vault API address')
    }
    stages {
        stage('--- Terraform - Init ---') {
            steps {
                sh 'true #terraform init'
            }
        }
        stage('Terraform - Apply---') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'vault_terraform_login', passwordVariable: 'SECRET_ID', usernameVariable: 'ROLE_ID')]) {
                    sh '''
                        . ./vault_consul_setup.bash
                        rm -fr vs_ansible
                        git clone git@github.com:sandersian/vs_ansible.git
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}

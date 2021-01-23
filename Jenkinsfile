pipeline {
    agent any
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
                        export VAULT_CAPATH
                        export VAULT_ADDR
                        rm -fr vs_ansible
                        git clone git@github.com:sandersian/vs_ansible.git
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}

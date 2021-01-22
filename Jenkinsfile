pipeline {
    agent any

    stages {
        stage('--- Terraform - Init ---') {
            steps {
                sh 'true #terraform init'
            }
        }
        stage('--- Pull Ansible Items ---') {
            steps {
                git changelog: false, poll: false, url: 'git@github.com:sandersian/vs_ansible.git'
            }
        }
        stage('Terraform - Apply---') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'vault_terraform_login', passwordVariable: 'SECRET_ID', usernameVariable: 'ROLE_ID')]) {
                    sh '''
                        . ./vault_consul_setup.bash
                        env > /var/jenkins_home/env.txt
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}

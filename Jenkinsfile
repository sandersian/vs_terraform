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
                withCredentials([usernamePassword(credentialsId: 'vault_terraform_login', passwordVariable: 'SECRET_ID', usernameVariable: 'ROLE_ID')]) {{
                    sh '''
                    export VAULT_CAPATH=/var/jenkins_home/CA_cert.pem
                    export VAULT_ADDR=https://vault01.hq.vs:8200
                    export VAULT_TOKEN=$(curl --request POST --data "{ \"role_id\": \"$ROLE_ID\", \"secret_id\": \"$SECRET_ID\"}" $| jq -r .auth.client_token)
                    export CONSUL_HTTP_ADDR=$(vault kv get -format=json secret/ansible/consul_basic_read | jq -r .data.data.consul_http_addr)
                    export CONSUL_HTTP_SSL=$(vault kv get -format=json secret/ansible/consul_basic_read | jq -r .data.data.consul_http_ssl)
                    export CONSUL_HTTP_TOKEN=$(vault kv get -format=json secret/ansible/consul_basic_read | jq -r .data.data.token)
                    export CONSUL_CACERT=$VAULT_CAPATH
                    env > /var/jenkins_home/env.txt
                    terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}

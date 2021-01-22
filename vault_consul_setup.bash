#!/bin/bash
set +x
export VAULT_CAPATH=/var/jenkins_home/CA_cert.pem
export VAULT_ADDR=https://vault01.hq.vs:8200
export VAULT_TOKEN=$(curl -s -k --request POST --data "{ \"role_id\": \"$ROLE_ID\", \"secret_id\": \"$SECRET_ID\"}" $VAULT_ADDR/v1/auth/approle/login | jq -r .auth.client_token)
export CONSUL_HTTP_ADDR=$(vault kv get -format=json secret/ansible/consul_basic_read | jq -r .data.data.consul_http_addr)
export CONSUL_HTTP_SSL=$(vault kv get -format=json secret/ansible/consul_basic_read | jq -r .data.data.consul_http_ssl)
export CONSUL_HTTP_TOKEN=$(vault kv get -format=json secret/ansible/consul_basic_read | jq -r .data.data.token)
export CONSUL_CACERT=$VAULT_CAPATH

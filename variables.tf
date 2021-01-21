data "vault_generic_secret" "master_node_config" {
  path = "secret/k8s_config/master_node_config"
}

data "vault_generic_secret" "worker_node_config" {
  path = "secret/k8s_config/worker_node_config"
}

data "vault_generic_secret" "default_xoa_vm" {
  path = "secret/terraform_deploy/default_xoa_vm"
}
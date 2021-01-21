terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "vansanderstine"

    workspaces {
      name = "vs_terraform"
    }
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "2.17.0"
    }
  }
}

module "k8s" {
  source = "./modules/k8s"

  k8s-master-instances = ["mkube01"]
  k8s-worker-instances = ["kube01", "kube02", "kube03"]

  template-uuid = data.vault_generic_secret.default_xoa_vm.data["template-uuid"]
  sr-uuid       = data.vault_generic_secret.default_xoa_vm.data["sr-uuid"]
  network-uuid  = data.vault_generic_secret.default_xoa_vm.data["network-uuid"]

  k8s-master-memory_size = data.vault_generic_secret.master_node_config.data["memory_size"]
  k8s-master-disk_size   = data.vault_generic_secret.master_node_config.data["disk_size"]
  k8s-master-cpus        = data.vault_generic_secret.master_node_config.data["cpus"]

  k8s-worker-memory_size = data.vault_generic_secret.worker_node_config.data["memory_size"]
  k8s-worker-disk_size   = data.vault_generic_secret.worker_node_config.data["disk_size"]
  k8s-worker-cpus        = data.vault_generic_secret.worker_node_config.data["cpus"]
}

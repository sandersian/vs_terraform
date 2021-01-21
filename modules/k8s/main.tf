terraform {
  required_providers {
    xenorchestra = {
      source = "terra-farm/xenorchestra"
      version = "0.12.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "2.17.0"
    }
  }
}

provider "xenorchestra" {
  url       = data.vault_generic_secret.xoa_provisioner.data["url"]
  username  = data.vault_generic_secret.xoa_provisioner.data["username"]
  password  = data.vault_generic_secret.xoa_provisioner.data["password"]
}

resource "xenorchestra_vm" "worker_nodes" {
    #count               = length(var.k8s-master-instances)
    for_each = toset(var.k8s-worker-instances)
    memory_max          = var.k8s-worker-memory_size
    cpus                = var.k8s-worker-cpus
    name_label          = each.key
    name_description    = each.key
    template            = var.template-uuid

    network {
      network_id = var.network-uuid
    }

    disk {
      sr_id             = var.sr-uuid
      name_label        = "${each.key}-root"
      size              = var.k8s-worker-disk_size
    }

    provisioner "local-exec" {
      command           = "cd ~/projects/vs_ansible && ansible-playbook -i ${each.key}, playbook.yml"
    }

    provisioner "local-exec" {
      when              = destroy
      command           = "cd ~/projects/vs_ansible && ansible -i consul_inventory ${each.key} -u ansible --become -a \"systemctl stop consul\""
    }
}

resource "xenorchestra_vm" "master_nodes" {
    for_each = toset(var.k8s-master-instances)
    memory_max          = var.k8s-master-memory_size
    cpus                = var.k8s-master-cpus
    name_label          = each.key
    name_description    = each.key
    template            = var.template-uuid

    network {
      network_id = var.network-uuid
    }

    disk {
      sr_id             = var.sr-uuid
      name_label        = "${each.key}-root"
      size              = var.k8s-master-disk_size
    }

    provisioner "local-exec" {
      command           = "cd ~/projects/vs_ansible && ansible-playbook -i ${each.key}, playbook.yml"
    }

    provisioner "local-exec" {
      when              = destroy
      command           = "cd ~/projects/vs_ansible && ansible -i consul_inventory ${each.key} -u ansible --become -a \"systemctl stop consul\""
    }
}
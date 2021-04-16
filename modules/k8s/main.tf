terraform {
  required_providers {
    xenorchestra = {
      source  = "terra-farm/xenorchestra"
      version = "0.12.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.17.0"
    }
  }
}

provider "xenorchestra" {
  url      = data.vault_generic_secret.xoa_provisioner.data["url"]
  username = data.vault_generic_secret.xoa_provisioner.data["username"]
  password = data.vault_generic_secret.xoa_provisioner.data["password"]
}

resource "xenorchestra_vm" "worker_nodes" {
  #count               = length(var.k8s-master-instances)
  for_each         = toset(var.k8s-worker-instances)
  memory_max       = var.k8s-worker-memory_size
  cpus             = var.k8s-worker-cpus
  name_label       = each.key
  name_description = each.key
  template         = var.template-uuid

  network {
    network_id = var.network-uuid
  }

  disk {
    sr_id      = var.sr-uuid
    name_label = "${each.key}-root"
    size       = var.k8s-worker-disk_size
  }

  #Wait until we know that the host has registered itself with consul
  provisioner "local-exec" {
    command = "timeout 180s sh -c \"until ping -c 1 ${each.key} > /dev/null 2>&1 ; do sleep 2; done\""
  }

  provisioner "local-exec" {
    command = "ssh -q -o StrictHostKeyChecking=no ansible@${each.key} \"sudo /usr/local/bin/add_consul_tag.sh k8s_worker\""
  }

  #Try to deregister from consul prior to destroy
  provisioner "local-exec" {
    when    = destroy
    command = "ssh -q -o StrictHostKeyChecking=no ansible@${each.key} \"sudo systemctl stop consul\" || : "
  }
}

resource "xenorchestra_vm" "master_nodes" {
  for_each         = toset(var.k8s-master-instances)
  memory_max       = var.k8s-master-memory_size
  cpus             = var.k8s-master-cpus
  name_label       = each.key
  name_description = each.key
  template         = var.template-uuid

  network {
    network_id = var.network-uuid
  }

  disk {
    sr_id      = var.sr-uuid
    name_label = "${each.key}-root"
    size       = var.k8s-master-disk_size
  }

  #Wait until we know that the host has registered itself with consul
  provisioner "local-exec" {
    command = "timeout 180s sh -c \"until ping -c 1 ${each.key} > /dev/null 2>&1; do sleep 2; done\""
  }

  provisioner "local-exec" {
    command = "ssh -q -o StrictHostKeyChecking=no ansible@${each.key} \"sudo /usr/local/bin/add_consul_tag.sh k8s_master\""
  }

  #Try to deregister from consul prior to destroy
  provisioner "local-exec" {
    when    = destroy
    command = "ssh -q -o StrictHostKeyChecking=no ansible@${each.key} \"sudo systemctl stop consul\" || : "
  }
}

resource "xenorchestra_vm" "nfs_nodes" {
  #count               = length(var.k8s-master-instances)
  for_each         = toset(var.knfs-instances)
  memory_max       = var.knfs-memory_size
  cpus             = var.knfs-cpus
  name_label       = each.key
  name_description = each.key
  template         = var.template-uuid

  network {
    network_id = var.network-uuid
  }

  disk {
    sr_id      = var.sr-uuid
    name_label = "${each.key}-root"
    size       = var.knfs-disk_size
  }

  disk {
    sr_id      = var.sr-uuid
    name_label = "${each.key}-nfsdata01"
    size       = var.knfs-data_disk_size
  }

  #Wait until we know that the host has registered itself with consul
  provisioner "local-exec" {
    command = "timeout 180s sh -c \"until ping -c 1 ${each.key} > /dev/null 2>&1 ; do sleep 2; done\""
  }

  provisioner "local-exec" {
    command = "ssh -q -o StrictHostKeyChecking=no ansible@${each.key} \"sudo /usr/local/bin/add_consul_tag.sh k8s_nfs\""
  }

  #Try to deregister from consul prior to destroy
  provisioner "local-exec" {
    when    = destroy
    command = "ssh -q -o StrictHostKeyChecking=no ansible@${each.key} \"sudo systemctl stop consul\" || : "
  }
}

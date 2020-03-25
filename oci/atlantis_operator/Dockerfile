FROM runatlantis/atlantis:v0.11.1

ARG SSH_URI_TO_ANSIBLE_PLAYBOOK_BOOT_K8S=$SSH_URI_TO_ANSIBLE_PLAYBOOK_BOOT_K8S
ARG SSH_URI_TO_ANSIBLE_PLAYBOOK_DEPLOY_APP=$SSH_URI_TO_ANSIBLE_PLAYBOOK_DEPLOY_APP

#
# # copy a terraform binary of the version you need
# COPY terragrunt /usr/local/bin/terragrunt
#

#
# install terragrunt
# install git && git-flow
# install ansible / ansible-playbook
# install terraform-inventory https://github.com/adammck/terraform-inventory and ina later release, https://github.com/nbering/terraform-provider-ansible instead
#

# Ansible playbooks are executed using the Terraform local-exec provisioner
#
# provisioner "local-exec" {
#     command = "ansible-playbook -i '${self.public_ip},' --private-key ${var.ssh_key_private} provision.yml"
# }
#




#
# git clone the ansible playbooks as terraform modules, using go get <module>
# --- #
# go get all dependencies inside the atlantis.yaml
# Not to actually use them, but to test dependency
# resolution works both reliably and as expected :

# - playbook that will execute the kubeone commands provisioning the k8s Cluster
RUN go get ${SSH_URI_TO_ANSIBLE_PLAYBOOK_DEPLOY_APP}
# - playbook that will execute the Helm Chart deploying the Cresh App in the k8s Cluster
RUN go get ${SSH_URI_TO_ANSIBLE_PLAYBOOK_BOOT_K8S}

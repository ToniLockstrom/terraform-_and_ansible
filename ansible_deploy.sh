#!/bin/bash
TF_DIR="/home/user/iths/grand_lab/terraform"

# Fetch IPs from Terraform
TERRA_BASTION=$(terraform -chdir="$TF_DIR" output -raw bastion_ip)
TERRA_NEXTCLOUD=$(terraform -chdir="$TF_DIR" output -raw nextcloud_ip)
TERRA_NEXTCLOUD_FIP=$(terraform -chdir="$TF_DIR" output -raw nextcloud_fip)

# killswitch when s**t hits the fan
if [[ -z "$TERRA_BASTION" || -z "$TERRA_NEXTCLOUD" || -z "$TERRA_NEXTCLOUD_FIP" ]]; then
    echo "Failed to create inventory.ini"
    exit 1
else
    echo "inventory.ini updated"

fi

# create inventory.ini using said IPs
cat <<EOF > .inventory.ini
[nextcloud]
$TERRA_NEXTCLOUD ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa floating_ip=$TERRA_NEXTCLOUD_FIP


[nextcloud:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q -i ~/.ssh/id_rsa ubuntu@$TERRA_BASTION -o StrictHostKeyChecking=no"'
EOF
    

ansible-playbook -i .inventory.ini .playbook.yaml

echo "Head over to: $TERRA_NEXTCLOUD_FIP"

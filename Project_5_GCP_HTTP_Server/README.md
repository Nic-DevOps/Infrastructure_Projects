# Project 5 – GCP HTTP Server (Terraform + Ansible)

## 🛠️ Overview

This project provisions a virtual machine (VM) on Google Cloud using **Terraform**, then configures it as an HTTP server using **Ansible**. It demonstrates key Infrastructure as Code (IaC) practices across both infrastructure provisioning and remote configuration management.

---

## 📦 Stack

- **Terraform** – Provision GCP infrastructure (VM, networking)
- **Ansible** – Install and configure the web server remotely
- **GCP** – Cloud provider used to host the VM
- **Nginx** – Web server to serve a basic HTML page

---

## 🚀 Objectives

1. Provision a GCP VM with Terraform.
2. Open required firewall ports for HTTP traffic.
3. Output the VM’s external IP.
4. Use Ansible to SSH into the VM and:
   - Install Nginx
   - Deploy a sample \`index.html\`
   - Ensure the service is running

---

## 📁 Directory Structure

- \`Project_5_GCP_HTTP_Server/\`
  - \`terraform/\`
    - \`main.tf\`
    - \`variables.tf\`
    - \`outputs.tf\`
  - \`ansible/\`
    - \`inventory.ini\`
    - \`playbook.yml\`
    - \`roles/\`
      - \`webserver/\`
        - \`tasks/\`
          - \`main.yml\`
        - \`handlers/\`
          - \`main.yml\`
  - \`files/\`
    - \`index.html\`
  - \`README.md\`
---

## ✅ Usage Instructions

### 1. Terraform – Provision Infrastructure

\`\`\`bash
cd terraform
terraform init
terraform apply
\`\`\`

> Be sure to pass \`project_id\` and confirm the plan before proceeding.

### 2. Ansible – Configure HTTP Server

1. Retrieve the external IP from Terraform output.
2. Add the IP to \`ansible/inventory.ini\`.
3. Run:

\`\`\`bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
\`\`\`

---

## 🔐 Notes

- Ensure you have a service account key and GCP SDK configured (\`gcloud auth application-default login\`).
- An SSH key must be available and provisioned with the instance for Ansible access.

---

## 📎 References

- [Terraform Google Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Ansible Roles & Reuse](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)

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
```plaintext
Project_5_GCP_HTTP_Server/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── ansible/
│   ├── inventory.ini
│   ├── playbook.yml
│   └── roles/
│       └── webserver/
│           ├── tasks/
│           │   └── main.yml
│           └── handlers/
│               └── main.yml
├── files/
│   └── index.html
├── README.md
```
---

## ✅ Usage Instructions

### 1️⃣ Authenticate with GCP
```bash
gcloud auth login
gcloud auth application-default login
```

Ensure billing is enabled and the Compute Engine API is activated.

---

### 2️⃣ Generate an SSH Keypair

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/gcp_terraform -C "you@example.com"
```

Do **not** set a passphrase. Terraform will use this key to allow Ansible SSH access.

---

### 3️⃣ Configure Terraform Variables

Update your `terraform.tfvars` file or pass values directly:

```hcl
project_id = "your-project-id"
region     = "australia-southeast1"
zone       = "australia-southeast1-a"
```

### 4️⃣. Terraform – Provision Infrastructure

```bash
cd terraform
terraform init
terraform apply
```

> Be sure to pass \`project_id\` and confirm the plan before proceeding.

### 5️⃣. Ansible – Configure HTTP Server

1. Retrieve the external IP from Terraform output.
2. Add the IP to \`ansible/inventory.ini\`.
3. Run:

```bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
```

## 🌐 Access the Web Server

Visit: `http://<EXTERNAL_IP>`

You should see your custom web page.

---

## 🔐 Notes

- VM type is eligible for **GCP’s free tier** (`e2-micro`).
- Ensure the `compute.googleapis.com` API is enabled.
- SSH access is secured with key-based authentication.
- The project is modular — future enhancements could include:
  - SSL (via Let's Encrypt)
  - DNS setup
  - Monitoring (Prometheus/Grafana)
  - Logging and alerts


- Ensure you have a service account key and GCP SDK configured (\`gcloud auth application-default login\`).
- An SSH key must be available and provisioned with the instance for Ansible access.


### Linux file permission notation
#### 📎 Linux File Permission Explanation (e.g. for `index.html`)

| Permission | Symbol | Value |
|------------|--------|-------|
| Read       | `r`    | 4     |
| Write      | `w`    | 2     |
| Execute    | `x`    | 1     |

A mode of `0644` means:

- **Owner**: Read + Write (`rw-`)
- **Group**: Read only (`r--`)
- **Others**: Read only (`r--`)

This is ideal for static web content like `index.html`, where:

- The system or web server (owner) can write/manage the file.
- Everyone else (like visitors via Nginx) can only read it.

---

## 📎 References

- [Terraform Google Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Ansible Roles & Reuse](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)

# 🌐 Project 5: GCP HTTP Server (Terraform + Ansible – Ubuntu Edition)

This project demonstrates Infrastructure as Code (IaC) using **Terraform** and **Ansible** to deploy a secure, automated HTTP server on **Google Cloud Platform (GCP)**. It provisions a **Ubuntu 22.04 LTS** VM and configures it to serve a static `index.html` page via **Nginx**, using SSH key-based access.

---

## 🧰 Tools Used

| Tool      | Purpose                            |
| --------- | ---------------------------------- |
| Terraform | Infrastructure provisioning on GCP |
| Ansible   | Remote configuration via SSH       |
| GCP       | Cloud hosting platform             |
| Ubuntu    | Base image (22.04 LTS)             |
| Nginx     | HTTP server                        |

---

## 📁 Directory Structure

```plaintext
Project_5_GCP_HTTP_Server/
├── terraform/
│   ├── main.tf             # GCP resources (VM, firewall)
│   ├── variables.tf        # Project ID, region, zone
│   ├── outputs.tf          # External IP output
├── ansible/
│   ├── inventory.ini       # IP + SSH config
│   ├── playbook.yml        # Entry point for Ansible config
│   └── roles/
│       └── webserver/
│           ├── tasks/
│           │   └── main.yml
│           └── handlers/
│               └── main.yml
├── files/
│   └── index.html          # Custom homepage
├── README.md
```

---

## 🚀 How to Deploy

### 1️⃣ Authenticate with GCP

```bash
gcloud auth login
gcloud auth application-default login
```

Make sure billing is enabled and the Compute Engine API is activated.

---

### 2️⃣ Generate an SSH Keypair

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/gcp_terraform -C "you@example.com"
```

Do **not** set a passphrase. This public key will be injected by Terraform.

---

### 3️⃣ Set Variables in Terraform

Update your `terraform/terraform.tfvars` file or pass these values via CLI:

```hcl
project_id = "your-project-id"
region     = "australia-southeast1"
zone       = "australia-southeast1-a"
```

---

### 4️⃣ Provision the VM with Terraform

```bash
cd terraform
terraform init
terraform apply
```

At the end, Terraform will output an `external_ip` value.

---

### 5️⃣ Configure the Server with Ansible

1. Update the IP in `ansible/inventory.ini`:

```ini
[web]
<EXTERNAL_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/gcp_terraform
```

2. Run the playbook:

```bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
```

This installs Nginx, uploads `index.html`, and starts the service.

---

## 🌐 Access the Web Server

Visit:

```http
http://<EXTERNAL_IP>
```

You should see your custom web page.

---

## 🧼 Teardown – Remove All Resources

Run the following to avoid cloud charges:

```bash
cd terraform
terraform destroy
```

Optionally, delete the SSH keypair:

```bash
rm ~/.ssh/gcp_terraform ~/.ssh/gcp_terraform.pub
```

---

## 🧠 Notes

- VM type is within **GCP's free tier**
- Make sure `compute.googleapis.com` API is enabled
- This project is modular and can be extended to include SSL, DNS, monitoring, etc.

---

## 📚 References

- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Ansible User Guide](https://docs.ansible.com/)
- [GCP Free Tier](https://cloud.google.com/free/docs/gcp-free-tier)

---

Project by: *Your Name*


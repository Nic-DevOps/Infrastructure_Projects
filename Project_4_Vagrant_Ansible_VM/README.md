# Project 4: Local VM + Ansible

## 🧠 Goal
Provision a local Ubuntu virtual machine using Vagrant, and configure it using Ansible instead of shell scripts. This project focuses on **configuration management**, **idempotency**, and the use of **inventory files** and **roles**.

---

## 🧰 Tools & Technologies
- **Vagrant** (with VirtualBox)
- **Ansible** (installed inside the guest VM)
- **Ubuntu 18.04 (bionic64)**
- **NGINX** web server
- **Shared folders** to pass Ansible playbooks from host to VM

---

## 📂 Folder Structure

```plaintext
Project_4_Vagrant_Ansible_VM/
├── Vagrantfile
├── bootstrap.sh
├── ansible/
│   ├── playbook.yml
│   ├── inventory.ini
│   └── roles/
│       └── common/
│           ├── tasks/
│           │   └── main.yml
│           ├── handlers/
│           │   └── main.yml
│           └── files/
│               └── index.html
```

---

## ⚙️ How It Works

1. Vagrant provisions a local VM.
2. A shell script (`bootstrap.sh`) installs Ansible inside the guest.
3. Ansible runs `playbook.yml`, which:
   - Updates the system
   - Installs NGINX
   - Copies a custom HTML file
   - Ensures NGINX is enabled and running
4. At the end, Ansible displays a success message with the access URL.

---

## 🌐 Access the Web Server

Once provisioning completes, visit:  
👉 [http://192.168.56.10](http://192.168.56.10)

---

## 📚 Ansible Roles Reference

For a detailed explanation of Ansible’s role structure and best practices, see:  
🔗 [Ansible: Re-using Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)

---

## 🏁 To Run

```bash
vagrant up
```

To reprovision after changes:

```bash
vagrant provision
```

To destroy and restart:

```bash
vagrant destroy -f && vagrant up
```

---

## ✅ Learning Objectives
- Understand Ansible’s role structure and idempotent design
- Replace imperative scripts with declarative configuration
- Use inventory files to define connection and provisioning targets

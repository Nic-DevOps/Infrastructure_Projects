# Project 3: Nginx HTTP Server with Vagrant

## 🧠 Overview

This project provisions a lightweight Ubuntu VM using Vagrant and automatically installs and configures an Nginx web server using a shell bootstrap script.

It builds on **Project 2** by:
- Replacing Apache with Nginx
- Automating VM setup via shell scripting (Infrastructure as Code)
- Preparing for future enhancements like SSL, reverse proxying, or load balancing

---

## 📁 Directory Structure

```plaintext
Project-3-Vagrant-Nginx-HTTP-Server/
├── Vagrantfile
├── bootstrap.sh
├── README.md
└── nginx/
    └── index.html
```

---

## ⚙️ How It Works

- `Vagrantfile`: Defines the base box, forwarded ports, memory, CPU, and provisioning script.
- `bootstrap.sh`: Updates the VM, installs Nginx, and replaces the default index page with a custom one.
- `nginx/index.html`: The custom landing page served by Nginx.
- Nginx listens on port 80 inside the VM, and is mapped to port 8080 on the host machine.

---

## 🚀 Launch Instructions (PowerShell)

```powershell
cd "C:\Path\To\Infrastructure_Projects\Project-3-Vagrant-Nginx-HTTP-Server"
vagrant up
```

Once running, open your browser and go to:

```
http://localhost:8080
```

You should see a custom success message served by Nginx.

---

## 🛠️ Changes & Fixes Made

### ✅ Vagrantfile Adjustments
- Added `vb.memory = 512` and `vb.cpus = 1` to control VM resources explicitly
- Used `ubuntu/bionic64` as the base box
- Forwarded guest port 80 to host port 8080 for local access
- Specified shell provisioning with `bootstrap.sh`

### ✅ Provisioning Script (`bootstrap.sh`)
- Added `set -e` to fail early on errors
- Used `apt-get install -y` to prevent interactive prompts
- Replaced default Nginx index page with custom HTML if found
- Ensured Nginx is enabled to start on boot and restarted after install

### ✅ Index Page Enhancements
- Created a clean `index.html` with:
  - Project success message
  - Project number and purpose
  - Timestamp
  - GitHub repo link
  - Future project goals
- Added optional inline CSS styling for a polished look
---

## 🔍 Testing Tips

- To reprovision after changes:
  ```powershell
  vagrant reload --provision
  ```
- To destroy the VM:
  ```powershell
  vagrant destroy -f
  ```

- To SSH into the VM (via Git Bash or WSL):
  ```bash
  vagrant ssh
  ```

---

## 📌 Future Improvements

- Add SSL support using Let's Encrypt
- Configure reverse proxy to serve a dynamic app (e.g. Flask or Node.js)
- Monitor Nginx using systemd or custom health checks

---

## 🧩 Related Projects

- [Project 2: Apache HTTP Server with Vagrant](../Project-2-Vagrant-HTTP-Server)

# 🐧 Project B: Secure Linux Server Baseline
A secure-by-default Linux server configuration to serve as a repeatable baseline for cloud or on-prem environments. 
This project focuses on user access auditing, firewall hardening, resource usage monitoring, and system integrity protection—key elements for securing research, infrastructure, and production environments at organizations like Arc Institute, Ohalo, or Colossal.

## 🧠 Inspiration
This project was inspired by operational needs at secure scientific and biotech organizations. The aim is to provide an auditable, defensible, and replicable configuration baseline for Linux systems.

## 🔧 Objectives
- Harden SSH and local access to reduce attack surface
- Enforce least-privilege user access with logging
- Detect unusual application behavior or resource spikes
- Automate basic security patches and monitoring tools

## 📁 Directory Structure
```plaintext
Project_B_Secure_Linux_Baseline/
├── ansible/
│   └── hardening-playbook.yml
├── scripts/
│   ├── monitor-logins.sh
│   ├── resource-audit.sh
│   └── setup-fail2ban.sh
├── auditd/
│   └── rules.d/
│       └── access_monitor.rules
├── docs/
│   └── baseline-checklist.md
├── README.md
```
## 🔐 Security Components
- Area	Description	Tools
- SSH Hardening	Disable root login, enforce key auth	sshd_config, ufw, fail2ban
- Firewall	Allow only required ports	ufw
- Users & Groups	Lock down unused accounts, enforce sudo policies	chage, /etc/sudoers
- Patch Automation	Apply unattended security updates	unattended-upgrades
- File Integrity	Detect changes to critical files	AIDE, auditd

## 🕵️ User & Application Monitoring
- Feature	Description	Tools
- Login Alerts	Track SSH logins and failed attempts	journalctl, faillog
- Access Time Detection	Alert if access happens after-hours	auditd, cron + logger
- Process Monitoring	Log unexpected processes or services	ps, chkrootkit, lsof
- Resource Spikes	Audit unusual RAM/CPU usage	glances, htop, custom scripts

## 🚀 Getting Started
### 1. Provision a Fresh Ubuntu Server
Example with Vagrant (optional):
```
vagrant init ubuntu/bionic64
vagrant up
vagrant ssh
```
### 2. Run Hardening Scripts
```
sudo bash scripts/setup-fail2ban.sh
sudo bash scripts/monitor-logins.sh
sudo bash scripts/resource-audit.sh
```
### 3. Apply Ansible Playbook (Optional)
```
ansible-playbook ansible/hardening-playbook.yml -i localhost,
```
## 📋 Future Enhancements
 - Add OpenSCAP compliance scan
 - Centralized logging to ELK or Graylog
 - Integrate GitHub Actions to scan for misconfigurations


# 🛡️ Project K: Secure Research Infrastructure Monitoring Suite

## 🎯 Goal

Design and deploy a secure and observable infrastructure for a simulated research compute environment. Emphasizes **network security**, **access control**, **real-time monitoring**, and **proactive threat mitigation**.

---

## 🧰 Stack

| Layer        | Tools / Services                            |
| ------------ | ------------------------------------------- |
| Monitoring   | Prometheus, Grafana, Alertmanager           |
| Security     | Fail2ban, firewalld, SSH hardening          |
| Provisioning | Ansible (optional: Terraform for cloud VMs) |

---

## 📁 Directory Structure

```plaintext
Project_K_Secure_Research_Monitoring/
├── ansible/
│   ├── inventory.ini
│   ├── playbook.yml
│   └── roles/
│       ├── prometheus/
│       ├── grafana/
│       ├── fail2ban/
│       ├── ssh_hardening/
│       └── firewalld/
├── terraform/
│   ├── main.tf   # Optional: VM provisioning in AWS/GCP/OCI
├── files/
│   ├── grafana_dashboards/
│   └── research_app_logs/
├── README.md
```

---

## 🔬 Simulated Research Environment

* **Fake scientific workload logs** generated in `/var/log/research_app/`
* System monitored for:

  * CPU/RAM usage
  * SSH login attempts
  * Blocked IPs
  * Alerting on anomalous traffic or load spikes

---

## 🔐 Security Features

* **Fail2ban**: Automatically bans IPs with repeated SSH failures
* **firewalld**: Defines zones and allows only necessary ports
* **SSH Hardening**:

  * Disables root login
  * Enables key-based authentication
  * Limits login attempts
* **Unattended Upgrades**: Auto-patches known vulnerabilities (optional)

---

## 📊 Monitoring Suite

* **Prometheus**:

  * Scrapes metrics from node\_exporter and custom log exporters
* **Grafana**:

  * Visualizes system metrics and login activity
  * Includes prebuilt dashboards for:

    * SSH activity
    * CPU & Memory
    * Banned IP trends
* **Alertmanager**:

  * Sends alerts via email or webhook
  * Configurable thresholds for memory, CPU, unauthorized access attempts

---

## 🚀 Deployment

### 1. Set Up Inventory

Edit `ansible/inventory.ini` with your server IPs or hostnames.

### 2. Run Playbook

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

### 3. Access Dashboards

Grafana: `http://<your-server-ip>:3000`
Prometheus: `http://<your-server-ip>:9090`
(Default Grafana login: `admin / admin`)

---

## 🧼 Teardown

### Manual Teardown

```bash
sudo systemctl stop prometheus grafana-server
sudo yum remove prometheus grafana fail2ban firewalld -y
sudo rm -rf /etc/prometheus /etc/grafana /var/lib/grafana
```

### Terraform (if used)

```bash
cd terraform
terraform destroy
```

---

## 📚 References

* [Grafana Docs](https://grafana.com/docs/)
* [Prometheus Docs](https://prometheus.io/docs/)
* [Fail2ban](https://www.fail2ban.org/wiki/index.php/Main_Page)
* [firewalld](https://firewalld.org/)
* [Ansible Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)

---

## ✅ Key Concepts Demonstrated

* Secure system configuration for SSH and firewalls
* Real-time observability using Prometheus and Grafana
* Alerting with custom thresholds
* Infrastructure automation using Ansible and optionally Terraform
* Research lab security posture simulation

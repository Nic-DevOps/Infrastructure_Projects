# Infrastructure_Projects
A progressive project exploring Infrastructure as Code. Each project builds on the last—from local HTTP servers to cloud VMs, containers, CI/CD, and monitoring—using tools like Ansible, Terraform, and Docker to demonstrate real-world DevOps skills.


# ✅ Completed Projects
## [Project 1: Local HTTP Server (Python)](https://github.com/Nic-DevOps/Infrastructure_Projects/tree/main/Project_1_Local-HTTP-Server)
- Description: Simple local deployment using Python’s http.server.
- Tools Used: Python, shell script
- Key Concepts: Basic HTTP server, local networking, scripting

## [Project 2: Apache HTTP Server with Vagrant](https://github.com/Nic-DevOps/Infrastructure_Projects/tree/main/Project_2_Vagrant_HTTP_Server)
- Description: Spun up a local VM with an HTTP server using Vagrant.
- Tools Used: Vagrant, shell script provisioning
- Key Concepts: Virtualization, automated provisioning, shell scripting

## [Project 3: Vagrant + Nginx HTTP Server](https://github.com/Nic-DevOps/Infrastructure_Projects/tree/main/Project_3_Vagrant_Nginx_HTTP_Server)
- Description: Provisioned a VM via Vagrant and installed/configured Nginx to serve a static site.
- Tools Used: Vagrant, Nginx, shell script
- Key Concepts: Web server setup, VM provisioning, basic automation
## [Project 4: Local VM + Ansible](https://github.com/Nic-DevOps/Infrastructure_Projects/tree/main/Project_4_Vagrant_Ansible_VM)
- Goal: Provision a VM and configure it using Ansible instead of shell scripts. 
- Concepts: Configutation Management, idempotency, inventory files

## [Project 5: GCP HTTP Server (Terraform + Ansible)](https://github.com/Nic-DevOps/Infrastructure_Projects/tree/main/Project_5_GCP_HTTP_Server)
- Goal: Deploy an HTTP server on Google Cloud using Terraform for infrastructure and Ansible for configuration.

- Concepts: Infrastructure as Code (IaC), cloud provisioning, Ansible remote provisioning

# 🔜 Planned Projects


## Project 6: Dockerized Web App + Local Compose
- Goal: Containerize the HTTP server and run it using Docker Compose.

- Concepts: Containers, networking between services, persistent volumes

## Project 7: CI/CD Pipeline with GitHub Actions
- Goal: Automatically build and deploy a Dockerized web app to a staging server or container registry.

- Concepts: Continuous Integration, test/build/deploy automation

## Project 8: Kubernetes (Minikube) + Helm
- Goal: Deploy a multi-service app using Kubernetes locally with Helm charts.

- Concepts: Container orchestration, scaling, service discovery

## Project 9: Remote Monitoring + Logging
- Goal: Set up logging and monitoring (e.g., Prometheus + Grafana) for deployed services.

- Concepts: Observability, metrics, alerting

## Project 10: Full Cloud IaC Stack
- Goal: Combine everything—deploy a multi-service app to GCP/AWS using Terraform, Helm, and GitHub Actions.

- Concepts: Production-grade infrastructure, security, modular architecture

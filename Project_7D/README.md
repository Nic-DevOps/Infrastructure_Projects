# Project 7 – Multi‑Cloud VM (Virtual Machine) Provisioner

## 🎯 Goal

Provision and manage Virtual Machines (VMs) across **Google Cloud Platform (GCP)**, **Amazon Web Services (AWS)**, and **Microsoft Azure** using a unified, modular **Infrastructure as Code (IaC)** workflow powered by **Terraform**.

---

## 📑 Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Features](#features)
4. [Prerequisites](#prerequisites)
5. [Quick Start](#quick-start)
6. [Directory Structure](#directory-structure)
7. [Module Design](#module-design)
8. [Variables & Configuration](#variables--configuration)
9. [Security & Cost Controls](#security--cost-controls)
10. [Roadmap](#roadmap)
11. [Contributing](#contributing)
12. [License](#license)

---

## Overview

This project provides a single Terraform entry‑point (`main.tf`) that orchestrates cloud‑specific modules—`aws_vm`, `gcp_vm`, and `azure_vm`—to deliver identical,
minimal‑cost VM footprints in each provider.  The design keeps **provider differences isolated** inside modules so that the root configuration feels provider‑agnostic.  ✨

Use‑cases include:

* **Hands‑on IaC practice** across clouds without switching tooling or repo layout.
* **Cost‑conscious labs**—deploy only micro / free‑tier instances by default.
* **Foundation for CI/CD demos** where heterogeneous environments are required.

---

## Architecture


added ansible-galaxy collection install cloud.terraform
to automatically parse the outputs from terraform so ansible can create the inventories. 

```plaintext
                +----------------------+
                |     Terraform CLI    |
                +----------+-----------+
                           |
                           |  HCL configuration
                           v
+------------------- root ──main.tf────────────────-+
|                                                   |
|   +-----------+     +-----------+     +----------+|
|   |  module   |     |  module   |     |  module  ||
|   |  aws_vm   |     |  gcp_vm   |     | azure_vm ||
|   +-----+-----+     +-----+-----+     +----+-----+|
|         |                 |                |      |
+---------+-----------------+----------------+------+
          |                 |                |
  +-------+----+   +--------+----+    +------+------+
  | AWS VPC    |   | GCP VPC     |    | Azure VNet  |
  | EC2 t2.micro|  | e2‑micro    |    | B1s VM      |
  +------------+   +------------+    +-------------+
```

*All clouds expose inbound **SSH (Secure Shell)** and optional **HTTP** via provider‑appropriate security groups / firewall rules.*

---

## Features

| Category                     | Description                                                                                          |
| ---------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Provider Abstraction**     | Root module toggles each cloud via boolean variables (`deploy_aws`, `deploy_gcp`, `deploy_azure`).   |
| **Free‑tier Defaults**       | Instance types (`t2.micro`, `e2‑micro`, `B1s`) and disks stay within free allowances where possible. |
| **Minimal Blast‑Radius**     | Each provider gets its own VPC (Virtual Private Cloud)/VNet in a single region set by `*.tfvars`.    |
| **SSH Bootstrap (optional)** | Pass your public key to enable login; or extend with cloud‑init / Ansible later.                     |
| **Tag/Label Propagation**    | Common labels (`project_name`, `environment`, `owner`) automatically applied across clouds.          |
| **One‑Command Cleanup**      | `terraform destroy` tears down *only* what you created.                                              |

---

## Prerequisites

* **Terraform >= 1.6** installed and on your `PATH`.
* Cloud accounts with billing enabled:

  * **AWS** with an **Access Key ID / Secret Access Key** *(store in environment variables)*
  * **GCP** with a **service account JSON key**
  * **Azure** with a **Service Principal** or Azure CLI login
* Optional: **ssh‑keygen** to generate a key pair (`~/.ssh/id_rsa.pub`).

> **Tip 📌**: Never commit secrets. Use `terraform.tfvars` (git‑ignored) or environment variables.

---

## Quick Start

```bash
# 1. Clone the repo
$ git clone https://github.com/your‑org/Infrastructure_Projects.git
$ cd Infrastructure_Projects/Project_7_Multi‑Cloud_VM_Provisioner/

# 2. Copy the example vars and fill in *one* cloud to start
$ cp terraform.tfvars.example terraform.tfvars
$ nano terraform.tfvars   # or your editor

# 3. Initialize providers & modules
$ terraform init

# 4. See the execution plan
$ terraform plan

# 5. Apply 🏗️
$ terraform apply   # type 'yes' when prompted

# 6. Verify and SSH in
$ terraform output
$ ssh ubuntu@$(terraform output -raw aws_public_ip)

# 7. Clean up when done
$ terraform destroy
```

---

## Directory Structure

```plaintext
Project_7_Multi‑Cloud_VM_Provisioner/
├── modules/
│   ├── aws_vm/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── gcp_vm/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── azure_vm/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── examples/
│   └── single_cloud/
│       └── terraform.tfvars
├── .gitignore
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars.example
```

*Tree‑style rendered with `plaintext` fencing to meet parsing constraints.*

---

## Module Design

Each module wraps the provider‑specific resources needed to stand up a single VM:

| Module     | Region Variable | Key Resources                                                                          | Notes                                                                           |
| ---------- | --------------- | -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `aws_vm`   | `aws_region`    | `aws_vpc`, `aws_subnet`, `aws_security_group`, `aws_instance`                          | Maps **user\_data** to `cloud‑init` via `templatefile()` for customization.     |
| `gcp_vm`   | `gcp_region`    | `google_compute_network`, `google_compute_instance`                                    | Uses `boot_disk` with a small **Persistent Disk** in the same zone.             |
| `azure_vm` | `azure_region`  | `azurerm_resource_group`, `azurerm_network_interface`, `azurerm_linux_virtual_machine` | Leverages `azurerm_linux_virtual_machine` simplified resource (Terraform 1.6+). |

---

## Variables & Configuration

Terraform uses **variable declarations** (`variables.tf`) to *define* required inputs and optional defaults, while **input files** like `terraform.tfvars` *assign* values at runtime.

```hcl
# variables.tf
variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us‑west‑2"   # can be overridden
}
```

```hcl
# terraform.tfvars
aws_region = "us‑east‑1"   # overrides the default
```

*Why separate the two?* Keeping definitions in `variables.tf` documents **what** can be tuned, while `.tfvars` (git‑ignored) captures **your private choices**—credentials, regions, instance counts—without polluting version control.

---

## Security & Cost Controls

* All secrets pass via environment variables or untracked `*.tfvars`.
* Default instance sizes stay inside free tiers, but *double‑check* each cloud’s current limits.
* Add **Terraform Cloud Cost Estimation** or third‑party plugins if you need automatic budget gates.

---

## Roadmap

* [ ] **Cloud‑Init Modules** for post‑boot provisioning.
* [ ] **Auto‑Scaling Demo**: show how to switch the count to `for_each` maps.
* [ ] **Monitoring Stack**: optional Prometheus + Grafana side modules.
* [ ] **CI Pipeline**: integrate with GitHub Actions (Project 8) for automated `plan`/`apply`.

---

# Updates 
- 2025-07-23: Added a count variable so I can create multiple vm's just on GCP. This is in preperation to add monitoring.
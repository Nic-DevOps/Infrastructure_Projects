Atomic Steps: Cluster Setup with Slurm + Grafana
🧱 Phase 1: VM Provisioning (Infrastructure First)
Provision controller node VM (e.g., controller) 

Provision compute node VMs (e.g., compute1, compute2, etc.) 

Set static hostnames and IPs on each VM (or configure DNS)

Enable SSH access between nodes (e.g., passwordless SSH from controller to compute nodes)

🧰 Phase 2: Core Services (Base Layer)
Install system dependencies

munge, slurm-wlm, python3, etc.

Set up Munge key on controller

Distribute Munge key to compute nodes

Enable and start Munge service on all nodes

🧮 Phase 3: Install & Configure Slurm
Create a shared or identical slurm.conf on all nodes

Start Slurm controller (slurmctld) on controller

Start Slurm daemons (slurmd) on compute nodes

Test with simple jobs (srun, sbatch) to validate cluster behavior

📈 Phase 4: Monitoring Stack (Grafana + Prometheus)
Install prometheus-slurm-exporter on all nodes (or just controller if you prefer limited metrics)

Install Prometheus on a monitoring node or on the controller itself

Configure Prometheus scrape targets for all Slurm nodes

Install Grafana

Connect Grafana to Prometheus as a data source

Import a Slurm dashboard or build custom ones

(Optional): Configure alerting rules (e.g., node down, job failures, CPU usage)


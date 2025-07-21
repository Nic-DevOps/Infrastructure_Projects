1. Spin‑up two tiny cloud nodes using terraform I'll use gcp for now
Service: AWS free‑tier t2.micro (1 vCPU, 1 GiB).

AMI: Ubuntu 22.04 LTS (smallest supported by SchedMD packages).

Networking:

Put both instances in the same VPC + subnet so they share a low‑latency private address.

Open only SSH (22) inbound from your IP; everything else can stay internal.

Hostnames: ‑ head (runs slurmctld, slurmdbd, Prometheus, Grafana) ‑ node1 (runs slurmd only)







2. Install Slurm using SchedMD’s quick‑start DEB repo
bash
Copy
Edit
# on BOTH machines (adjust version as needed)
sudo apt-get update && sudo apt-get -y install slurm-wlm
Then follow SchedMD’s Quick‑Start User Guide to generate a minimal slurm.conf and copy it to /etc/slurm-llnl/ on both boxes. The quick‑start page shows the template and each parameter you need (ClusterName, NodeName, PartitionName, etc.). 
Slurm
Slurm

⚠️ Memory: Slurm’s default DefMemPerCPU=1024 will exhaust a t2.micro. Set something tiny (e.g. DefMemPerCPU=256, MaxMemPerCPU=512).

3. Smoke‑test the scheduler
bash
Copy
Edit
# on head node
sudo systemctl restart slurmctld
srun -N2 --ntasks-per-node=1 hostname
Both hostnames should print—proof that Slurm can allocate one task on each node. (If you hit “munge” auth errors, confirm both machines share /etc/munge/munge.key and the munge service is running.)

4. Run the canonical Nextflow “hello” on Slurm
Install Nextflow on the head node:

bash
Copy
Edit
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/
Add an executor stanza in ~/.nextflow/config (user‑level) or nextflow.config (project):

groovy
Copy
Edit
process {
  executor = 'slurm'
  queue    = 'debug'   // your PartitionName
  cpus     = 1
  memory   = '256 MB'
}
Run:

bash
Copy
Edit
nextflow run hello
The official Nextflow training modules show the same config and explain each directive. 
training.nextflow.io
training.nextflow.io

5. Add cluster telemetry (Prometheus + Grafana + Slurm exporter)
Component	Where to run	How to install
prometheus‑slurm‑exporter	head node	git clone https://github.com/vpenso/prometheus-slurm-exporter.git && make && sudo make install 
GitHub
Prometheus	head node	Docker is easiest:
docker run -d --name prom -p 9090:9090 -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
Grafana	head node	docker run -d --name graf -p 3000:3000 grafana/grafana

prometheus.yml minimal scrape config:

yaml
Copy
Edit
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'slurm'
    static_configs:
      - targets: ['localhost:9810']   # default exporter port
After Prometheus is up, import an off‑the‑shelf Grafana dashboard:

Dashboard ID 4323 – SLURM Dashboard 
Grafana Labs

Dashboard ID 19835 – Slurm Dashboard v2 (more modern panels) 
Grafana Labs

Both expect the same exporter metrics and work fine on a two‑node lab.

6. Full walkthroughs & troubleshooting references
Topic	Resource
Slurm controller + compute nodes on Ubuntu 22.04	Blog: How to set‑up HPC‑Slurm Controller Node (includes common pitfalls) 
nicktailor.com
One‑box or tiny Slurm installs	StackOverflow Q&A with forum guide link 
Stack Overflow
AWS ParallelCluster alternative (larger future upgrade)	AWS docs showing automated Slurm install script 
AWS Documentation
Nextflow‑on‑Slurm discussion + sample configs	GitHub discussion #3649 
GitHub
Grafana JSON dashboards for Slurm exporter	GitHub flatironinstitute/slurm-prometheus-exporter/grafana/running.json 
GitHub

7. Putting it together – order of operations
Create EC2 instances → verify SSH keys and /etc/hosts entries.

Install & configure Munge (shared key).

Install Slurm packages → start slurmctld, slurmd.

Smoke‑test with srun hostname.

Install Nextflow → run the hello pipeline.

Compile & start Slurm exporter.

Deploy Prometheus + Grafana (Docker) → import dashboard, confirm metrics.

Iterate: try a multithreaded Nextflow sample or add a GPU‑flavored partition (when you upgrade to GPU instances).
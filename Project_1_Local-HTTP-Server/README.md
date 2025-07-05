# Project 1: Local HTTP Server

This project sets up a basic HTTP server on your local machine using Python and a Bash script. It's the first step in a larger Infrastructure as Code (IaC) progression, helping you understand local service provisioning, scripting, and basic automation.

---

## 🚀 Purpose

- Deploy a simple local web server using minimal tools
- Learn foundational scripting for automation
- Set up a reproducible file structure for future projects

---

## 🗂️ Project Structure

```plaintext
project-01-local-http-server/
├── config/
│   └── index.html              # Static web page served by the server
├── scripts/
│   ├── start_server.sh         # Bash script to start the server
│   └── http_server.py (optional) # Alternative manual server in Python
├── tests/
│   ├── curl_test.sh            # Script to verify if the server is running
│   └── test_script_explained.md # Explanation of key commands used in tests
├── README.md                   # This file
```

---

## ⚙️ Prerequisites

- Python 3.x installed (`python3 --version`)
- Bash-compatible shell (Git Bash, WSL, or macOS/Linux)
- (Optional) `curl` installed for testing

---

## 🛠️ How to Run

### 1. Start the Server

```bash
bash scripts/start_server.sh
```

This serves files from the `config/` directory on port `8000`.

### 2. Open in Your Browser

Go to: [http://localhost:8000](http://localhost:8000)

You should see the contents of `config/index.html`.

### 3. Run a Test (Optional)

To verify the server is live using `curl`:

```bash
bash tests/curl_test.sh
```

---

## 🧪 Troubleshooting

### Exit Code 49?

This may indicate:
- A firewall or antivirus blocking Python from opening the port
- Port `8000` already in use (try `PORT=8081` in the script)
- Python not correctly installed or missing permissions

Check out `tests/test_script_explained.md` for command breakdowns.

---

## 📦 Next Steps

Future projects will build on this by adding:
- Configuration management with Ansible
- Cloud infrastructure provisioning (e.g., Terraform + GCP)
- Containerization and orchestration

Stay tuned.

# Project 6: Dockerized Web App + Local Compose

## 🚀 Goal
Containerize the HTTP server and run it using Docker Compose.

## 🧰 Concepts
- Containers (Docker)
- Networking between services (Docker Compose networks)
- Persistent volumes

---

## 📂 Directory Structure
```plaintext
Project_6_Docker_WebApp/
├── app/
│   └── index.html               # Static HTML file served by NGINX
├── Dockerfile                   # Builds the NGINX image with custom content
├── docker-compose.yml           # Orchestrates the containerized web app
├── README.md                    # Project documentation
└── .gitignore                   # Optional: ignore build artifacts and volumes
```

---

## 🔧 Setup Instructions

### 1. Clone Repository
```bash
git clone https://github.com/<your-username>/Infrastructure_Projects.git
cd Infrastructure_Projects/Project_6_Docker_WebApp
```

### 2. Create `index.html`
```html
<!-- app/index.html -->
<!DOCTYPE html>
<html>
<head>
  <title>Docker Web App</title>
</head>
<body>
  <h1>Hello from Docker!</h1>
</body>
</html>
```

### 3. Create `Dockerfile`
```Dockerfile
# Use NGINX image
FROM nginx:alpine

# Copy web content to nginx default directory
COPY ./app /usr/share/nginx/html
```

> ✅ **About the base image**: `nginx:alpine` is pulled from [Docker Hub](https://hub.docker.com/_/nginx), the default public container registry. Alpine is a lightweight Linux distribution (~5MB), making the resulting container small and fast. Docker will pull the image if it’s not cached locally.

### 4. Create `docker-compose.yml`
```yaml
# docker-compose.yml

version: '3.8'

services:
  web:
    build: .  # Builds the image using the Dockerfile in the current directory
    ports:
      - "8080:80"  # Exposes port 8080 on the host, mapped to port 80 in the container (NGINX)
    volumes:
      - ./app:/usr/share/nginx/html:ro  # Mounts the local app/ directory into the container as read-only
    networks:
      - webnet  # Connects this service to the custom network 'webnet'

networks:
  webnet:
    driver: bridge  # Uses the default bridge network driver
```

---

## 🚀 How to Run
```bash
docker-compose up --build
```

Visit the app at:
```
http://localhost:8080
```

---

## ⚙️ Teardown
```bash
docker-compose down
```

---

## 🛋️ Understanding Docker Compose Networks
Docker Compose allows services (containers) to communicate over user-defined networks. This project uses a custom network called `webnet`.

### Why it matters:
- Containers can **refer to each other by service name** (like `web`, `db`, `backend`).
- They are **isolated from unrelated services** unless added to the same network.
- The `bridge` driver creates an **internal virtual network** that connects services securely on the same host.

Even though this project only has one service (`web`), adding others (like a backend API or database) later will let them talk directly via this network. This is a core concept in microservice architecture and multi-container apps.

---

## 📃 Notes
- Persistent volume is read-only for simplicity in this example.
- You can extend this to include a backend service (e.g., Flask, Node) and database (e.g., PostgreSQL) in the Compose file.
- For production, use a reverse proxy, health checks, and external volume mounts for data persistence.

---

## 🔗 Related
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

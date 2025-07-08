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
│   ├── index.html
├── Dockerfile
├── docker-compose.yml
└── README.md
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

### 4. Create `docker-compose.yml`
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "8080:80"
    volumes:
      - ./app:/usr/share/nginx/html:ro
    networks:
      - webnet

networks:
  webnet:
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

## 📃 Notes
- Persistent volume is read-only for simplicity in this example.
- You can extend this to include a backend service (e.g., Flask, Node) and database (e.g., PostgreSQL) in the Compose file.
- For production, use a reverse proxy, health checks, and external volume mounts for data persistence.

---

## 🔗 Related
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

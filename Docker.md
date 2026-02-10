## Docker Load Balancing with Python Application using Nginx

This project demonstrates how to deploy multiple Python Flask backend services and use Nginx as a load balancer to distribute incoming traffic between them using Docker Compose.

# 🧠Architecture Overview
```
Client Browser
      |
      v
 Nginx Load Balancer (Port 80)
      |
      +--> backend1 (Flask :5000)
      |
      +--> backend2 (Flask :5000)
      |
      +--> backend3 (Flask :5000)
```	  
Each backend returns its container hostname, making it easy to verify load balancing.

# ✅ Features

- Python Flask backend services

- Nginx reverse proxy & load balancer

- Dockerized applications

- Managed using Docker Compose

- Round-robin traffic distribution

# 📁 Project Structure
```
├── app.py
├── requirements.txt
├── Dockerfile
├── nginx.conf
├── docker-compose.yml
```
# 🛠️Technologies Used

- Python 3.9  
- Flask  
- Nginx  
- Docker  
- Docker Compose


# 1️.Flask Application (app.py)

```bash
from flask import Flask
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    return f"Hello from {socket.gethostname()}!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
	
```

Each request responds with the container hostname.

# 2️.Dependencies (requirements.txt)
```
flask
```
# 3️.Dockerfile (Backend Service)
```bash

FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

# 4️.Nginx Load Balancer Configuration (nginx.conf)
```

upstream backend {
    server backend1:5000;
    server backend2:5000;
    server backend3:5000;
}

server {
    listen 80;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
Nginx distributes traffic across all backend containers.

# 5️.Docker Compose Configuration (docker-compose.yml)
```bash

version: '3'

services:
  nginx:
    image: nginx:latest
    container_name: nginx-lb
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - backend1
      - backend2
      - backend3

  backend1:
    build: .
    container_name: backend1
    expose:
      - "5000"

  backend2:
    build: .
    container_name: backend2
    expose:
      - "5000"

  backend3:
    build: .
    container_name: backend3
    expose:
      - "5000"
```

# ▶️ How to Run the Project

Step 1: Build & start containers
```bash
docker-compose up -d --build
```

Step 2: Verify running containers
```bash
docker ps
```
Step 3: Access the application

Open in browser:

http://<YOUR_SERVER_IP>


Refresh the page multiple times — you’ll see responses from different backend containers, confirming load balancing 


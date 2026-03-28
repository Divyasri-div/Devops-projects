

## 🧾 Project Title

**Kubernetes Deployment of MongoDB and Mongo Express**

---

## 🧠 Project Overview


This project demonstrates deploying a **full-stack application** on Kubernetes:

* **MongoDB** → Backend Database
* **Mongo Express** → Frontend UI
* Communication via **Kubernetes Services**
* Secure credentials using **Secrets**
* Configuration using **ConfigMap**

---

## 🏗️ Architecture

```text
User (Browser)
      ↓
Mongo Express (Frontend Pod)
      ↓
Kubernetes Service (mongodb-service)
      ↓
MongoDB (Backend Pod)
```

---

## 🧩 Kubernetes Components Used

| Component  | Purpose                     |
| ---------- | --------------------------- |
| Deployment | Manages Pods                |
| Service    | Enables communication       |
| Secret     | Stores credentials securely |
| ConfigMap  | Stores configuration        |

---

## 📁 Project Structure

```
k8s-mongo-project/
│
├── mongodb-secret.yml
├── mongodb.yml
├── mongo-configmap.yaml
├── mongo-express.yaml
```

---

## 🔐 Step 1: Create Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongodb-secret
type: Opaque
data:
  mongo-root-username: YWRtaW4=
  mongo-root-password: YWRtaW4xMjM=
```

---

## 🗄️ Step 2: MongoDB Deployment & Service

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo
        ports:
        - containerPort: 27017
        env:
        - name: MONGO_INITDB_ROOT_USERNAME
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: mongo-root-username
        - name: MONGO_INITDB_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: mongo-root-password

---
apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
spec:
  selector:
    app: mongodb
  ports:
    - port: 27017
      targetPort: 27017
```

---

## ⚙️ Step 3: ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mongodb-configmap
data:
  database_url: mongodb-service
```

---

## 💻 Step 4: Mongo Express Deployment & Service

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-express
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongo-express
  template:
    metadata:
      labels:
        app: mongo-express
    spec:
      containers:
      - name: mongo-express
        image: mongo-express
        ports:
        - containerPort: 8081
        env:
        - name: ME_CONFIG_MONGODB_ADMINUSERNAME
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: mongo-root-username
        - name: ME_CONFIG_MONGODB_ADMINPASSWORD
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: mongo-root-password
        - name: ME_CONFIG_MONGODB_SERVER
          value: mongodb-service

---
apiVersion: v1
kind: Service
metadata:
  name: mongo-express-service
spec:
  type: NodePort
  selector:
    app: mongo-express
  ports:
    - port: 8081
      targetPort: 8081
      nodePort: 30000
```

---

## 🚀 Deployment Steps

```bash
kubectl apply -f mongodb-secret.yml
kubectl apply -f mongodb.yml
kubectl apply -f mongo-configmap.yaml
kubectl apply -f mongo-express.yaml
```

---

## 🌐 Access Application

### Option 1 (Minikube local)

```bash
minikube service mongo-express-service
```

### Option 2 (EC2 / Remote)

```bash
kubectl port-forward --address 0.0.0.0 service/mongo-express-service 8081:8081
```

Open in browser:

```
http://<EC2-Public-IP>:8081

```
<h3 align="left">mongo-express-UI</h3>
<p align="left">
  <img src="./images/mongo-express-UI.png" alt="mongo-express-UI" 
       width="500" height="300" 
       style="border:8px solid black; border-radius:5px;">
</p>


✅ Verification Commands

kubectl get pods
kubectl get services
kubectl get deployments


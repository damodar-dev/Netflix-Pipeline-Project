# 🎬 Netflix Pipeline Project — Jenkins Pipeline CI/CD on AWS

---

## 📌 Project Overview

This project demonstrates a **Jenkins Declarative Pipeline CI/CD** built on AWS Cloud.  
A Java-based Netflix clone web application is automatically built, stored as an artifact in S3,  
and deployed to Apache Tomcat — all triggered by a GitHub code push with **zero manual steps**.

> ✅ Code Push → GitHub Webhook → Jenkins Pipeline → Maven Build → S3 Artifact → Tomcat Deployment

---

## 🏗️ Architecture Diagram

```
Developer
    │
    │  git push
    ▼
┌─────────────┐
│   GitHub    │  ── Webhook Trigger ──▶  ┌─────────────────┐
│  Repository │                          │  Jenkins Server  │
└─────────────┘                          │   (EC2 Linux)    │
                                         └────────┬────────┘
                                                  │
                                         Jenkinsfile (Pipeline)
                                                  │
                              ┌───────────────────▼──────────────────┐
                              │           Pipeline Stages             │
                              │  Stage 1: Checkout                    │
                              │  Stage 2: Build (mvn clean package)   │
                              │  Stage 3: Upload Artifact to S3       │
                              │  Stage 4: Deploy to Tomcat            │
                              └──────────┬──────────────┬────────────┘
                                         │              │
                                  ┌──────▼──┐   ┌───────▼────────┐
                                  │  AWS S3  │   │ Apache Tomcat  │
                                  │(Artifact │   │  (EC2 Linux)   │
                                  │ Storage) │   │  Port: 8081    │
                                  └─────────┘   └───────────────┘
```

---

## ⚙️ Tech Stack

| Category | Tool / Service | Purpose |
|---|---|---|
| Source Control | GitHub | Code repository & webhook trigger |
| CI/CD | Jenkins **Pipeline (Declarative)** | Automated multi-stage pipeline |
| Pipeline Definition | Jenkinsfile | Pipeline as Code |
| Build Tool | Maven | Compile & package Java app (.war) |
| Language | Java 21 | Application runtime |
| Web Server | Apache Tomcat | Application deployment (port **8081**) |
| Cloud Compute | AWS EC2 (Amazon Linux) | Hosting Jenkins & Tomcat |
| Artifact Storage | AWS S3 | Store & version build artifacts |
| Security | AWS IAM Role | Secure, credential-free S3 access |
| Storage | AWS EBS (30GB) | EC2 persistent storage |
| Region | ap-south-1 (Mumbai) | AWS deployment region |

---

## 🔧 Infrastructure Setup

### EC2 Instance
- **AMI:** Amazon Linux 2
- **Storage:** 30 GB EBS
- **Region:** ap-south-1 (Mumbai)
- **IAM Role:** Attached for secure S3 access (no hardcoded credentials)

### Security Group Rules

| Port | Protocol | Purpose |
|------|----------|---------|
| 22 | SSH | Remote server access |
| 8080 | TCP | Jenkins Web UI |
| 8081 | TCP | Apache Tomcat App |

---

## 🛠️ Tools Installation

```bash
# Update system
sudo yum update -y

# Install Java 21
sudo yum install java-21-amazon-corretto -y

# Install Git
sudo yum install git -y

# Install Maven
sudo yum install maven -y

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Apache Tomcat
wget https://downloads.apache.org/tomcat/tomcat-9/v9.x.x/bin/apache-tomcat-9.x.x.tar.gz
tar -xvzf apache-tomcat-9.x.x.tar.gz
```

---

## 🐱 Tomcat Configuration

### 1. Change Default Port to 8081 (server.xml)
```xml
<!-- Changed from 8080 to 8081 to avoid conflict with Jenkins -->
<Connector port="8081" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

### 2. Configure User Roles (tomcat-users.xml)
```xml
<tomcat-users>
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <user username="admin" password="admin123"
        roles="manager-gui,manager-script"/>
</tomcat-users>
```

### 3. Update context.xml (Allow Remote Access)
```xml
<!-- Comment out the RemoteAddrValve in both files below -->
<!-- webapps/manager/META-INF/context.xml -->
<!-- webapps/host-manager/META-INF/context.xml -->

<!--
<Valve className="org.apache.catalina.valves.RemoteAddrValve"
       allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
-->
```

### 4. Start Tomcat
```bash
cd apache-tomcat-9.x.x/bin
./startup.sh
```

---

## 🔁 Jenkins Pipeline Setup

### Step 1 — Initial Setup
```bash
# Get Jenkins initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 2 — Install Required Plugins
Navigate to: `Manage Jenkins → Plugin Manager → Available`

- ✅ **Pipeline** — Core pipeline support
- ✅ **S3 Publisher** — Upload artifacts to AWS S3
- ✅ **Deploy to Container** — Deploy .war to Tomcat
- ✅ **GitHub Integration** — Webhook support

### Step 3 — Global Tool Configuration
Navigate to: `Manage Jenkins → Global Tool Configuration`
- Configure **JDK 21** path
- Configure **Maven** installation

### Step 4 — Create Pipeline Job (Netflix)

**Pipeline Definition:**
```
✅ Pipeline script from SCM
SCM: Git
Repository URL: https://github.com/damodar-dev/Netflix-Pipeline-Project.git
Branch: */master
Script Path: Jenkinsfile
```

**Build Trigger:**
```
✅ GitHub hook trigger for GITScm polling
```

---

## 📄 Jenkinsfile (Pipeline as Code)

```groovy
pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK21'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/damodar-dev/Netflix-Pipeline-Project.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Upload to S3') {
            steps {
                s3Upload(
                    bucket: 'your-s3-bucket-name',
                    path: 'artifacts/',
                    includePathPattern: '**/*.war'
                )
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                deploy(
                    adapters: [
                        tomcat9(
                            credentialsId: 'tomcat-credentials',
                            path: '',
                            url: 'http://<EC2-PUBLIC-IP>:8081'
                        )
                    ],
                    contextPath: 'netflix',
                    war: '**/*.war'
                )
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully — App is LIVE!'
        }
        failure {
            echo '❌ Pipeline failed — Check the logs above.'
        }
    }
}
```

---

## 🔒 AWS IAM Role Setup (Security Best Practice)

Instead of using AWS Access Keys, an **IAM Role** is attached directly to the EC2 instance.

### IAM Role Policy (S3 Access)
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
```

> ✅ Jenkins uploads artifacts to S3 **without any hardcoded credentials** — following AWS security best practices.

---

## 🔗 GitHub Webhook Setup

1. Go to your GitHub repo → **Settings → Webhooks → Add webhook**
2. Set **Payload URL:** `http://<JENKINS-EC2-IP>:8080/github-webhook/`
3. Content type: `application/json`
4. Select: **Just the push event**
5. Click **Add webhook**

> Every `git push` to master automatically triggers the Jenkins Pipeline.

---

## 📦 CI/CD Pipeline Flow

```
1. Developer pushes code to GitHub (master branch)
         ↓
2. GitHub Webhook notifies Jenkins automatically
         ↓
3. Jenkins picks up Jenkinsfile from repo
         ↓
4. Stage 1 — Checkout: pulls latest code
         ↓
5. Stage 2 — Build: mvn clean package
   → Compiles Java code
   → Runs tests
   → Packages into .war file
         ↓
6. Stage 3 — Upload: .war pushed to AWS S3
   (secure access via IAM Role — no credentials needed)
         ↓
7. Stage 4 — Deploy: .war deployed to Apache Tomcat (port 8081)
         ↓
8. Application is LIVE ✅
```

---

## ✅ Results & Outcomes

- ✅ Fully automated Pipeline — zero manual deployment steps
- ✅ Pipeline as Code using **Jenkinsfile** (version-controlled)
- ✅ Build artifacts versioned and stored in AWS S3
- ✅ Secure AWS access using IAM Roles (no hardcoded keys)
- ✅ GitHub Webhook triggers instant builds on every code push
- ✅ Apache Tomcat serves the application on port 8081
- ✅ Jenkins (8080) and Tomcat (8081) run on same EC2 without port conflicts

---

## 🔍 Freestyle vs Pipeline — Key Difference

| Feature | Amazon Prime (Freestyle) | Netflix (Pipeline) |
|---|---|---|
| Job Type | Freestyle Job | Declarative Pipeline |
| Configuration | GUI-based (click & configure) | Code-based (Jenkinsfile) |
| Version Control | ❌ Not version-controlled | ✅ Jenkinsfile in repo |
| Stages | Single build step | Multiple defined stages |
| Visibility | Basic console output | Stage-by-stage view |
| Best For | Simple projects | Complex, production pipelines |
| Tomcat Port | 9090 | 8081 |

---

## 📁 Project Structure

```
Netflix-Pipeline-Project/
├── src/
│   ├── main/
│   │   ├── java/          # Java source code
│   │   └── webapp/        # Web application files
│   └── test/              # Unit tests
├── Jenkinsfile            # Pipeline as Code ⭐
├── pom.xml                # Maven build configuration
└── README.md              # Project documentation
```

---

## 🧠 Key Learnings

- Jenkins **Declarative Pipeline** design with Jenkinsfile
- **Pipeline as Code** — version-controlled CI/CD
- Multi-stage pipeline visualization in Jenkins UI
- AWS IAM Role-based access (security best practice)
- Artifact management & versioning with S3
- Apache Tomcat server administration & port configuration
- GitHub Webhook integration for automated triggers
- Difference between Freestyle and Pipeline Jenkins jobs

---

## 👨‍💻 Author

**S Damodararao**
DevOps & Cloud Engineer
📧 [damodarsampatirao@gmail.com](mailto:damodarsampatirao@gmail.com)
🔗 [LinkedIn](https://www.linkedin.com/in/sdamodararao/)
🐙 [GitHub](https://github.com/damodar-dev)
📞 [+91 73308 19064](tel:+917330819064)

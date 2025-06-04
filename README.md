# 🚀 Ansible Lab: Multi-Container Role-Based Automation

![Banner](https://raw.githubusercontent.com/ahmadsheikhi89/Ansible-multi-container-setup/main/banner.png)

<p align="center">
  <a href="https://www.ansible.com/"><img src="https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white" /></a>
  <a href="https://ubuntu.com/"><img src="https://img.shields.io/badge/Ubuntu-22.04-E95420?logo=ubuntu&logoColor=white" /></a>
  <a href="https://www.docker.com/"><img src="https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" /></a>
</p>

---

## 📘 Overview

This project is a **beginner-friendly Ansible lab** demonstrating how to launch and manage multiple **Nginx containers** using a clean and production-friendly Ansible structure. Ideal for local testing and DevOps learning.

### 🔍 Key Features

* 🐧 Run three Nginx containers on a single host
* ⚙️ Fully automated container creation with Ansible
* 🧩 Minimal yet extensible Ansible role layout

---

## 🧠 Project Structure

```bash
Ansible-multi-container-setup/
├── ansible.cfg                  # Ansible configuration file
├── group_vars/
│   └── web.yml                 # Group variables (defines nginx image and container config)
├── inventory/
│   └── hosts                   # Inventory file listing managed hosts
├── playbooks/
│   └── site.yml               # Main playbook to run the deployment
├── roles/
│   └── web/                   # Ansible role for Nginx
│       ├── handlers/
│       │   └── main.yml       # Placeholder for handlers (optional)
│       ├── tasks/
│       │   └── main.yml       # Role tasks (can be extended)
│       └── templates/
│           └── nginx.conf.j2  # Nginx config template (optional for customization)
├── README.md                  # This documentation
├── LICENSE                    # License file
└── site.yml                   # Shortcut to playbooks/site.yml
```

---

## ⚡ Getting Started

### ✅ Clone the Repository

```bash
git clone https://github.com/ahmadsheikhi89/Ansible-multi-container-setup.git
cd Ansible-multi-container-setup
```

### 🛠 Requirements

* Docker
* Ansible (with community.docker collection)

### 🧱 Install Requirements

#### ✅ Install Docker (Official Script)

```bash
# Quick install (one-liner)
curl -fsSL https://get.docker.com | sudo sh

# Or download and run manually
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
```

#### ✅ Install Ansible

```bash
sudo apt update
sudo apt install -y ansible
```

#### ✅ Install Ansible Docker Collection

```bash
ansible-galaxy collection install community.docker
```

---

### 🚀 Run the Playbook

```bash
ansible-playbook -i inventory/hosts playbooks/site.yml
```

---

## 🧾 Configuration Files

### 📄 inventory/hosts

```ini
[web]
localhost ansible_connection=local
```

### 📄 group\_vars/web.yml

```yaml
web_containers:
  - name: nginx1
    published_port: 8081
  - name: nginx2
    published_port: 8082
  - name: nginx3
    published_port: 8083

nginx_image: nginx:latest
```

### 📄 playbooks/site.yml

```yaml
- name: Build and configure containers on all web hosts
  hosts: web
  become: true
  vars_files:
    - ../group_vars/web.yml

  tasks:
    - name: Pull nginx image
      docker_image:
        name: "{{ nginx_image }}"
        source: pull

    - name: Run nginx containers
      docker_container:
        name: "{{ item.name }}"
        image: "{{ nginx_image }}"
        state: started
        restart_policy: always
        published_ports:
          - "{{ item.published_port }}:80"
      loop: "{{ web_containers }}"
```

### 📄 roles/web/tasks/main.yml

```yaml
# This file can be used for more complex role-based tasks
- name: Placeholder for web role tasks
  debug:
    msg: "Web role task running..."
```

### 📄 roles/web/handlers/main.yml

```yaml
# Add handlers here if needed (e.g., restart nginx)
```

### 📄 roles/web/templates/nginx.conf.j2

```nginx
# Basic nginx config template
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

---

## ✅ Testing

* Connectivity check:

```bash
ansible -i inventory/hosts web -m ping
```

* Web containers validation:

```bash
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083
```

* List containers:

```bash
docker ps
```

---

## 📜 License

Licensed under MIT. See [LICENSE](LICENSE).

---

## 👤 Author

**Ahmad Sheikhi**
🔗 [LinkedIn](https://www.linkedin.com/in/ahmad-sheikhi-42322276/)
📧 [ahmad.sheikhi89@gmail.com](mailto:ahmad.sheikhi89@gmail.com)

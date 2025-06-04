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
├── inventory/
│   └── hosts
├── group_vars/
│   └── web.yml
├── host_vars/
│   └── web1.yml
├── playbooks/
│   └── site.yml
├── roles/
│   └── web/
│       ├── handlers/
│       │   └── main.yml
│       ├── tasks/
│       │   └── main.yml
│       └── templates/
│           └── nginx.conf.j2
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
* Ansible (with docker connection plugin)

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

---

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

---

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
📧 [ahmad.sheikhi89@gmail.com](mailto:ahmad.sheikhi89@gmail.com)

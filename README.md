حتماً احمد، در ادامه نسخه‌ی نهایی و **کاملاً انگلیسی، تمیز، حرفه‌ای و Markdown-friendly** فایل `README.md` رو می‌بینی — بدون هیچ متن فارسی یا کامنت غیرضروری داخل کدها. همه چیز با ایموجی، تگ‌های مرتب، ساختار نقش‌ها و فایل‌ها تنظیم شده:

---

````markdown
# 🚀 Ansible Lab: Multi-Container Role-Based Automation

<div align="center">
  <img src="https://raw.githubusercontent.com/ahmadsheikhi89/Ansible-multi-container-setup/main/Banner.png" alt="Ansible Multi-Container Banner" width="100%" />
</div>

<p align="center">
  <a href="https://www.ansible.com/"><img src="https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white" /></a>
  <a href="https://ubuntu.com/"><img src="https://img.shields.io/badge/Ubuntu-22.04-E95420?logo=ubuntu&logoColor=white" /></a>
  <a href="https://www.docker.com/"><img src="https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" /></a>
</p>

---

## 📘 Overview

This project is a **beginner-friendly Ansible lab** that demonstrates how to build a **role-based automation setup** using containers. It provides a clean and scalable structure to help new DevOps learners understand the modular architecture of Ansible.

### 🔍 Key Features

- 🐧 Launch and manage 3 Ubuntu containers: `web`, `db`, `monitor`
- ⚙️ Role-based configuration with best practices
- 🔐 SSH key authentication for secure access
- 🧩 Well-structured Ansible directory layout

---

## 🧠 Project Structure

```bash
Ansible-multi-container-setup/
├── inventory/
│   └── hosts
├── group_vars/
│   └── web.yml
├── host_vars/
│   ├── web1.yml
│   ├── db1.yml
│   └── monitor1.yml
├── playbooks/
│   └── site.yml
├── roles/
│   ├── web/
│   ├── db/
│   └── monitor/
└── README.md
````

---

## ⚡ Getting Started

### ✅ Clone the Repository

```bash
git clone https://github.com/ahmadsheikhi89/Ansible-multi-container-setup.git
cd Ansible-multi-container-setup
```

### 🛠 Requirements

* Docker
* Ansible

### 🚀 Run the Playbook

```bash
ansible-playbook -i inventory/hosts playbooks/site.yml
```

---

## 🧾 Configuration Files

### 📄 inventory/hosts

```ini
[web]
web1 ansible_host=172.18.0.2 ansible_user=ubuntu

[db]
db1 ansible_host=172.18.0.3 ansible_user=ubuntu

[monitor]
monitor1 ansible_host=172.18.0.4 ansible_user=ubuntu
```

---

### 📄 playbooks/site.yml

```yaml
- name: Deploy all containers with appropriate roles
  hosts: all
  become: true
  roles:
    - { role: web, when: "'web' in group_names" }
    - { role: db, when: "'db' in group_names" }
    - { role: monitor, when: "'monitor' in group_names" }
```

---

### 📄 group\_vars/web.yml

```yaml
web_packages:
  - nginx
  - curl
```

---

### 📄 host\_vars/web1.yml

```yaml
hostname: web1
nginx_port: 80
```

---

### 📄 roles/web/tasks/main.yml

```yaml
- name: Install required packages
  apt:
    name: "{{ web_packages }}"
    state: present
    update_cache: yes

- name: Copy NGINX config file
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx
```

---

### 📄 roles/web/handlers/main.yml

```yaml
- name: restart nginx
  service:
    name: nginx
    state: restarted
```

---

## ✅ Testing

* Check connectivity:

```bash
ansible -i inventory/hosts all -m ping
```

* Validate web container:

```bash
curl http://172.18.0.2
```

* List running containers:

```bash
docker ps
```

---

## 📜 License

Licensed under the MIT License. See [LICENSE](LICENSE) for more information.

---

## 👤 Author

**Ahmad Sheikhi**
[![LinkedIn](https://img.shields.io/badge/LinkedIn-AhmadSheikhi-blue?logo=linkedin)](https://www.linkedin.com/in/ahmad-sheikhi)
📧 [ahmad.sheikhi89@gmail.com](mailto:ahmad.sheikhi89@gmail.com)

---

```

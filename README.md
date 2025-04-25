# Ansible Lab: Multi-Container Role-Based Automation

![Banner](https://raw.githubusercontent.com/ahmadsheikhi89/Ansible-multi-container-setup/main/banner.png)

[![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Overview

This project is a **professional-grade Ansible lab** designed for beginner IT/DevOps students to learn **modern Ansible structure and best practices**.

It demonstrates how to:
- Run **three isolated Ubuntu containers** (web, db, monitor)
- Configure each container using **Ansible roles**
- Secure connection via **SSH key authentication**
- Structure a maintainable and scalable project using:
  - `group_vars`
  - `host_vars`
  - `defaults`, `vars`, `handlers`
  - Role-based modular architecture

---

## Project Structure

```bash
project/
├── ansible.cfg
├── inventory/
│   └── hosts.ini
├── group_vars/
│   ├── web.yml
│   ├── db.yml
│   └── monitor.yml
├── host_vars/
│   └── db1.yml
├── roles/
│   ├── web/
│   │   ├── tasks/main.yml
│   │   ├── defaults/main.yml
│   │   ├── vars/main.yml
│   │   └── handlers/main.yml
│   ├── db/
│   │   └── tasks/main.yml
│   └── monitor/
│       └── tasks/main.yml
├── playbook.yml
└── README.md


---

Inventory Configuration

inventory/hosts.ini

[web]
web ansible_host=127.0.0.1 ansible_port=2220 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519

[db]
db ansible_host=127.0.0.1 ansible_port=2221 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519

[monitor]
monitor ansible_host=127.0.0.1 ansible_port=2222 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519


---

Example Group Vars

group_vars/web.yml

nginx_package: nginx
nginx_port: 80


---

Web Role Example

roles/web/tasks/main.yml

- name: Install Nginx
  apt:
    name: "{{ nginx_package }}"
    state: present
    update_cache: true

- name: Start Nginx
  service:
    name: "{{ nginx_package }}"
    state: started
    enabled: true

roles/web/defaults/main.yml

nginx_package: nginx

roles/web/handlers/main.yml

- name: restart nginx
  service:
    name: nginx
    state: restarted


---

Database Role Example

roles/db/tasks/main.yml

- name: Install MariaDB
  apt:
    name: mariadb-server
    state: present
    update_cache: true

- name: Start MariaDB
  service:
    name: mariadb
    state: started
    enabled: true


---

Main Playbook

playbook.yml

- name: Setup Web Role
  hosts: web
  become: true
  roles:
    - web

- name: Setup DB Role
  hosts: db
  become: true
  roles:
    - db

- name: Setup Monitor Role
  hosts: monitor
  become: true
  roles:
    - monitor


---

SSH Setup

ssh-keygen -t ed25519 -C "ansible-lab"
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<container_ip_or_port>


---

Requirements

Ansible >= 2.15

Docker or Podman

Python >= 3.8



---

Educational Goals

Understand the real-world Ansible directory structure

Learn how to manage multiple hosts using roles

Use group and host variables for cleaner configs

Secure Ansible with SSH keys (no passwords!)

Build fully automated lab environments with containers



---

License

This project is licensed under the MIT License.

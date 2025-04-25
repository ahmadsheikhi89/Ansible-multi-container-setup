Ansible Real-World Structure for Beginners — with Multi-Role Containers

This project is designed as a complete beginner-to-pro-level lab to teach new IT and DevOps students how to work with Ansible, focusing on best practices, real-world structure, and modularity.

It includes:

Real inventory management with SSH and containers

Multi-role setup (web, database, monitoring) with isolated containers

Professional project layout with:

group_vars and host_vars for configuration management

roles for clean logic separation and reusability

defaults and vars for parameter handling

handlers for service lifecycle management


Clean playbook syntax using updated Ansible (2.15+)

Example of GPG/SSH key authentication for secure access


Why This Structure?

This is based on the latest Ansible best practices and updates in ansible-core 2.15+.
We use:

Modular role-based design for scalability

group_vars to manage environment-specific variables

host_vars for host-specific configs

Private SSH key authentication (no passwords!)

Systemd-based service handling

Clear split between defaults, overridable vars, and handlers


What You'll Learn

Building and configuring multiple containers with different roles (nginx, mariadb, prometheus/node-exporter, etc.)

Secure remote management using SSH keys

Building maintainable and modular playbooks

Using ansible.cfg, inventory, group_vars, and roles like a pro

Real-world error handling and idempotency in Ansible tasks

Make directory : 

project/
├── ansible.cfg
├── inventory/
│   └── hosts.ini
├── group_vars/
│   ├── web.yml
│   ├── db.yml
│   └── monitor.yml
├── host_vars/
│   └── db1.yml  # مثال: اگر خواستی per-host تعریف کنی
├── roles/
│   ├── web/
│   │   ├── tasks/main.yml
│   │   ├── vars/main.yml
│   │   ├── defaults/main.yml
│   │   └── handlers/main.yml
│   ├── db/
│   │   └── ...
│   └── monitor/
│       └── ...
├── playbook.yml
└── README.md


---

۱. ansible.cfg

[defaults]
inventory = ./inventory/hosts.ini
host_key_checking = False
retry_files_enabled = False
deprecation_warnings=False


---

۲. inventory/hosts.ini

[web]
web ansible_host=127.0.0.1 ansible_port=2220 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519

[db]
db ansible_host=127.0.0.1 ansible_port=2221 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519

[monitor]
monitor ansible_host=127.0.0.1 ansible_port=2222 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519


---

۳. group_vars/web.yml

nginx_package: nginx
nginx_port: 80


---

۴. roles/web/tasks/main.yml

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


---

۵. roles/web/handlers/main.yml

- name: restart nginx
  service:
    name: nginx
    state: restarted


---

۶. roles/web/defaults/main.yml

nginx_package: nginx


---

۷. roles/db/tasks/main.yml

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

۸. playbook.yml

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

۹. مثال حرفه‌ای برای host_vars/db1.yml

db_port: 3306
db_user: root

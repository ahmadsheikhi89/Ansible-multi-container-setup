#!/bin/bash

# ایجاد دایرکتوری‌های پروژه
mkdir -p Ansible-multi-container-setup/{inventory,group_vars,host_vars,playbooks,roles/web/{tasks,handlers,templates},roles/db/tasks,roles/monitor/tasks}

# ایجاد فایل inventory/hosts
cat << 'INNER_EOF' > Ansible-multi-container-setup/inventory/hosts
[web]
web1 ansible_host=172.18.0.2 ansible_user=ubuntu

[db]
db1 ansible_host=172.18.0.3 ansible_user=ubuntu

[monitor]
monitor1 ansible_host=172.18.0.4 ansible_user=ubuntu
INNER_EOF

# ایجاد فایل group_vars/web.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/group_vars/web.yml
web_packages:
  - nginx
  - curl
INNER_EOF

# ایجاد فایل group_vars/db.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/group_vars/db.yml
db_packages:
  - mysql-server
  - mysql-client
db_service: mysql
INNER_EOF

# ایجاد فایل group_vars/monitor.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/group_vars/monitor.yml
monitor_packages:
  - prometheus
monitor_service: prometheus
INNER_EOF

# ایجاد فایل host_vars/web1.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/host_vars/web1.yml
hostname: web1
nginx_port: 80
INNER_EOF

# ایجاد فایل host_vars/db1.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/host_vars/db1.yml
hostname: db1
INNER_EOF

# ایجاد فایل host_vars/monitor1.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/host_vars/monitor1.yml
hostname: monitor1
INNER_EOF

# ایجاد فایل playbooks/site.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/playbooks/site.yml
- name: Deploy containers with roles
  hosts: all
  become: true
  roles:
    - { role: web, when: "'web' in group_names" }
    - { role: db, when: "'db' in group_names" }
    - { role: monitor, when: "'monitor' in group_names" }
INNER_EOF

# ایجاد فایل roles/web/tasks/main.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/roles/web/tasks/main.yml
- name: Install required packages
  apt:
    name: "{{ web_packages }}"
    state: present
    update_cache: yes

- name: Copy NGINX config file
  template:
    emerging: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx
INNER_EOF

# ایجاد فایل roles/web/handlers/main.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/roles/web/handlers/main.yml
- name: restart nginx
  service:
    name: nginx
    state: restarted
INNER_EOF

# ایجاد فایل roles/web/templates/nginx.conf.j2
cat << 'INNER_EOF' > Ansible-multi-container-setup/roles/web/templates/nginx.conf.j2
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen {{ nginx_port }};
        server_name {{ hostname }};

        location / {
            root /var/www/html;
            index index.html index.htm;
        }
    }
}
INNER_EOF

# ایجاد فایل roles/db/tasks/main.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/roles/db/tasks/main.yml
- name: Install database packages
  apt:
    name: "{{ db_packages }}"
    state: present
    update_cache: yes

- name: Ensure database service is started
  service:
    name: "{{ db_service }}"
    state: started
    enabled: yes
INNER_EOF

# ایجاد فایل roles/monitor/tasks/main.yml
cat << 'INNER_EOF' > Ansible-multi-container-setup/roles/monitor/tasks/main.yml
- name: Install monitoring packages
  apt:
    name: "{{ monitor_packages }}"
    state: present
    update_cache: yes

- name: Ensure monitoring service is started
  service:
    name: "{{ monitor_service }}"
    state: started
    enabled: yes
INNER_EOF

echo "Project structure and files created successfully!"

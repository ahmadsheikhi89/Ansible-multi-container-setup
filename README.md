حتماً احمد! در ادامه یک نسخه‌ی کامل و **تمیز و حرفه‌ای از فایل README.md** برای مخزن Ansible شما تهیه کردم. این نسخه شامل توضیحات، ساختار پروژه، نحوه اجرا و ساختار هر فایل کانفیگ به‌صورت مارک‌داون با استفاده از ایموجی‌های جذاب است:

---

```markdown
# 🚀 Ansible Multi-Container Setup

پروژه‌ای آموزشی برای پیاده‌سازی چند کانتینر مجزا با استفاده از Ansible و معماری نقش‌محور (Role-based)، مناسب برای دانشجویان و علاقه‌مندان به حوزه‌ی DevOps و IT.

---

## 📦 اهداف پروژه

- ایجاد 3 کانتینر Ubuntu با عملکردهای متفاوت (Web، DB، Monitor)
- اتصال امن SSH بین کانتینرها
- پیکربندی هر کانتینر با Role مستقل
- ساختاردهی حرفه‌ای و مقیاس‌پذیر با استفاده از:
  - `group_vars`, `host_vars`
  - `roles`, `defaults`, `handlers`
  - ماژول‌های YAML و SSH

---

## 🏗️ ساختار پروژه

```

Ansible-multi-container-setup/
├── inventory/
│   └── hosts
├── playbooks/
│   └── site.yml
├── group\_vars/
│   ├── all.yml
│   └── web.yml
├── host\_vars/
│   ├── web1.yml
│   ├── db1.yml
│   └── monitor1.yml
├── roles/
│   ├── web/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   └── ...
│   ├── db/
│   └── monitor/
└── README.md

````

---

## 🛠️ پیش‌نیازها

- Docker 🐳
- Ansible ⚙️
- سیستم عامل لینوکس/مک یا WSL برای ویندوز

---

## 🚦 نحوه اجرا

```bash
# کلون کردن مخزن
git clone https://github.com/ahmadsheikhi89/Ansible-multi-container-setup.git
cd Ansible-multi-container-setup

# اجرای Playbook اصلی
ansible-playbook -i inventory/hosts playbooks/site.yml
````

---

## 📁 فایل‌های مهم کانفیگ

### 📌 inventory/hosts

```ini
[web]
web1 ansible_host=172.18.0.2 ansible_user=ubuntu

[db]
db1 ansible_host=172.18.0.3 ansible_user=ubuntu

[monitor]
monitor1 ansible_host=172.18.0.4 ansible_user=ubuntu
```

---

### 📌 playbooks/site.yml

```yaml
- name: Deploy all roles
  hosts: all
  become: true
  roles:
    - { role: web, when: "'web' in group_names" }
    - { role: db, when: "'db' in group_names" }
    - { role: monitor, when: "'monitor' in group_names" }
```

---

### 📌 group\_vars/web.yml

```yaml
web_packages:
  - nginx
  - curl
```

---

### 📌 host\_vars/web1.yml

```yaml
hostname: web1
nginx_port: 80
```

---

### 📌 roles/web/tasks/main.yml

```yaml
- name: نصب پکیج‌های مورد نیاز
  apt:
    name: "{{ web_packages }}"
    state: present
    update_cache: yes

- name: کپی فایل کانفیگ NGINX
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: restart nginx
```

---

### 📌 roles/web/handlers/main.yml

```yaml
- name: restart nginx
  service:
    name: nginx
    state: restarted
```

---

## 🧪 تست پروژه

پس از اجرای playbook:

* با دستور `docker ps` مطمئن شوید کانتینرها بالا هستند.
* با `curl http://172.18.0.2` وضعیت وب سرور را بررسی کنید.
* با `ansible -m ping all -i inventory/hosts` ارتباط SSH را تست کنید.

---

## 📜 مجوز

MIT © [Ahmad Sheikhi](https://github.com/ahmadsheikhi89)

---

## 💬 ارتباط با من

📧 ایمیل: [ahmad.sheikhi89@gmail.com](mailto:ahmad.sheikhi89@gmail.com)
🔗 لینکدین: [Ahmad Sheikhi](https://www.linkedin.com/in/ahmad-sheikhi)

```

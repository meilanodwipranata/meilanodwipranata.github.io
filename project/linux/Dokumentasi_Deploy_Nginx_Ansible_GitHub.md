# 🚀 Deploy Web Server Nginx Menggunakan Ansible

------------------------------------------------------------------------

## 📌 Deskripsi

Project ini bertujuan untuk melakukan **otomatisasi instalasi dan
konfigurasi Nginx** pada server Debian/Ubuntu menggunakan Ansible dengan
struktur role.

------------------------------------------------------------------------

## 🖥️ Kebutuhan Sistem

### 🔹 Controller (Ansible)

-   Debian / Ubuntu
-   Ansible terinstall
-   Akses SSH ke server target

### 🔹 Target Server

-   Debian / Ubuntu
-   SSH aktif
-   Python3 terinstall

------------------------------------------------------------------------

## 📁 Struktur Project

``` bash
ansible-project/
├── ansible.cfg
├── playbook.yml
├── inventory/
│   └── hosts
├── group_vars/
│   └── all.yml
└── roles/
    └── webserver/
        ├── tasks/
        │   └── main.yml
        ├── handlers/
        │   └── main.yml
        ├── templates/
        │   └── index.html.j2
        └── defaults/
            └── main.yml
```

------------------------------------------------------------------------

## ⚙️ Konfigurasi File

### 1️⃣ ansible.cfg

``` ini
[defaults]
inventory = inventory/hosts
host_key_checking = False
retry_files_enabled = False
```

------------------------------------------------------------------------

### 2️⃣ inventory/hosts

``` ini
[web]
192.168.20.10
```

------------------------------------------------------------------------

### 3️⃣ group_vars/all.yml

``` yaml
ansible_user: root
ansible_port: 22
ansible_python_interpreter: /usr/bin/python3
```

------------------------------------------------------------------------

### 4️⃣ defaults/main.yml

``` yaml
web_root: /var/www/html
```

------------------------------------------------------------------------

### 5️⃣ playbook.yml

``` yaml
- name: Deploy Web Server
  hosts: web
  become: yes
  roles:
    - webserver
```

------------------------------------------------------------------------

### 6️⃣ roles/webserver/tasks/main.yml

``` yaml
- name: Update apt cache
  apt:
    update_cache: yes

- name: Install nginx
  apt:
    name: nginx
    state: present

- name: ensure web root exist
  file:
    path: "{{ web_root }}"
    state: directory
    mode: '0755'

- name: Deploy Custom Html
  template:
    src: index.html.j2
    dest: "{{ web_root }}/index.html"
  notify: restart nginx

- name: Start and Enable nginx
  service:
    name: nginx
    state: started
    enabled: yes
```

------------------------------------------------------------------------

### 7️⃣ roles/webserver/handlers/main.yml

``` yaml
- name: restart nginx
  service:
    name: nginx
    state: restarted
```

------------------------------------------------------------------------

## ▶️ Cara Menjalankan

``` bash
ansible-playbook playbook.yml
```

------------------------------------------------------------------------

## 🌐 Hasil

Setelah berhasil dijalankan, web server dapat diakses melalui:

http://192.168.20.10

------------------------------------------------------------------------

## 🧠 Konsep yang Digunakan

-   Agentless Automation
-   Idempotent Configuration
-   Role-based Structure
-   Handler & Notify
-   Infrastructure as Code (IaC)

------------------------------------------------------------------------

## ✅ Kesimpulan

Dengan Ansible, proses instalasi dan konfigurasi web server menjadi:

-   Otomatis
-   Konsisten
-   Efisien
-   Dapat dijalankan berulang tanpa merusak sistem

------------------------------------------------------------------------

> ✨ Project ini cocok untuk pembelajaran DevOps, LKS ITNSA, dan
> implementasi automation skala kecil hingga besar.

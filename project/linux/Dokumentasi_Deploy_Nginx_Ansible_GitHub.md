<---<style>
body{display:grid;place-items:center;background:linear-gradient(180deg,#071025 0%, #07192b 60%), radial-gradient(600px 300px at 10% 10%, rgba(110,231,183,0.06), transparent), radial-gradient(500px 250px at 90% 90%, rgba(99,102,241,0.04), transparent);color:#e6eef6}.card{width:360px;max-width:92vw;background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));border:1px solid rgba(255,255,255,0.04);padding:28px;border-radius:16px;box-shadow:0 6px 30px rgba(2,6,23,0.6);backdrop-filter: blur(6px)}
</style> --->
<style>
/* GitHub Dark Markdown Style */

pre {
  background-color: #0d1117 !important;
  color: #c9d1d9 !important;
  padding: 16px;
  border-radius: 6px;
  overflow-x: auto;
  border: 1px solid #30363d;
}

pre code {
  background: none !important;
  color: #c9d1d9 !important;
}

code {
  background-color: #161b22;
  color: #c9d1d9;
  padding: 2px 6px;
  border-radius: 4px;
}
</style>
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



# 🚀 Ansible Web Server + NFTables (Debian)

Project automation server menggunakan **Ansible** untuk:

- ✅ Install Nginx
- ✅ Deploy Web
- ✅ Konfigurasi NFTables Firewall
- ✅ Allow SSH & HTTP
- ✅ Drop semua trafik lain
- ✅ Auto restart service jika ada perubahan

---

## 📦 Requirement

- Debian 11/12
- Ansible >= 2.9
- SSH akses ke server
- User dengan sudo/root

---

## 📁 Struktur Project

```
project/
│── inventory
│── playbook.yml
│── README.md
```

---

## 📄 inventory

```ini
[web]
192.168.1.10 ansible_user=root
```

---

## 📄 playbook.yml

```yaml
- name: Setup Web + NFTables
  hosts: web
  become: yes

  vars:
    web_root: /var/www/lks

  tasks:

  - name: Install nginx dan nftables
    apt:
      name:
        - nginx
        - nftables
      state: present
      update_cache: yes

  - name: Buat folder web
    file:
      path: "{{ web_root }}"
      state: directory
      owner: www-data
      group: www-data
      mode: '0755'

  - name: Deploy index
    copy:
      dest: "{{ web_root }}/index.html"
      content: "<h1>LKS NFTABLES</h1>"

  - name: Edit root nginx
    lineinfile:
      path: /etc/nginx/sites-available/default
      regexp: 'root /var/www/html;'
      line: "root {{ web_root }};"
    notify: Restart nginx

  - name: Enable nginx
    systemd:
      name: nginx
      state: started
      enabled: yes

  - name: Konfigurasi nftables
    copy:
      dest: /etc/nftables.conf
      content: |
        flush ruleset

        table inet filter {
          chain input {
            type filter hook input priority 0;

            ct state established,related accept
            iif lo accept

            tcp dport 22 accept
            tcp dport 80 accept

            counter drop
          }

          chain forward {
            type filter hook forward priority 0;
            drop
          }

          chain output {
            type filter hook output priority 0;
            accept
          }
        }
    notify: Restart nftables

  - name: Enable nftables service
    systemd:
      name: nftables
      state: started
      enabled: yes

  handlers:
    - name: Restart nginx
      systemd:
        name: nginx
        state: restarted

    - name: Restart nftables
      systemd:
        name: nftables
        state: restarted
```

---

## 🔥 Firewall Rules

| Rule | Keterangan |
|------|------------|
| Allow 22 | SSH |
| Allow 80 | HTTP |
| Allow loopback | Local traffic |
| Allow established | Koneksi aktif |
| Drop lainnya | Security default |

---

## ▶️ Cara Menjalankan

```bash
ansible-playbook -i inventory playbook.yml
```

---

## 🛡 Security Model

- Default policy: DROP
- Only required ports opened
- Persistent firewall via `/etc/nftables.conf`
- Auto restart via handler

---

## 📈 Pengembangan Lanjutan

- [ ] HTTPS (Port 443)
- [ ] Fail2ban integration
- [ ] NAT Router Mode
- [ ] Multi-subnet filtering
- [ ] Logging dropped packets

---

## 🏆 Use Case

Cocok untuk:
- Lab latihan LKS ITNSA
- Automation deployment
- Mini DevOps project
- Server hardening dasar

---

## 👨‍💻 Author

Lano ITNSA 🚀

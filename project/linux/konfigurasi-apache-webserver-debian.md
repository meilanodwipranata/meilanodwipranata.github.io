---
title: "Konfigurasi Apache HTTP Webserver di Debian"
date: 2022-03-12T19:35:11+07:00
draft: false
---

# Konfigurasi Web Server Apache2 HTTP di Debian 11


## Apa itu web server

---

Web server adalah software yang berfungsi sebagai penerima yang  menerima permintaan(request) dari web browser(client) yang biasanya berbentuk HTML(HyperText Markup Language). Beberapa software web server yang populer antara lain Apache, NGINX, lighttpd, litespeed, dan lain lain.

## Konfigurasi Apache HTTP di Debian 11

---

Topology yang digunakan yaitu 1 guest os debian11 sebagai server dan host os sebagai client. Konfigurasi IP address yang digunakan kali ini pada debian server yaitu 192.168.10.2/24. Untuk semua perintah yang digunakan dalam konfigurasi menggunakan user root, atau juga bisa menggunakan perintah sudo

### **1. Install apache**

Perintah yang digunakan untuk menginstall apache di debian

	apt update
	apt install apache2

### **2. Konfigurasi apache2 site config file**

Konfigurasi site apache berada di /etc/apache2/sites-available/

	cd /etc/apache2/sites-available

Copy default config apache menjadi config file yang akan kita konfigurasi

	cp 000-default.conf web.conf

Edit file yang telah dicopy

	vi web.conf

{{< highlight bash >}}
	<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/webhtml

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

{{< /highlight >}}

Notes:

DocumentRoot digunakan untuk sebagai file website/html kita buat ke apache agar dapat diakses oleh client, untuk memberikan domain ke virtualhost uncomment baris ServerName dan diisi dengan domain/main domain kita,
untuk menambahkan alias bisa menambahkan _ServerAlias_

Buat file html yang akan kita gunakan pada web server sesuai dengan konfigurasi DefaultRoot pada config file

	mkdir /var/www/webhtml
	vi /var/www/webhtml/index.html

{{< highlight html >}}
<!DOCTYPE HTML>
<html>
	<head>
		<title>contoh apache server</title>
	</head>
	<body>
		<h1>apache web server berhasil</h1>
		<hr>
	</body>
</html>
{{< /highlight >}}

### **3. Disable dan enable site**

Secara default config file _000-default.conf_ aktif, maka untuk menDisable menggunakan perintah

	a2dissite 000-default.conf

Untuk meng-enable kan config yang telah dibuat

	a2ensite web.conf

### **4. Restart Service Apache**

Perintah untuk merestart service apache

	systemctl restart apache2

### **5. Testing Pada Client**

Buka web browser pada client dan masukkan ip address atau domain pada web browser jika domain sudah dikonfigurasi

	http://192.168.10.2

![Testing pada Client Browser](/notes/image/ssHttp.png)


### Perintah yang sering digunakan

---

	systemctl enable apache2	# mengaktifkan service apache saat booting
	systemctl disable apache2	# me non-aftifkan service apache pada saat booting
	systemctl restart apache2	# me restart service apache
	systemctl reload apache2	# reload service apache
	a2dissite <site.conf>	# disable site
	a2ensite	<site.conf>	# enable site
	a2enmod <module>		# enable module
	a2dismod	<module>		# disable module

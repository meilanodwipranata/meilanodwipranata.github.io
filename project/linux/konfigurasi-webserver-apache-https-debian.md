---
title: "Konfigurasi Webserver Apache Https Debian"
date: 2022-03-12T21:18:39+07:00
draft: false
---


# Konfigurasi Web Server Apache2 HTTPS(openssl) di Debian

## Apa itu web server

---

Web server adalah software yang berfungsi sebagai penerima yang  menerima permintaan(request) dari web browser(client) yang biasanya berbentuk HTML(HyperText Markup Language). Beberapa software web server yang populer antara lain Apache, NGINX, lighttpd, litespeed, dan lain lain.

## Apa itu HTTPS

---

Hypertext Transfer Protocol Secure (HTTPS) adalah ekstensi dari Hypertext Transfer Protocol (HTTP). Ini digunakan untuk komunikasi aman melalui jaringan komputer, dan banyak digunakan di Internet.[1] Dalam HTTPS, protokol komunikasi dienkripsi menggunakan Transport Layer Security (TLS) atau, sebelumnya, Secure Sockets Layer (SSL). Oleh karena itu, protokol ini juga disebut sebagai HTTP over TLS,[2] atau HTTP over SSL. [_<u>wikipedia</u>_](https://id.wikipedia.org/wiki/HTTPS)

**Perbedaan HTTP dengan HTTPS**

URL HTTPS dimulai dengan "https://" dan menggunakan port 443 secara default, sedangkan, HTTP URL dimulai dengan "http://" dan gunakan port 80 secara default. 

HTTP tidak dienkripsi dan karenanya rentan terhadap serangan man-in-the-middle dan penyadapan, yang dapat memungkinkan penyerang mendapatkan akses ke akun situs web dan informasi sensitif, dan memodifikasi halaman web untuk menyuntikkan malware atau iklan. HTTPS dirancang untuk menahan serangan semacam itu dan dianggap aman terhadap serangan itu (dengan pengecualian implementasi HTTPS yang menggunakan versi SSL yang sudah tidak digunakan lagi). [_<u>wikipedia</u>_](https://id.wikipedia.org/wiki/HTTPS)

**Gampangnya** HTTPS merupakan versi aman (_secure_) dari HTTP karena telah menggunakan enkripsi sehingga sulit diretas oleh pihak yang tidak bertanggung jawab. HTTPS menggunakan port 443 secara default, berbeda dengan HTTP yang menggunakan port 80 secara default.

## Konfigurasi Apache HTTPS di Debian 11

---

Topology yang digunakan yaitu 1 guest os debian11 sebagai server dan host os sebagai client. Konfigurasi IP address yang digunakan pada debian server yaitu 192.168.10.2/24. Untuk semua perintah yang akan digunakan menggunakan user root, atau juga bisa menggunakan perintah sudo.

### 1. Install apache

Perintah yang digunakan untuk menginstall apache di debian
	
	apt update
	apt install apache2 openssl ssl-cert

### 2. Konfigurasi apache2 config file

Konfigurasi site apache berada di /etc/apache2/sites-available/ 

	cd /etc/apache2/sites-available

Copy default config apache menjadi config file yang akan kita konfigurasi 

	cp default-ssl.conf webssl.conf

Edit file yang telah dicopy

	vi webssl.conf 


Cukup merubah beberapa baris saja diantaranya:
	
- Menambahkan ServerName jika ingin menambahkan domain ke virtualhost

- DocumentRoot, sebagai lokasi file digunakan untuk website/html kita buat ke apache agar dapat diakses oleh client

- Pastikan SSLEngine dalam keadaan on, off jika tidak ingin menggunakan ssl

-  SSLCertificateFile dan SSLCertificateKeyFile, sebagai lokasi certificate dan key untuk ssl

{{< highlight bash >}}

1 <IfModule mod_ssl.c>
2         <VirtualHost _default_:443>
3                 ServerAdmin webmaster@localhost
4 
5                 DocumentRoot /var/www/sslhtml

23                 #   SSL Engine Switch:
24                 #   Enable/Disable SSL for this virtual host.
25                 SSLEngine on
26 
27                 #   A self-signed (snakeoil) certificate can be created by installing
28                 #   the ssl-cert package. See
29                 #   /usr/share/doc/apache2/README.Debian.gz for more info.
30                 #   If both key and certificate are stored in the same file, only the
31                 #   SSLCertificateFile directive is needed.
32                 SSLCertificateFile      /etc/apache2/ssl/apache.crt
33                 SSLCertificateKeyFile /etc/apache2/ssl/apache.key

{{< /highlight >}}


Buat file html yang akan kita gunakan pada web server sesuai dengan konfigurasi DefaultRoot pada config file

	mkdir /var/www/sslhtml
	vi /var/www/sslhtml/index.html

{{< highlight html >}}
	<!DOCTYPE HTML>
	<html>
    	    <head>
    	            <title>contoh apache server</title>
    	    </head>
    	    <body>
                <h1>apache web server HTTPS menggunakan openssl berhasil</h1>
                <hr>
    	    </body>

	</html>

{{< /highlight >}}

### **3. Membuat Private Key dan Website Certificate**

Membuat directory untuk Private Key dan Website Certificate sesuai dengan config file

	mkdir /etc/apache2/ssl

Membuat Private Key dan Website Certificate menggunakan command openssl

	openssl req -x509 -newkey rsa:4096 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -nodes -days 365

Isi beberapa pertanyaan jika perlu dan tekan enter beberapa kali


### 4. Disable, enable site, dan enable module ssl

Secara default config file _000-default.conf_ aktif, maka untuk menDisable menggunakan perintah

	a2dissite 000-default.conf

Untuk meng-enable kan config yang telah dibuat

	a2ensite webssl.conf

Agar HTTPS aktif, maka kita harus menghidupkan module ssl yang ada di apache dengan perintah

	a2enmod ssl

### 5. Restart Service Apache

Perintah untuk merestart service apache

	systemctl restart apache2

Perintah untuk mereload service apache

	systemctl reload apache2

### 6. Testing Pada Client

Buka web browser pada client dan masukkan ip address atau domain pada web browser jika domain sudah dikonfigurasi
	
	https://192.168.10.2

![Testing pada Client Browser](/notes/image/ssHttps.png)

Klik Advanced -> accept the risk and continue

![Testing pada Client Browser](/notes/image/ssHttps1.png)

### Perintah yang sering digunakan
	
	systemctl enable apache2	# mengaktifkan service apache saat booting
	systemctl disable apache2	# me non-aftifkan service apache pada saat booting
	systemctl restart apache2	# me restart service apache
	systemctl reload apache2	# reload service apache
	a2dissite \<file config>	# disable site
	a2ensite \<file config>		# enable site
	a2enmod \<nama module>		# enable module 
	a2dismod \<nama module>		# disable module

---
title: "Konfigurasi Load Balancing Nginx Di Debian"
date: 2022-04-12T15:30:52+07:00
---

# Konfigurasi Load Balancing Dengan NGINX pada Debian

## Load Balancing
---

Load Balancing adalah proses pendistribusian sejumlah trafic ke beberapa server agar salah satu server tidak menerima terlalu banyak permintaan. Server website yang terlalu banyak memproses permintaan atau kelebihan beban akan mengakibatkan kinerja dan proses muat halaman menjadi lambat.

### Load Balancing Algorithms
---

Masing - masing algoritma load balancing menyediakan manfaat yang berbeda beda, tinggal sesuaikan dengan kebutuhan.

-	Round Robin - Permintaan didistribusikan ke beberapa server secara berurutan, metode ini tidak mempertimbangkan beban dari masing masing server.

-	Least Connection - Permintaan didistribusikan ke server dengan jumlah koneksi paling sedikit. Metode ini menjaga semua distribusi traffic merata ke semua server.

-	Least Respon Time - Mengarahkan permintaan ke server dengan traffic paling kecil dan respon time yang paling cepat.

-	IP Hash - Mengarahkan permintaan ke server berdasarkan ip address dari client.

-	Least Bandwith - Mendistribusikan permintaan ke server berdasarkan bandwith paling kecil. Metode ini mencari server yang melayani jumlah traffic paling sedikit dalam ukuran megabit per detik (Mbps).								

## Topology
---

Topology yang digunakan

![topology](/notes/image/load-balancer-topology.png)

NGINX Load Balancer:

- port 80

Apache Web Server:

- port 80
- port 8080

NGINX Web Server:

- port 80
- port 8080

## Konfigurasi	NGINX Load Balancer
---

Install package NGINX.

	apt install nginx

Pindah ke directory /etc/nginx/sites-available.

	cd /etc/nginx/sites-available

Buat dan edit file config nginx untuk load balancing.

	vi load-balancing.conf

{{< highlight bash >}}

upstream web-backend {
  server 192.168.40.2:80;
  server 192.168.40.2:8080;
  server 192.168.40.3:80;
  server 192.168.40.3:8080;
}

server {
  listen 80;
  location / {
    proxy_pass http://web-backend;
  }
}

{{< /highlight >}}

Fungsi "upstream" berfungsi untuk mendefinisikan beberapa server untuk digunakan pada proxy\_pass, fastcgi\_pass, uwsgi\_pass, scgi\_pass, memcached\_pass, and grpc_pass directives.

NGINX menggunakan metode round robin secara default,

Jika ingin mengganti ke metode **Least Connection** tambahkan "least_conn" pada upstream.

{{< highlight bash >}}
upstream web-backend {
  least_conn;
  server 192.168.40.2:80;
  server 192.168.40.2:8080;
  server 192.168.40.3:80;
  server 192.168.40.3:8080;
}
{{< /highlight >}}

**IP hash**, tambahkan "ip_hash".

{{< highlight bash >}}

upstream web-backend {
  ip_hash;
  server 192.168.40.2:80;
  server 192.168.40.2:8080;
  server 192.168.40.3:80;
  server 192.168.40.3:8080;
}
{{< /highlight >}}

Dalam konfigurasi load balancing kali ini menggunakan metode round robin.

Unlink default config di /etc/nginx/sites-enabled/default

	unlink /etc/nginx/sites-enabled/default

Link kan load balancer config ke /etc/nginx/sites-enabled

	ln -s /etc/nginx/sites-available/load-balancing.conf /etc/nginx/sites-enabled/

Tes konfigurasi nginx.

	nginx -t

Restart nginx service.

	systemctl restart nginx

### Konfigurasi Web Server Apache
---

Konfigurasi pada server apache dengan ip address 192.168.40.2, Konfigurasi apache web server dilakukan seperti konfigurasi  apache biasa.

Install apache package.

	apt install apache2

Edit dan tambahkan port 8080 di /etc/apache2/ports.conf

	vi /etc/apache2/ports.conf

{{< highlight bash >}}
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 8080

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

{{< /highlight >}}

Tambahkan dan edit config apache di directory /etc/apache2/sites-available/

	cd /etc/apache2/sites-available
	vi web-apache.conf

{{< highlight bash >}}
<VirtualHost *:80>

        DocumentRoot /var/www/web-apache

</VirtualHost>

<Virtualhost *:8080>

		DocumentRoot /var/www/web-apache-8080

</Virtualhost>
{{< /highlight >}}

Enable config yang kita buat, disable default config, dan reload service apache.

	a2ensite web-apache.conf
	a2dissite 000-default.conf
	systemctl reload apache2

Membuat directory web html untuk masing masing virtualhost.

	mkdir /var/www/web-apache
	mkdir /var/www/web-apache-8080

Tambahkan file index.html pada masing masing directory.

	vi /var/www/web-apache/index.html

{{< highlight html >}}
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>apache server</title>
  </head>
  <body>
    <h1>contoh web server apache</h1>
    <hr/>
    <h2>ip address 192.168.40.2 port 80(default)</h2>
  </body>
</html>
{{< /highlight >}}

	vi /var/www/web-apache-8080/index.html

{{< highlight html >}}
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>apache server</title>
  </head>
  <body>
    <h1>contoh web server apache 2</h1>
    <hr/>
    <h2>ip address 192.168.40.2 port 8080</h2>
  </body>
</html>
{{< /highlight >}}

Reload dan restart apache service

	systemctl reload apache2 && systemctl restart apache2

### Konfiguarasi Web Server NGINX

Konfigurasi pada server NGINX dengan ip address 192.168.40.3, Konfigurasi NGINX web server dilakukan seperti konfigurasi NGINX biasa.

Install NGINX package.

	apt install nginx

Pindah ke directory nginx, tambahkan config file NGINX untuk port 80 dan port 8080.

	cd /etc/nginx/sites-available
	touch web-nginx-80.conf
	touch web-nginx-8080.conf

<p/>

	vi web-nginx-80.conf

{{< highlight bash >}}
server {
        listen 80;
        location / {
                root /var/www/web-nginx-80;
        }
}
{{< /highlight >}}

	vi web-nginx-8080.conf

{{< highlight bash >}}
server {
        listen 8080;
        location / {
                root /var/www/web-nginx-8080;
        }
}
{{< /highlight >}}

Unlink default config di directory /etc/nginx/sites-enabled, dan link kan config file web-nginx-80.conf dan web-nginx-8080.conf

	unlink /etc/nginx/sites-enabled/default
	ln -s /etc/nginx/sites-available/web-nginx-80.conf /etc/nginx/sites-enabled/
	ln -s /etc/nginx/sites-available/web-nginx-8080.conf /etc/nginx/sites-enabled/

Buat directory web-nginx dan file config html di directory /var/www/web-nginx

	mkdir /var/www/web-nginx-80
	mkdir /var/www/web-nginx-8080
	touch /var/www/web-nginx-80/index.html
	touch /var/www/web-nginx-8080/index.html

Edit masing-masing html file.

	vi /var/www/web-nginx-80/index.html

{{< highlight bash >}}
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>nginx server</title>
  </head>
  <body>
    <h1>web server nginx</h1>
    <hr/>
    <h2>ip address 192.168.40.3 port 80</h2>
  </body>
</html>

{{< /highlight >}}

	vi /var/www/web-nginx-8080/index.html

{{< highlight bash >}}
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>nginx server</title>
  </head>
  <body>
    <h1>web server nginx 2</h1>
    <hr/>
    <h2>ip address 192.168.40.3 port 8080</h2>
  </body>
</html>
{{< /highlight >}}

Tes konfigurasi nginx.

	nginx -t

Restart service nginx.

	systemctl restart nginx

## Testing Pada Client
---

Buka web browser dan masukkan ip address dari server load balancer (http://192.168.30.5) pada url browser, jika pagenya di reload maka web html yang ditampilkan akan bergantian ke beberapa web server yang telah dikonfigurasi tadi.

![web server apache port 80](/notes/image/load-balancing-client1.png)
![web server apache port 8080](/notes/image/load-balancing-client2.png)
![web server nginx port 80](/notes/image/load-balancing-client3.png)
![web server nginx port 8080](/notes/image/load-balancing-client4.png)

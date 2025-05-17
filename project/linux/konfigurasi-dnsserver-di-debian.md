---
title: "Konfigurasi Dns Server Di Debian"
date: 2022-04-01T10:47:33+07:00
draft: false
---

# Konfigurasi DNS Server (bind9) di Debian

## Apa itu DNS

---

Sistem Penamaan Domain (bahasa Inggris: (Domain Name System, DNS) adalah sistem penamaan hirarkis dan desentralisasi untuk komputer, layanan, atau sumber daya lain yang terhubung ke Internet atau jaringan pribadi. Ini mengaitkan berbagai informasi dengan nama domain yang ditetapkan untuk masing-masing entitas yang berpartisipasi. Yang paling menonjol, ini menerjemahkan nama domain yang lebih mudah dihafal ke alamat IP numerik yang diperlukan untuk mencari dan mengidentifikasi layanan dan perangkat komputer dengan protokol jaringan yang mendasarinya. Dengan menyediakan layanan direktori terdistribusi di seluruh dunia, Domain Name System telah menjadi komponen penting dari fungsi Internet sejak 1985. [_wikipedia_](https://id.wikipedia.org/wiki/Sistem_Penamaan_Domain)

Gampangya, DNS merupakan sebuah sistem yang mengubah nama domain atau url menjadi ip address atau sebaliknya, fungsi dari dns yaitu agar dapat mempermudah dalam pencarian sebuah website.

## Installasi dan Konfigurasi DNS server di Debian (bind9)

---

### Install bind9

Perintah untuk install bind9
	
	apt update
	apt install bind9 dnsutils

### Konfigurasi bind9

konfigurasi file bind9 berada pada directory /etc/bind/, pindah ke direktory tersebut agar lebih mudah dalam konfigurasi

	cd /etc/bind

copy file **db.127** dan **db.local** menjadi file yang akan dikonfigurasi, nama file bisa terserah, usahakan nama file mudah di ingat, karena nama file tersebut akan digunakan pada konfigurasi file default zones. db.127 merupakan file konfigurasi default dari reverse lookup dan db.local merupakan konfigurasi default dari forward lookup.

forward dns lookup berfungsi untuk menggunakan nama domain untuk mencari ip address yang dituju.
reverse dns lookup berfungsi untuk mengonversi ip address ke nama domain.

Dalam konfigurasi dns, konfigurasi forward dns saja sudah cukup, tapi ada beberapa service yang membutuhkan reverse dns lookup, tergantung kebutuhan.

	cp db.127 db.reverse
	cp db.local db.forward

Edit konfigurasi db.reverse, ubah localhost menjadi nama domain yang akan digunakan, ubah angka 1.0.0 menjadi octet terakhir dari ip address yang digunakan.

	vi db.reverse

default config

{{< highlight bash >}}

;
; BIND reverse data file for local loopback interface
;
$TTL    604800
@       IN      SOA     localhost. root.localhost. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      localhost.
1.0.0   IN      PTR     localhost.

{{< /highlight >}}

menjadi

{{< highlight bash >}}
;
; BIND reverse data file for local loopback interface
;
$TTL    604800
@       IN      SOA     contoh.local. root.contoh.local. (
  	                          1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      contoh.local.
2       IN      PTR     contoh.local.
'''

{{< / highlight >}}

Edit konfigurasi db.forward, ubah localhost menjadi nama domain yang akan digunakan. Tambahkan sub domain jika perlu.

Default config

{{< highlight bash >}}
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     localhost. root.localhost. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      localhost.
@       IN      A       127.0.0.1
@       IN      AAAA    ::1

{{< /highlight >}}

Ubah menjadi

{{< highlight bash >}}
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     contoh.local. root.contoh.local. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      contoh.local.
@       IN      A       192.168.20.2
www     IN      A       192.168.20.2

{{< /highlight >}}


Edit file konfigurasi default zones.

	vi named.conf.default-zones

Tambahkan konfigurasi berikut. Pada bagian "20.168.192.in-addr.arpa", 10.168.192 merupakan versi terbalik dari ip 192.168.20.

{{< highlight bash >}}
zone "contoh.local" {
	type master;
	file "/etc/bind/db.forward";
};

zone "20.168.192.in-addr.arpa" {
	type master;
	file "/etc/bind/db.reverse";
};

{{< /highlight >}}

Restart service bind9 dengan perintah

	systemctl restart bind9

Tambahkan nameserver pada dns resolve

	vi /etc/resolv.conf

Tambahkan ip address dns server

	nameserver 192.168.20.2

Testing dns server dengan perintah nslookup

	nslookup contoh.local

output

	Server:		192.168.20.2
	Address:	192.168.20.2#53

	Name:	contoh.local
	Address: 192.168.20.2

Testing sub domain

	nslookup www.contoh.local

output

	Server:		192.168.20.2
	Address:	192.168.20.2#53
	
	Name:	www.contoh.local
	Address: 192.168.20.2




### Menambahkan Domain ke Web Server

Pada apache tambahkan ServerName pada konfigurasi virtualhost.

{{< highlight html >}}

	ServerName www.contoh.local

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/web

{{< /highlight >}}

Restart apache service

	systemctl restart apache2

Pada nginx tambahkan server_name pada konfigurasi virtualhost.

{{< highlight bash >}}
server {
	
	listen 8080;
 	server_name www.contoh.local;
 	location / {
		root /var/www/web;
 	}
			
}	

{{< /highlight >}}

restart nginx service

	systemctl restart nginx


## Testing Pada Client (linux)

---

Pastikan client dan server dapat ping satu sama lain.

Tambahkan nameserver ip server di /etc/resolv.conf

	vi /etc/resolv.conf

Tambahkan

	nameserver 192.168.20.2

Install dnsutils

	apt install dnsutils

Lakukan perintah nslookup sesuai domain yang dikonfigurasi

	nslookup contoh.local

output

	Server:	192.168.20.2
	Address:	192.168.20.2#53

	Name:	contoh.local
	Address: 192.168.20.2

nslookup pada subdomain

	nslookup www.contoh.local

output

	Server:	192.168.20.2
	Address:	192.168.20.2#53

	Name:	www.contoh.local
	Address: 192.168.20.2

Test dns dengan mengakses web server, masukkan nama domain di web browser

![Testing pada web browser](/notes/image/ssDns1.png)

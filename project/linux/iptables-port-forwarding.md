---
title: "Port Forwarding dengan IPtables"
date: 2022-06-08T02:53:52+07:00
---

# Port Forwarding dengan IPtables

## Pengenalan

---

NAT atau Network Address Translation adalah istilah umum untuk mentranslate suatu ip address ke ip address lain. Sebuah host yang mengimplementasikan NAT biasanya memiliki akses ke dua atau lebih jaringan dan dikonfigurasi untuk merutekan lalu lintas di antara beberapa jaringan tersebut.

Port forwarding adalah proses dalam meneruskan requests/permintaan client dari specific port ke host, network, atau port lain. Karena proses ini merubah/memodifikasi tujuan dari paket, proses ini juga dianggap sebagai salah satu jenis dari NAT.

## Topology

---

![Topology](/notes/image/topology-forwarding-openvpn.png)

Client :

-	Address 192.168.122.210
-	Gateway 192.168.122.1

Router Debian :

-	Address 192.168.122.129
-	Gateway 182.168.122.1

Debian 11 Server :

-	Address 192.168.10.254
-	Gateway 192.168.122.129


## Konfigurasi Port Forwarding IPtables

---

### Scenario

Pastikan router debian sudah dikonfigurasi menjadi router gateway: [Konfigurasi Debian Sebagai Router/Gateway](https://raffr.gitlab.io/notes/network/linux/konfigurasi-debian-sebagai-router/)

Debian 11 server akan diinstall apache web server, dan membuka port 80. Client akan mengakses web server melalui ip address dari Router debian dengan port 8080. Router debian akan men-forward request port 8080 dari client ke Debian 11 server port 80.

### Konfigurasi Debian 11 server

Install apache web server

	apt update && apt install apache2

Edit file html

	vi /var/www/html/index.html
<p/>

	<html>
	<head>
	<title>
	        Hello World
	</title>
	</head>
	<body>
	<h1 style="color:blue; text-align: center">Hello World</h1>
	</body>
	</html>

Cek website dengan menggunakan curl

	apt install curl
	curl http://192.168.10.254

### Konfigurasi Port Forwarding di Router debian

Install iptables

	apt install iptables

Enable ipv4 forward dengan edit file sysctl.conf dan uncomment baris berikut

	vi /etc/sysctl.conf
<p/>

	# Uncomment the next line to enable packet forwarding for IPv4
	net.ipv4.ip_forward=1

Lalu jalankan perintah

	sysctl -p
	
	output:
	net.ipv4.ip_forward = 1

Perintah yang harus dilakukan yaitu dengan mengubah/mentranslate ip address dan port dari paket yang datang mengakses ip address dan port dari router debian ke ip address dan port dari debian web server.

<p/>

	iptables -t nat \
	--append PREROUTING \
	--protocol tcp \
	--destination 192.168.122.129 \
	--dport 8080 \
	--jump DNAT \
	--to-destination 192.168.10.254:80

Penjelasan dari perintah di atas yaitu kita menambahkan rule baru ke table NAT dalam chain PREROUTING. Jika paket yang datang menggunakan protocol tcp, tujuan ip address dari paket yaitu 192.168.122.129, dan dengan port tujuan yaitu 8080, maka target akan di DNAT, yaitu operasi yang mengubah ip address dan port dari paket yang datang ke ip address dan port dari debian server.

Langkah tersebut merupakan setengah dari proses, balasan paket harus di rutekan kembali ke debian router, namun saat ini paket tersebut akan tetap memiliki ip address client sebagai alamat sumber, server yang akan mencoba mengirim balasan paket ke ip address dari client yang akan membuat client bingung karena client tidak pernah meminta request ke debian server, melainkan client meminta request ke debian router.

Untuk mengkonfigurasi routing yang benar, debian router harus memodifikasi paket yang keluar ke debian server menjadi ip address dari debian router itu sendiri, agar debian server mengirimkan paket balasan ke debian router yang nantinya akan dikirimkan lagi ke client oleh debian router.

Untuk mengaktifkannya, kita hanya perlu menambahkan rule baru ke table nat di chain POSTROUTING.

	iptables -t nat \
	--append POSTROUTING \
	--protocol tcp \
	--destination 192.168.10.254 \
	--dport 80 \
	--jump SNAT \
	--to-source 192.168.122.129

Penjelasan perintah di atas yaitu, kita menambahkan rule baru ke table nat di chain POSTROUTING, jika paket menggunakan protokol tcp, dengan destination ip 192.168.10.254, dan dengan destination port 80, maka target akan di SNAT, proses ini akan merubah source ip dari paket, yang tadinya ip client menjadi ip dari debian router.

Jika sudah, kita test akses dari client

![testing](/notes/image/ss-client-iptables.png)

jika client meng-akses ip address dari debian router dengan port 8080, maka request dari client akan di forward ke ip dan port dari debian server. Hasilnya, client bisa mengakses website dari debian server walaupun dengan mengaksesnya dari ip dan port dari debian router.

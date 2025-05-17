---
title: "Konfigurasi OpenVPN Server dengan Script"
date: 2022-08-12T22:18:00+07:00
---

# Konfigurasi OpenVPN Server dengan Script

OpenVPN adalah sistem jaringan pribadi virtual yang menerapkan teknik untuk membuat koneksi titik-ke-titik atau situs-ke-situs yang aman dalam konfigurasi yang dirutekan atau dijembatani dan fasilitas akses jarak jauh. Ini mengimplementasikan aplikasi klien dan server. [_Wikipedia_](https://en.wikipedia.org/wiki/OpenVPN)

Untuk penggunaan vpn secara umum dibutuhkan ip public, tapi dalam contoh kali ini kita akan menggunakan ip private yang akan kita anggap sebagai ip public untuk openvpn server.

## Topology

![topology](/notes/image/topology-forwarding-openvpn.png)
Client :

-	Address 192.168.122.210
-	Gateway 192.168.122.1

Router Debian :

-	Address ethernet pertama 192.168.122.129 (akan digunakan sebagai IP Public)
-	Gateway 182.168.122.1

<p/>

-	Address ethernet kedua 192.168.10.254
-	Gateway 182.168.10.10

Debian 11 Server :

-	Address 192.168.10.254
-	Gateway 192.168.10.10

## Tujuan

Client bisa terhubung ke debian 11 server dan akan mendapatkan reply jika client melakukan ping ke ip address debian 11 server.

## Konfigurasi OpenVPN

### Installasi OpenVPN

Install wget untuk mendownload script installasi openvpn.

	apt install wget
Download script installasi openvpn dengan wget

	wget https://git.io/vpn -O openvpn-install.sh

Tambahkan permission executable ke file openvpn-install.sh

	chmod +x openvpn-install.sh

Execute script tersebut lalu isikan beberapa konfigurasi yang diperlukan

	./openvpn-install.sh
	Welcome to this OpenVPN road warrior installer!
	
	This server is behind NAT. What is the public IPv4 address or hostname?
	Public IPv4 address / hostname [36.80.142.183]: 192.168.122.129
	
	Which protocol should OpenVPN use?
	   1) UDP (recommended)
	   2) TCP
	Protocol [1]: 1
	
	What port should OpenVPN listen to?
	Port [1194]: 1194
	
	Select a DNS server for the clients:
	   1) Current system resolvers
	   2) Google
	   3) 1.1.1.1
	   4) OpenDNS
	   5) Quad9
	   6) AdGuard
	DNS server [1]: 3
	
	Enter a name for the first client:
	Name [client]: client1
	
Copy file client1 ke user dengan akses ssh agar bisa kita copy dari sisi client, karena dalam contoh kali ini akses ssh dengan user root masih kita block. 

	cp client1.ovpn /home/vm1/

Setelah menjalankan script tersebut, akan muncul file dengan ekstensi .ovpn yang akan digunakan client untuk menghubungkan ke openvpn server.

### Port Forwarding dengan IPtables 

Install package iptables

	apt install iptables

Buka port yang diperlukan, contoh port ssh, openvpn, dan ftp

	iptables -A INPUT -p tcp --dport 22 -s 0/0 -j ACCEPT
	iptables -A INPUT -p tcp --dport 21 -s 0/0 -j ACCEPT
	iptables -A INPUT -p tcp --dport 1194 -s 0/0 -j ACCEPT	

Di Router Debian, kita akan men-forward semua paket yang masuk dengan port 1194 (udp) ke server debian dengan IPtables. Karena kita juga akan menggunakan ftp untuk transfer file ovpn dari server ke client, maka kita forward juga port 21 (tcp).

Port openvpn (1194)

	iptables -t nat \
	--append PREROUTING \
	--protocol udp \
	--destination 192.168.122.129 \
	--dport 1194 \
	--jump DNAT \
	--to-destination 192.168.10.254:1194

<p/>

	iptables -t nat \
	--append POSTROUTING \
	--protocol udp \
	--destination 192.168.10.254 \
	--dport 1194 \
	--jump SNAT \
	--to-source 192.168.122.129

### Menghubungkan ke VPN Server dari Client

Pertama - tama, cek apakah client bisa terhubung ke debian server dengan menggunakan ping tanpa connect menggunakan openvpn.

	ping 192.168.10.254
	PING 192.168.10.254 (192.168.10.254) 56(84) bytes of data.
	From 192.168.122.1 icmp_seq=1 Destination Port Unreachable
	From 192.168.122.1 icmp_seq=2 Destination Port Unreachable
	From 192.168.122.1 icmp_seq=3 Destination Port Unreachable
	From 192.168.122.1 icmp_seq=4 Destination Port Unreachable
	From 192.168.122.1 icmp_seq=5 Destination Port Unreachable
	From 192.168.122.1 icmp_seq=6 Destination Port Unreachable
	^C
	--- 192.168.10.254 ping statistics ---
	6 packets transmitted, 0 received, +6 errors, 100% packet loss, time 5118ms

Dalam percobaan diatas, client belum bisa terhubung dengan debian server. 	

Copy file yang client1.ovpn dengan scp, untuk contoh saat ini, kita akan menggunakan scp dari debian server ke debian router dan selanjutnya ke debian client.

Debian router copy file dari debian server

	scp vm1@192.168.10.254://home/vm1/client1.ovpn /home/vm1/

Debian client copy file dari debian router

	scp vm1@192.168.122.129://home/vm1/client1.ovpn /home/vm

Install package openvpn di client

	sudo apt install openvpn

Connect ke openvpn server dengan config file yang telah dicopy

	sudo openvpn --config /home/vm/client1.ovpn

Jika pada output sudah muncul baris berikut maka client sudah terhubung ke vpn server.

	2022-08-12 22:04:02 Initialization Sequence Completed

Selanjutnya kita tes lagi dengan melakukan ping dari client ke debian server.

	ping 192.168.10.254
	PING 192.168.10.254 (192.168.10.254) 56(84) bytes of data.
	64 bytes from 192.168.10.254: icmp_seq=1 ttl=64 time=2.01 ms
	64 bytes from 192.168.10.254: icmp_seq=2 ttl=64 time=1.97 ms
	64 bytes from 192.168.10.254: icmp_seq=3 ttl=64 time=3.24 ms
	64 bytes from 192.168.10.254: icmp_seq=4 ttl=64 time=2.40 ms
	^C
	--- 192.168.10.254 ping statistics ---
	4 packets transmitted, 4 received, 0% packet loss, time 3013ms
	rtt min/avg/max/mdev = 1.972/2.405/3.243/0.511 ms

Dari output diatas terlihat bahwa client dapat melakukan ping ke debian server dan mendapatkan reply, yang artinya client dan debian server saling terhubung satu sama lain dan dapat saling berkomunikasi. 

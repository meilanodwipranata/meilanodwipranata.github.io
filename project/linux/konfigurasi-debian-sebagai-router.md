---
title: "Konfigurasi Debian Sebagai Router"
date: 2022-04-06T16:04:50+07:00
draft: false
---

# Konfigurasi Debian Server Sebagai Default Gateway / Router

Router (Perute atau penghala) adalah sebuah alat yang mengirimkan paket data melalui sebuah jaringan atau Internet menuju tujuannya, melalui sebuah proses yang dikenal sebagai perutean atau penghalaan. Proses penghalaan terjadi pada lapisan ketiga (lapisan jaringan seperti Internet Protocol) dari tumpukan protokol (protocol stack) tujuh-lapis OSI. 

Router berfungsi sebagai penghubung dua jaringan atau lebih untuk meneruskan data dari satu jaringan ke jaringan lainnya. Perute berbeda dengan pengalih (switch). Pengallih merupakan penghubung beberapa alat untuk membentuk suatu Local Area Network (LAN). [_wikipedia_](https://id.wikipedia.org/wiki/Perute)

## Topology

---

Topology yang digunakan

![Topology](/notes/image/topology-gateway.png)

## Konfigurasi Server

---

Install beberapa tools

	apt update
	apt install net-tools iptables

Konfigurasi network interfaces

	vi /etc/network/interfaces	

Konfigurasi setiap network interfaces

{{< highlight bash >}}

	auto enp1s0
	iface enp1s0 inet static
		address 192.168.100.5
		netmask 255.255.255.0
		network 192.168.100.0
		gateway 192.168.100.1

	auto enp7s0
	iface enp7s0 inet static
		address 192.168.20.6
		netmask 255.255.255.248
		network 192.168.20.0

{{< /highlight >}}

Restart service networking

	systemctl restart networking

Konfigurasi resolve.conf

	vi /etc/resolv.conf

{{< highlight bash >}}

nameserver 8.8.8.8

{{< /highlight >}}


Uncomment pada baris "#net.ipv4.ip_forward=1" di /etc/sysctl.conf

	vi /etc/sysctl.conf

{{< highlight bash >}}
	# Uncomment the next line to enable packet forwarding for IPv4
	net.ipv4.ip_forward=1
{{< /highlight >}}


Tambahkan baris berikut pada config /etc/rc.local.

	vi /etc/rc.local

{{< highlight bash >}}
	iptables -t nat -A POSTROUTING -j MASQUERADE
	exit 0
{{< /highlight >}}


Jika tidak ada rc.local, tetap tambahkan rc.local di /etc/rc.local

	vi /etc/rc.local

{{< highlight bash >}}
	#!/bin/sh -e
	#
	# rc.local
	
	iptables -t nat -A POSTROUTING -j MASQUERADE
	exit 0
{{< /highlight >}}

Dan tambahkan executable permission pada rc.local.

	chmod +x /etc/rc.local

Restart rc-local service.

	systemctl restart rc.local

Restart debian router

	reboot

## Client

---

Set ip address dan default gateway pada client

	vi /etc/network/interfaces

{{< highlight bash >}}
	auto enp1s0
	iface enp1s0 inet static
        address 192.168.20.2
        netmask 255.255.255.248
        network 192.168.20.0
        gateway 192.168.20.6

{{< /highlight >}}

Restart networking

	systemctl restart networking	

Ping ke google.com

	ping google.com

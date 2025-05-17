---
title: "Konfigurasi IP Address Interface di Debian 11"
date: 2021-12-04T12:23:37+07:00
draft: false
toc: false
images:
tags:
  - untagged
---

# Langkah - langkah konfigurasi IP Address interface di Debian 11

## **Static Configuration**

---

1. Masuk konfigurasi file yang berada di /etc/network/interfaces

		vim /etc/network/interfaces

2. Tambahkan beberapa konfigurasi dan ip address seperti dibawah ini, sesuaikan dengan nama ethernet yang ada

_note_ = pada baris awal konfigurasi file, auto berfungsi untuk mengaktifkan interface ethernet pada saat booting, selanjutnya interface (iface) enp1s0 akan di konfigurasi menjadi ip static 

{{< highlight bash >}}
auto enp1s0
iface enp1s0 inet static
	address 192.168.16.10
	netmask 255.255.255.0
	network 192.168.16.0
	broadcast 192.168.16.255
	gateway 192.168.16.1
{{< /highlight>}}

3. Restart konfigurasi network interface

		systemctl restart networking

4. Check IP Address

	Untuk mengecek ip address pada interface ada beberapa cara, yaitu:

	Dengan menggunakan ifconfig

		ifconfig		# check ip address pada interface yang masih aktif
		ifconfig -a		# check ip address pada semua interface yang aktif maupun tidak aktif
		ifconfig enp1s0		# check ip address pada spesifik interface

	Dengan menggunakan perintah ip address

		ip address

## **Dynamic Configuration**

---

Sama seperti static configuration, file konfigurasi berada di /etc/network/interfaces,pada konfigurasi ip dynamic (DHCP) hanya mengkonfigurasi pada baris auto dan iface enp1s0 inet dhcp 

	vi /etc/network/interfaces

{{< highlight bash >}}
auto enp1s0
iface enp1s0 inet dhcp
{{< /highlight>}}

Restart networking service

	systemctl restart networking
 
## Perintah perintah yang sering digunakan

---

	systemctl start networking		# mengaktifkan service networking
	systemctl stop networking		# menghentikan service networking
	systemctl enable networking		# mengaktifkan service networking (dan aktif otomatis pada saat booting)
	systemctl disable networking	# mendisable service networking secara otomatis pada saat booting
	systemctl restart networking	# memulai ulang / merestart service networking



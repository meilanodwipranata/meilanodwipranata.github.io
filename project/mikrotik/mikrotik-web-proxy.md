---
title: "Setting DHCP, NAT, dan Web Proxy di Mikrotik"
date: 2022-08-31T09:52:00+07:00
---

# Setting DHCP, NAT, dan Web Proxy di Mikrotik

## Pengenalan

---

Proxy adalah suatu software/aplikasi yang digunakan untuk menjembatani atau sebagai perantara antara client dengan server. sehingga client tidak berkomunikasi langsung dengan server - server yang ada di intenet.

Beberapa fungsi dari web proxy adalah seperti:

**Caching**, Web proxy dapat melakukan caching content, yaitu menyimpan beberapa content dari website dan menyimpannya di memori. Content tersebut akan digunakan kembali jika client melakukan request dengan content/data yang sama. Sehingga dapat menghemat bandwith internet dan mempercepat kecepatan koneksi.

**Filtering**, Web proxy juga dapat membatasi konten konten tertentu yang bisa di akses/request oleh client. Contohnya seperti blok beberapa website, ekstensi file tertentu, redirect ke situs lain, dll.

**Connection Sharing**, Web proxy dapat meningkatkan tingkat keamanan client yang sedang berselancar di internet, karena PC client tidak berhubungan langsung dengan server - server yang ada di internet

## Topology

---

![topology](/notes/image/dhcp-web-proxy/ss-topology.png)

## Setting IP Address di Mikrotik

---

### **Manual**

1. Set IP Address pada setiap interface yang akan digunakan, yang ada di _IP -> Address -> + (tanda tambah) -> masukkan ip address -> OK_

![ss set ip interface](/notes/image/dhcp-web-proxy/ss1.png)

2. Masukkan ip gateway yang pada interface yang terhubung dengan internet. _IP -> Routes -> + (tanda tambah) -> masukkan ip gateway di kolom Gateway -> Apply_

![ss set gateway](/notes/image/dhcp-web-proxy/ss2.png)

3. Set DNS di _IP -> DNS -> masukkan DNS di kolom DNS -> checklist Allow Remote Requests -> OK_

![ss set DNS](/notes/image/dhcp-web-proxy/ss3.png)

4. Buka _New Terminal_ dan ketikkan ping ke google.com, jika muncul reply maka koneksi antara router ke internet berhasil

![ss new terminal](/notes/image/dhcp-web-proxy/ss4.png)

### **DHCP Client**

1. Buka _IP -> DHCP Client -> + (tanda tambah) -> pilih interface yang terhubung ke DHCP server -> ok_

![ss dhcp client](/notes/image/dhcp-web-proxy/ss5.png)

Maka IP address, gateway dan dns akan ter - set secara otomatis

## Setting DHCP Server di Mikrotik

---

DHCP Server berfungsi untuk memberikan ip secara otomatis ke client yang terhubung ke router pada interface tertentu, sehingga client tidak perlu menambahkan ip ke device mereka secara manual. 

Klik _IP -> DHCP Server -> DHCP Setup -> Atur opsi dengan benar dan disesuaikan dengan kebutuhan_

![ss dhcp server](/notes/image/dhcp-web-proxy/ss6.png)

Beberapa opsi diantaranya
- Pada DHCP server interface, pilih interface yang akan terhubung dengan client, kemudian klik next 
- Pada dhcp address space, masukkan network address dari ip address interface yang dipilih, kemudian klik Next
- Pada gateway for DHCP, masukkan ip address dari interface yang digunakan dhcp server, yang nantinya akan dijadikan ip gateway bagi client, kemudian klik next
- Address to Give Out, yaitu range address yang akan digunakan oleh client
- DNS server, dns yang akan digunakan oleh client sebagai dns resolver beberapa public dns yang bisa digunakan seperti 8.8.8.8 (dari google), 1.1.1.1 (dari cloudflare), dsb. Lalu klik Next
- Lease time, yaitu waktu penyewaan ip ke client. Setelah itu klik next dan setup DHCP server telah selesai

### **Set NAT Masquerade**

NAT Maasquerade memungkinkan router untuk men-translate beberapa ip address ke dalam suatu ip address lainnya, biasanya digunakan untuk menyembunyikan internal network dari public network.

Masuk ke _IP -> Firewall -> tab NAT -> + (tanda tambah) -> chain pilih srcnat -> Out. Interface pilih interface yang terhubung ke internet -> pilih tab Action -> ganti Action ke Masquerade -> klik OK_

![](/notes/image/dhcp-web-proxy/ss7.png)

<p/>

![](/notes/image/dhcp-web-proxy/ss8.png)


### **Testing DHCP Server dan NAT dari Client (Linux)**

Buka terminal dan ketikkan perintah dhclient, perintah dhclient berfungsi untuk memperoleh, memperbarui, atau melepaskan subnet mask, default gateway, dan DNS servers dari DHCP server.

	sudo dhclient -r enp1s0	# -r berfungsi untuk melepaskan ip address saat ini
	sudo dhclient enp1s0	# memperbarui dhcp

Masukkan perintah ifconfig untuk mengecek ip address

	sudo ifconfig

output

	enp1s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
	        inet 192.168.10.253  netmask 255.255.255.0  broadcast 192.168.10.255
	        inet6 fe80::5054:ff:fea2:d8b7  prefixlen 64  scopeid 0x20<link>
	        ether 52:54:00:a2:d8:b7  txqueuelen 1000  (Ethernet)
	        RX packets 3789  bytes 260064 (253.9 KiB)
	        RX errors 0  dropped 2644  overruns 0  frame 0
	        TX packets 5103  bytes 225892 (220.5 KiB)
	        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
	
	lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
	        inet 127.0.0.1  netmask 255.0.0.0
	        inet6 ::1  prefixlen 128  scopeid 0x10<host>
	        loop  txqueuelen 1000  (Local Loopback)
	        RX packets 3382  bytes 321384 (313.8 KiB)
	        RX errors 0  dropped 0  overruns 0  frame 0
	        TX packets 3382  bytes 321384 (313.8 KiB)
	        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ping ke google.com

	ping google.com

output

	PING google.com (142.251.12.139) 56(84) bytes of data.
	64 bytes from se-in-f139.1e100.net (142.251.12.139): icmp_seq=1 ttl=55 time=26.5 ms
	64 bytes from se-in-f139.1e100.net (142.251.12.139): icmp_seq=2 ttl=55 time=26.3 ms
	64 bytes from se-in-f139.1e100.net (142.251.12.139): icmp_seq=3 ttl=55 time=26.5 ms
	^C
	--- google.com ping statistics ---
	3 packets transmitted, 3 received, 0% packet loss, time 2002ms
	rtt min/avg/max/mdev = 26.328/26.410/26.453/0.058 ms


## Set Web Proxy

---

Masuk ke _IP -> Web Proxy -> checklist kotak Enabled -> ganti Port jika dibutuhkan -> checklist cache on disk -> klik OK_

cache on disk berfungsi agar penyimpanan caching disimpan di disk, bukan di memory.

![](/notes/image/dhcp-web-proxy/ss9.png)

Setelah itu tambahkan rule baru di web proxy seperti blokir file dan redirect ke website lain.

Contoh blokir file

Masuk ke _IP -> Web Proxy -> Access -> + (tanda tambah) -> di kolom path, masukkan file/extension yang akan di blok, contoh *.iso, semua file dengan extension .iso akan diblock -> action deny untuk block access -> klik OK_

![](/notes/image/dhcp-web-proxy/ss12.png)

contoh redirect website

Masuk ke _IP -> Web Proxy -> Access -> + (tanda tambah) -> pada Dst. Host tambahkan domain yang akan di redirect, contoh lipi.go.id -> pada Action ganti ke redirect (deny jika tidak ada redirect) -> URL tambahkan target URL, contoh youtube.com_

![](/notes/image/dhcp-web-proxy/ss13.png)

Kemudian, tambahkan rule di firewall agar semua request dari http (80) diarahkan ke web proxy.

Masuk ke _IP -> Firewall -> tab NAT -> ganti Chain ke dstnat -> Protocol tcp -> Dst. Port tambahkan 80 -> In. Interface diarahkan ke interface yang terhubung ke client -> Masuk ke tab Action -> ganti Action ke redirect -> To Ports ke port web proxy, 8080 -> klik OK_

![](/notes/image/dhcp-web-proxy/ss10.png)

<p/>

![](/notes/image/dhcp-web-proxy/ss11.png)

> Note: website yang bisa di rule oleh web proxy hanya http bukan https

### **Testing Web Proxy**

Masuk ke Web Browser client dan download file iso dari website http, misal dari repo.ugm.ac.id/iso, maka akan muncul pesan forbidden

![](/notes/image/dhcp-web-proxy/ss14.png)

Jika mengakses laman lipi.go.id maka akan langsung diarahkan ke youtube

![](/notes/image/dhcp-web-proxy/ss15.png)

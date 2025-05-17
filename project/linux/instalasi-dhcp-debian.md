---
title: "Instalasi DHCP server di Debian"
date: 2021-11-25T11:23:31+07:00
draft: false
toc: false
images:
tags:
  - untagged
---

# Instalasi DHCP server di Debian

## Apa itu DHCP server?

---

DHCP (Dynamic Host Configuration Protocol) adalah protokol yang berbasis arsitektur client/server yang dipakai untuk memudahkan pengalokasian alamat IP dalam satu jaringan. Sebuah jaringan lokal yang tidak menggunakan DHCP harus memberikan alamat IP kepada semua komputer secara manual. Jika DHCP dipasang di jaringan lokal, maka semua komputer yang tersambung di jaringan akan mendapatkan alamat IP secara otomatis dari server DHCP. Selain alamat IP, banyak parameter jaringan yang dapat diberikan oleh DHCP, seperti default gateway dan DNS server.

## Langkah Langkah Instalasi DCHP (Dynamic Configuration Host Protocol) di Debian:

---

**1. Update repository debian**

    apt update
    apt upgrade #opsional

**2. Install package isc-dhcp-server dari repository debian**

    apt install isc-dhcp-sever

**3. Konfigurasi dhcp server**  

Kita ubah konfigurasi file dhcp server di /etc/dhcp/dhcpd.conf

    vim /etc/dhcp/dhcpd.conf

{{< highlight bash >}}
  # A slightly different configuration for an internal subnet.
  subnet 192.168.16.0 netmask 255.255.255.0 {
    range 192.168.16.40 192.168.16.50;
    option domain-name-servers 8.8.8.8;
    option domain-name "internal.example.org";
    option routers 192.168.16.1;
    option broadcast-address 192.168.16.255;
    default-lease-time 600;
    max-lease-time 7200;
  }
{{< /highlight >}}

_subnet_	  = network address  
_netmask_	  = subnet mask  
_range_		  = jangkauan ip address dhcp  
_option domain_	  = DNS server  
_option routers_  = IP router / gateway  
_option broadcast_ = IP broadcast  

**4. Konfigurasi interface untuk DHCP**  

    vim /etc/default/isc-dhcp-server

{{< highlight bash >}}
17 INTERFACESv4="enp1s0"
18 INTERFACESv6=""
{{< /highlight >}}

**5. Restart DHCP service**

    systemctl restart isc-dhcp-server

**6. Pengujian Client**

Pengujian dari client menggunakan linux desktop  
Perintah yang digunakan:

Killed old client process / menghapus konfigurasi DHCP saat ini  

    sudo dhclient -r enp1s0

Memperbarui DHCP client

    sudo dhclient enp1s0

### DHCP multiple subnet

    vi /etc/dhcp/dhcpd.conf

{{< highlight bash >}}
# A slightly different configuration for an internal subnet.
#
# Subnet Pertama
subnet 192.168.10.0 netmask 255.255.255.0 {
  range 192.168.10.20 192.168.10.30;
  option domain-name-servers 192.168.10.5, 1.1.1.1;
  option domain-name "";
  option routers 192.168.10.5;
  option broadcast-address 192.168.10.255;
  default-lease-time 600;
  max-lease-time 7200;
}
#
# Subnet kedua
subnet 192.168.20.0 netmask 255.255.255.0 {
  range 192.168.20.20 192.168.20.30;
  option domain-name-servers 192.168.20.5, 1.1.1.1;
  option domain-name "";
  option routers 192.168.20.5;
  option broadcast-address 192.168.20.255;
  default-lease-time 600;
  max-lease-time 7200;
{{< /highlight >}}

    vi /etc/default/isc-dhcp-server

{{< highlight bash >}}
INTERFACESv4="enp7s0 enp8s0"
INTERFACESv6=""
{{< /highlight >}}

Restart isc-dhcp-server service

    systemctl restart isc-dhcp-server

### DHCP static lease

    vi /etc/dhcp/dhcpd.conf

{{< highlight bash >}}
# A slightly different configuration for an internal subnet.
#
# Subnet Pertama
subnet 192.168.10.0 netmask 255.255.255.0 {
  range 192.168.10.20 192.168.10.30;
  option domain-name-servers 192.168.10.5, 1.1.1.1;
  option domain-name "";
  option routers 192.168.10.5;
  option broadcast-address 192.168.10.255;
  default-lease-time 600;
  max-lease-time 7200;
}
#
# Subnet kedua
subnet 192.168.20.0 netmask 255.255.255.0 {
  range 192.168.20.20 192.168.20.30;
  option domain-name-servers 192.168.20.5, 1.1.1.1;
  option domain-name "";
  option routers 192.168.20.5;
  option broadcast-address 192.168.20.255;
  default-lease-time 600;
  max-lease-time 7200;
#
# Static Lease
host deb1 { #host <hostname dhcp client>
  hardware ethernet 52:54:00:34:1c:97; #mac address client
  fixed-address 192.168.10.21; #static ip lease
}

host debcl {
  hardware ethernet 52:54:00:be:2d:6b;
  fixed-address 192.168.20.21;
}
{{< /highlight >}}

    vi /etc/default/isc-dhcp-server

{{< highlight bash >}}
INTERFACESv4="enp7s0 enp8s0"
INTERFACESv6=""
{{< /highlight >}}

Restart isc-dhcp-server service

    systemctl restart isc-dhcp-server
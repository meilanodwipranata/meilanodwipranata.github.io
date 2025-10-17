# 🧭 Debian VM Sebagai DHCP Server dan Gateway NAT

Panduan ini menjelaskan cara mengatur **VM Debian di VirtualBox** sebagai **DHCP server sekaligus gateway internet (NAT)** untuk klien yang terhubung ke jaringan lokal (LAN), misalnya lewat **Host-Only Adapter** atau **Bridged interface**.

---

## 🎯 Tujuan

- Debian VM mendistribusikan IP ke klien (via DHCP).  
- Debian VM meneruskan koneksi internet ke klien (via NAT / IP masquerading).

---

## 🧰 Kebutuhan

- VirtualBox  
- VM Debian (tested on Debian 11+)  
- **2 network adapters** di VM:
  - `eth0`: Terhubung ke internet (via NAT atau bridged)
  - `eth1`: Terhubung ke LAN/klien (via Host-Only Adapter atau lainnya)

---

## ⚙️ Langkah 1: Konfigurasi Adapter di VirtualBox

### Adapter 1 (Internet)
```
Attached to: NAT (atau Bridged Adapter)
```

### Adapter 2 (LAN)
```
Attached to: Host-Only Adapter
```

---

## ⚙️ Langkah 2: Set IP Statis untuk eth1

Edit file konfigurasi jaringan:
```bash
nano /etc/network/interfaces
```

Tambahkan konfigurasi berikut:
```bash
auto eth1
iface eth1 inet static
  address 192.168.10.1
  netmask 255.255.255.0
```

Restart networking:
```bash
systemctl restart networking
```

---

## 📦 Langkah 3: Install dan Konfigurasi DHCP Server

### Install DHCP server:
```bash
apt update
apt install isc-dhcp-server
```

### Edit file konfigurasi DHCP:
```bash
nano /etc/dhcp/dhcpd.conf
```

Contoh konfigurasi:
```bash
subnet 192.168.10.0 netmask 255.255.255.0 {
  range 192.168.10.100 192.168.10.200;
  option routers 192.168.10.1;
  option domain-name-servers 8.8.8.8, 1.1.1.1;
}
```

### Tentukan interface DHCP:
```bash
nano /etc/default/isc-dhcp-server
```

Ubah menjadi:
```bash
INTERFACESv4="eth1"
```

Restart DHCP server:
```bash
systemctl restart isc-dhcp-server
```

---

## 🔥 Langkah 4: Aktifkan IP Forwarding

Edit sysctl.conf:
```bash
nano /etc/sysctl.conf
```

Uncomment atau tambahkan:
```bash
net.ipv4.ip_forward=1
```

Aktifkan tanpa reboot:
```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

---

## 🔥 Langkah 5: Atur iptables untuk NAT (Masquerading)

Asumsikan interface internet adalah `eth0`, dan LAN adalah `eth1`.

```bash
# NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Forwarding rules
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
```

---

## 💾 Langkah 6: Simpan iptables Rules (Opsional)

Agar aturan NAT tetap ada setelah reboot:

```bash
apt install iptables-persistent
```

Pilih **Yes** saat diminta untuk menyimpan rules.

---

## ✅ Uji Coba

1. Sambungkan klien (HP, laptop, VM lain) ke LAN (`eth1` / Host-Only network).  
2. Pastikan klien mendapatkan IP `192.168.10.x` dari DHCP Debian.  
3. Coba browsing dari klien → seharusnya bisa akses internet melalui Debian VM.

---

## 🧪 Troubleshooting

Cek forwarding:
```bash
cat /proc/sys/net/ipv4/ip_forward
```

Cek status DHCP:
```bash
systemctl status isc-dhcp-server
```

Cek IP klien:  
Pastikan IP dan gateway benar:

| Parameter | Nilai |
|------------|--------|
| IP | 192.168.10.x |
| Gateway | 192.168.10.1 |

---

## 📌 Catatan

- Pastikan firewall di Debian tidak memblokir koneksi keluar.  
- Gunakan `brctl`, `nmcli`, atau GUI VirtualBox untuk cek koneksi antar adapter.  
- IP pada klien bisa dicek dengan `ipconfig` (Windows) atau `ip a` (Linux).

---

## 📎 Referensi

- [Debian Networking Guide](https://wiki.debian.org/NetworkConfiguration)  
- [ISC DHCP Server Documentation](https://www.isc.org/dhcp/)  
- [iptables NAT HOWTO](https://www.netfilter.org/documentation/HOWTO/NAT-HOWTO.html)

---

**Happy routing! 🚀**

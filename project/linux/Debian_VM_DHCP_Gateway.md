<style>
body{display:grid;place-items:center;background:linear-gradient(180deg,#071025 0%, #07192b 60%), radial-gradient(600px 300px at 10% 10%, rgba(110,231,183,0.06), transparent), radial-gradient(500px 250px at 90% 90%, rgba(99,102,241,0.04), transparent);color:#e6eef6}.card{width:360px;max-width:92vw;background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));border:1px solid rgba(255,255,255,0.04);padding:28px;border-radius:16px;box-shadow:0 6px 30px rgba(2,6,23,0.6);backdrop-filter: blur(6px)}
</style>
# pelitest
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
sudo apt update
sudo apt install isc-dhcp-server
</pre>




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

<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
Attached to: NAT (atau Bridged Adapter)
</pre>


### Adapter 2 (LAN)
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
Attached to: Host-Only Adapter
</pre>


---

## ⚙️ Langkah 2: Set IP Statis untuk eth1

Edit file konfigurasi jaringan:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
nano /etc/network/interfaces
</pre>

Tambahkan konfigurasi berikut:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
auto eth1
iface eth1 inet static
  address 192.168.10.1
  netmask 255.255.255.0
</pre>


Restart networking:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
systemctl restart networking
</pre>



---

## 📦 Langkah 3: Install dan Konfigurasi DHCP Server

### Install DHCP server:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
apt update
apt install isc-dhcp-server
</pre>


### Edit file konfigurasi DHCP:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
nano /etc/dhcp/dhcpd.conf
</pre>



Contoh konfigurasi:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
subnet 192.168.10.0 netmask 255.255.255.0 {
  range 192.168.10.100 192.168.10.200;
  option routers 192.168.10.1;
  option domain-name-servers 8.8.8.8, 1.1.1.1;
}
</pre>


### Tentukan interface DHCP:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
nano /etc/default/isc-dhcp-server
</pre>


Ubah menjadi:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
INTERFACESv4="eth1"
</pre>


Restart DHCP server:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
systemctl restart isc-dhcp-server
</pre>


---

## 🔥 Langkah 4: Aktifkan IP Forwarding

Edit sysctl.conf:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
nano /etc/sysctl.conf
</pre>


Uncomment atau tambahkan:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
net.ipv4.ip_forward=1
</pre>

Aktifkan tanpa reboot:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
sudo sysctl -w net.ipv4.ip_forward=1
</pre>


---

## 🔥 Langkah 5: Atur iptables untuk NAT (Masquerading)

Asumsikan interface internet adalah `eth0`, dan LAN adalah `eth1`.

<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
# NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Forwarding rules
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
</pre>


---

## 💾 Langkah 6: Simpan iptables Rules (Opsional)

Agar aturan NAT tetap ada setelah reboot:

<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
sudo sysctl -w net.ipv4.ip_forward=1
</pre>


Pilih **Yes** saat diminta untuk menyimpan rules.

---

## ✅ Uji Coba

1. Sambungkan klien (HP, laptop, VM lain) ke LAN (`eth1` / Host-Only network).  
2. Pastikan klien mendapatkan IP `192.168.10.x` dari DHCP Debian.  
3. Coba browsing dari klien → seharusnya bisa akses internet melalui Debian VM.

---

## 🧪 Troubleshooting

Cek forwarding:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
cat /proc/sys/net/ipv4/ip_forward
</pre>


Cek status DHCP:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
systemctl status isc-dhcp-server
</pre>


Cek IP klien:  
Pastikan IP dan gateway benar:
<pre style="background-color:#1e1e1e; color:#00ff00; padding:10px; border-radius:8px;">
| Parameter | Nilai |
|------------|--------|
| IP | 192.168.10.x |
| Gateway | 192.168.10.1 |
</pre>


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

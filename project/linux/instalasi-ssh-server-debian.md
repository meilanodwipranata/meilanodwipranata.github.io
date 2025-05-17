---
title: "Instalasi Ssh Server di Debian"
date: 2021-11-24T20:36:55+07:00
draft: false
toc: false
images:
tags:
  - untagged
---

# Konfigurasi SSH server di Debian 11

## Pengertian SSH

---

SSH (Secure Shell) adalah sebuah protokol jaringan kriptografi untuk komunikasi data yang aman, login antarmuka baris perintah, perintah eksekusi jarak jauh, dan layanan jaringan lainnya antara dua jaringan komputer. Ini terkoneksi, melalui saluran aman atau melalui jaringan tidak aman, server dan klien menjalankan server SSH dan SSH program klien secara masing-masing . Protokol spesifikasi membedakan antara dua versi utama yang disebut sebagai SSH-1 dan SSH-2.

Aplikasi yang paling terkenal dari protokol ini adalah untuk akses ke akun shell pada sistem operasi mirip Unix, tetapi juga dapat digunakan dengan cara yang sama untuk akun pada Windows. Ia dirancang sebagai pengganti Telnet dan protokol remote shell lainnya yang tidak aman seperti rsh Berkeley dan protokol rexec, yang mengirim informasi, terutama kata sandi, dalam bentuk teks, membuat mereka rentan terhadap intersepsi dan penyingkapan menggunakan penganalisis paket.[1] Enkripsi yang digunakan oleh SSH dimaksudkan untuk memberikan kerahasiaan dan integritas data melalui jaringan yang tidak aman, seperti Internet. [Wikipedia](https://id.wikipedia.org/wiki/Secure_Shell)

## Langkah Langkah Instalasi SSH (Secure Shell) di Debian

note:

ssh keys akan men-generate 2 key, yaitu public key dan private key. Private key bersifat rahasia, sebaiknya private key disimpan dengan aman dan terenkripsi. Sedangkan public key bersifat public, yang berarti bisa dibagikan dengan bebas ke beberapa server.

---

**1. Update repository debian**  
{{< highlight bash >}}
apt update
apt ugrade	#opsional
{{< /highlight >}}

**2. Install package openssh-server**  
{{< highlight bash >}}
apt install openssh-server
{{< /highlight >}}

**3. Start ssh service**  
{{< highlight go >}}
systemctl start ssh 	// start ssh
systemctl restart ssh	// restart ssh
systemctl enable ssh	// autostart ssh saat booting
{{< /highlight >}}
Default port dari ssh adalah port 22  
Kita bisa langsung menggunakan ssh tanpa mengganti port  

- **Test remote dari pc client "linux" dengan default port**  
Perintah yang digunakan:  
ssh (userserver)@(ipserver)  
{{< highlight go >}}
ssh bullseye@192.168.1.50
{{< /highlight >}}

**3. Mengganti port ssh**  
Jika tidak ingin menggunakan default port dan ingin menggatinya, kita bisa merubah portnya di file konfigurasi yang berada di /etc/ssh/sshd_config  

{{< highlight go >}}
vim /etc/ssh/sshd_config
{{< /highlight >}}

Uncomment "#Port 22" dan ubah angka portnya, misalnya kita ganti menjadi Port 49190
{{< highlight bash >}}
 13 Include /etc/ssh/sshd_config.d/*.conf
 14
 15 Port 49190
 16 #AddressFamily any
 17 #ListenAddress 0.0.0.0
{{< /highlight >}}

Kemudian restart ssh dengan perintah:  

{{< highlight bash >}}
systemctl restart ssh
{{< /highlight >}}

Selanjunya kita cek portnya terganti atau belum menggunakan perintah:
{{< highlight bash >}}
netstat -tulpn
{{< /highlight >}}

{{< highlight bash >}}
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:49190           0.0.0.0:*               LISTEN      414/sshd: /usr/sbin
tcp        0      0 0.0.0.0:21              0.0.0.0:*               LISTEN      416/proftpd: (accep
tcp6       0      0 :::49190                :::*                    LISTEN      414/sshd: /usr/sbin
{{< /highlight >}}

Jika port ssh sudah terganti maka konfigurasi port ssh sudah berhasil

- **Tes remote dari pc client "linux" dengan custom port**  
Perintah yang digunakan:  
ssh (userserver)@(ipserver) -p (port yang kita ubah)  
{{< highlight bash >}}
ssh bullseye@192.168.1.50 -p 49190
{{< /highlight >}}

### SSH Keygen

---

ssh-keygen -b \<bits> -t \<tipe algorithm>

    ssh-keygen -b 4096 -t ed25519

Lokasi key file yang akan disimpan

    Enter file in which to save the key (/home/vm/.ssh/id_ed25519):

Masukkan passphrase jika menginginkan keamanan lebih

    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again:

Copy ssh public key ke server tujuan

    ssh-copy-id vm1@192.168.10.21

Jika key file diletakkan di folder specific, tambahkan "-i" diikuti lokasi key file

    ssh-copy-id -i /home/vm/.ssh/key1/key1.pub vm1@192.168.10.21
    ssh -i /home/vm/.ssh/key1/key1 vm1@192.168.10.21

ssh manual

    man ssh
    ssh --help
    ssh-keygen --help

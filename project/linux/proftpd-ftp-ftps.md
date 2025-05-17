---
title: "Konfigurasi FTP dan FTPS dengan Proftpd dan openssl di debian"
date: 2022-10-7T16:20:12+07:00
---

# Konfigurasi FTP dan FTPS dengan Proftpd dan openssl di debian

## Perbedaan FTP dengan FTPS?

FTP (File Transfer Protocol) adalah standar protokol komunikasi yang berfungsi untuk melakukan transfer file antar client dengan server yang terhubung dalam suatu network/jaringan. FTP sendiri umumnya tidak dianggap sebagai protokol yang aman, karena dalam autentikasi-nya mengandalkan "clear-text usernames and passwords" yang artinya tidak dienkripsi dan mudah untuk di sadap. Karena masalah kemanan tersebut, muncullah protokol FTP yang lebih aman yang dikembangkan oleh Netscape yang disebut FTPS (File Transfer Protocol Secure). Dengan FTPS kita bisa menggunakan layanan FTP dengan ter-enkripsi.

## Installasi dan Konfigurasi Proftpd server di debian

### Update Repository dan Install Package Proftpd
	
	apt update && apt install proftpd

### Menambahkan User untuk Akses ke Proftpd

Untuk menambahkan user bisa menggunakan perintah useradd, -m untuk memberikan home directory ke user, -s untuk menentukan shell yang digunakan oleh user

	useradd ftpuser -m -s /bin/bash

Selanjutnya tambahkan password ke user tersebut

	passwd ftpuser

### Konfigurasi Proftpd

Sebagian besar setting untuk proftpd berada di /etc/proftpd/proftpd.conf. Lebih baik backup terlebih dahulu file default konfigurasi sebelum mengubahnya.

	cd /etc/proftpd/
	cp proftpd.conf proftpd.conf.bk

<p/>

	vim proftpd.conf

Untuk mengaktifkan default directory yang akan diakses oleh user, uncomment baris berikut.

	DefaultRoot	~

"~" artinya default home directory dari user. Kita bisa mengubah default directory ke path directory lainnya jika perlu.

	DefaultRoot /home/ftpuser/Public

Kita juga bisa menentukan default directory untuk setiap user dengan cara berikut.

	DefaultRoot /home/ftpuser/Public ftpuser
	DefaultRoot /home/user2/ user2

Baris tersebut menunjukkan bahwa directory /home/ftpuser/Public akan dijadikan deafult directory untuk user ftpuser, sedangkan directory /home/user2 dijadikan default directory untuk user2.

Dalam contoh kali ini, kita akan menggunakan konfigurasi "DefaultRoot	~"

Jika ingin mengganti port bisa kita ubah pada baris

	Port [port yang akan kita ubah]

Kita bisa menambahkan opsi lain seperti mengubah "welcome massage" yang akan ditampilkan. Kita bisa menambahkan konfigurasi berikut pada baris paling bawah.

	AccessGrantMsg	"Hi, Welcome"
	AccessDenyMsg	"Not Welcome"

Selanjutnya kita bisa merestart service proftpd

	systemctl restart proftpd

#### Percobaan

Kita coba akses dengan menggunakan filezilla dengan memasukkan host, username, password, dan port jika port telah diganti dari default.

![percobaan akses ftp dengan filezilla](/notes/image/plainftp1.png)

<p/>

![percobaan akses ftp dengan filezilla](/notes/image/plainftp2.png)

<p/>

![percobaan akses ftp dengan filezilla](/notes/image/plainftp3.png)

### Limit User Login ke Proftpd

Untuk me-limit user bisa menggunakan konfigurasi limit

Tambahkan beberapa user sebagai contoh

	useradd ftpuser1 -m -s /bin/bash
	passwd ftpuser1
	useradd ftpuser2 -m -s /bin/nash
	passwd ftpuser2
	useradd ftpuser3 -m -s /bin/nash
	passwd ftpuser3

Contoh kali ini akan me-Allow user ftpuser1 dan ftpuser2, dan menge-blok semua user selain ftpuser1 dan ftpuser2 untuk akses ftp server.

Edir proftpd config file

	vi /etc/proftpd/proftpd.conf

Tambahkan baris berikut ke dalam proftpd.conf


	<Limit LOGIN>
	        AllowUser ftpuser1
	        AllowUser ftpuser2
	        DenyAll
	</Limit>

Restart proftpd service

	systemctl restart proftpd

### Anonymous user proftpd

Untuk membuat anonymous user di proftpd, pertama - tama, buat user baru yang digunakan untuk ftp server

    useradd public -m -s /bin/bash

Selanjutnya, tambahkan baris berikut pada proftpd.conf

    vi /etc/proftpd/proftpd.conf

<p/>
    
    <Anonymous /home/public/>
      User public
      UserAlias public anonymous
    </Anonymous>

Restart proftpd service

    service proftpd restart
	
### Enable TLS FTPS

Install openssl dan module tls

	apt install openssl proftpd-mod-crypto

Edit file proftpd.conf

	vi /etc/proftpd/proftpd.conf

Uncomment baris berikut

	Include /etc/proftpd/tls.conf

Edit file tls.conf

	vi /etc/proftpd/tls.conf

Uncomment baris berikut

	TLSEngine                               on
	TLSLog                                  /var/log/proftpd/tls.log
	TLSProtocol                             SSLv23
	

	TLSRSACertificateFile                   /etc/ssl/certs/proftpd.crt
	TLSRSACertificateKeyFile                /etc/ssl/private/proftpd.key

Generate key dan certificate file dengan openssl

	openssl req -x509 -new -newkey rsa:4096 -keyout /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt -nodes -days 365

Enable module tls di /etc/proftpd/modules.conf dengan uncomment baris berikut

	LoadModule mod_tls.c

Restart proftpd service

	systemctl restart proftpd

Akses ftp dengan filezilla

![akses ftps](/notes/image/ftp_ftps1.png)

Jika gambar tersebut muncul, maka konfigurasi ftps berhasil

Sekian ~

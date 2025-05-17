---
title: "Konfigurasi Mail Server (Postfix, Dovecot, Roundcube) di Debian 11"
date: 2023-02-05T13:34:08+07:00
draft: False
---

# Konfigurasi Mail Server (Postfix, Dovecot, Roundcube) di Debian 11

## Pendahuluan

---

**Mail server** adalah sebuah sistem yang membantu dalam pendistribusian email, baik dalam proses menerima atau mengirim. Secara sederhana, mail server adalah perantara dalam proses pengiriman dan penerimaan surat. Email yang dikirim akan disimpan pada mail server, kemudian selanjutnya diforward oleh mail server ke penerima.

**Postfix** adalah mail transfer agent free dan open source. Postfix merupakan mail transfer agent default untuk sejumlah sistem operasi bertipe Unix. Postfix didistribusikan menggunakan Lisensi Umum IBM 1.0 yang merupakan lisensi perangkat lunak bebas tetapi tidak kompatibel dengan GPL. Salah satu ketangguhan Postfix adalah kemampuannya menahan "buffer overflow". Ketangguhan lainnya adalah kesanggupan Postfix memproses surat elektronik dalam jumlah banyak. 

**Dovecot** adalah server email IMAP dan POP3 open source untuk sistem Linux / UNIX, yang ditulis dengan mengutamakan keamanan. Dovecot adalah pilihan yang sangat baik untuk instalasi kecil dan besar. Cepat, mudah diatur, tidak memerlukan administrasi khusus dan hanya menggunakan sedikit RAM/memori. 

**Roundcube** adalah email client IMAP berbasis web. Fitur Roundcube yang paling menonjol adalah penggunaan teknologi Ajax. Salah satu software open source yang berlisensi GNU General Public License (GPL).

## Konfigurasi Postfix dan Dovecot

---

Sebelum memulai install mail server, ada baiknya siapkan domain khusus yang akan digunakan untuk konfigurasi mail server. Dalam contoh konfigurasi kali ini akan menggunakan nama domain mail.contoh.local yang dibuat menggunakan bind9 secara lokal.

### Installasi Postfix dan Dovecot

Update repository dan install package postfix.

	apt update
	apt install postfix dovecot-imapd dovecot-pop3d

### Konfigurasi Postfix

Setelah installasi selesai akan muncul message box, kemudian pilih internet site agar komunikasi email menggunakan protokol SMTP secara langsung.

![](/notes/image/postfix-1-mailserver.png)

Selanjutnya masukkan nama domain yang akan digunakan.

![](/notes/image/postfix-2-mailserver.png)

Setelah itu, postfix akan menyelesaikan installasinya. Setelah Installasi selesai, edit file di **/etc/postfix/main.cf** dan tambahkan **home_mailbox = Maildir/** pada baris paling bawah.

	vi /etc/postfix/main.cf
<p/>

	...
	inet_interfaces = all
	inet_protocols = all
	
	#tambahkan baris berikut pada baris paling bawah
	home_mailbox = Maildir/

buat mail directory di directory /etc/skel

	maildirmake.dovecot /etc/skel/Maildir

Setelah itu masukkan perintah berikut

	dpkg-reconfigure postfix

Pilih beberapa pilihan dan isikan beberapa input yang akan muncul, sesuaikan dengan topology/konfigurasi sistem dan kebutuhan.

![](/notes/image/postfix-3-mailserver.png)

<p/>

![](/notes/image/postfix-4-mailserver.png)

<p/>

![](/notes/image/postfix-5-mailserver.png)

<p/>

![](/notes/image/postfix-6-mailserver.png)

<p/>

![](/notes/image/postfix-7-mailserver.png)

<p/>

![](/notes/image/postfix-8-mailserver.png)

<p/>

![](/notes/image/postfix-9-mailserver.png)

<p/>

![](/notes/image/postfix-10-mailserver.png)

<p/>

![](/notes/image/postfix-11-mailserver.png)

Restart postfix service.

	systemctl restart postfix


### Konfigurasi Dovecot

Edit file konfigurasi **/etc/dovecot/dovecot.conf**.

	vi /etc/dovecot/dovecot.conf

Uncomment dan edit baris berikut.

	...
	# If you want to specify non-default ports or anything more complex,
	# edit conf.d/master.conf.
	listen = *
	...


Edit file konfigurasi **/etc/dovecot/conf.d/10-auth.conf**.

	vi /etc/dovecot/conf.d/10-auth.conf

Uncomment dan ganti dari yes ke no.

	...
	# connection is considered secure and plaintext authentication is allowed.
	# See also ssl=required setting.
	disable_plaintext_auth = no
	...

Edit file konfigurasi **/etc/dovecot/conf.d/10-mail.conf**.

	vi /etc/dovecot/conf.d/10-mail.conf

Uncomment pada baris berikut.

	...
	mail_location = maildir:~/Maildir
	...

Beri comment pada baris berikut.

	...
	# mail_location = mbox:~/mail:INBOX=/var/mail/%u
	...

Restart dovecot service.

	systemctl restart dovecot

### Menambahkan User Email

Tambahkan beberapa user dan password menggunakan perintah adduser yang akan digunakan untuk user email. Pada percobaan kali ini akan membuat dua user, yaitu satu dan dua.

	adduser satu

<p/>

	adduser dua

Restart postfix dan dovecot service.

	systemctl restart postfix dovecot


### Testing Postfix dan Dovecot menggunakan Telnet

Install package telnet.

	apt install telnet

Test kirim file menggunakan perintah telnet **\<nama domain\> \<port\>** dengan menggunakan port 25 (SMTP). <br/>
Masukkan nama alamat pengirim menggunakan **mail from:**. <br/>
Masukkan nama alamat penerima menggunakan **rcpt to:**. <br/>
Ketikkan data lalu enter.<br/>
Isikan subject dengan megetikkan **Subject: \<isi subject\>**.<br/>
Lalu isikan pesan yang akan dikirim kemudian isikan titik (**.**) untuk mengakhiri pesan.

	telnet mail.contoh.local 25

<p/>
	
	Trying 192.168.122.146...
	Connected to mail.contoh.local.
	Escape character is '^]'.
	220 debian ESMTP Postfix (Debian/GNU)
	mail from: satu@mail.contoh.local
	250 2.1.0 Ok
	rcpt to: dua@mail.contoh.local
	250 2.1.5 Ok
	data
	354 End data with <CR><LF>.<CR><LF>
	Subject: Testing
	Hello World!
	.
	250 2.0.0 Ok: queued as 7DEAD11DF
	quit
	221 2.0.0 Bye
	Connection closed by foreign host.


Melihat pesan menggunakan perintah **telnet \<nama domain\> \<port\>**.<br/>
Login user menggunakan **user \<nama user\>**.<br/>
Dan masukkan password menggunakan **pass \<password\>**.<br/>
Untuk melihat list pesan yang diterima menggunakan perintah **list**. <br/>
Dan untuk membuka pesan yang diterima menggunakan perintah **retr \<nomer pesan\>**.<br\>
Perintah **quit** untuk keluar dari telnet.

	telnet mail.contoh.local 110

<p/>

	Trying 192.168.122.146...
	Connected to mail.contoh.local.
	Escape character is '^]'.
	+OK Dovecot (Debian) ready.
	user dua
	+OK
	pass 0909
	+OK Logged in.
	list
	+OK 1 messages:
	1 436
	.
	retr 1
	+OK 436 octets
	Return-Path: <satu@mail.contoh.local>
	X-Original-To: dua@mail.contoh.local
	Delivered-To: dua@mail.contoh.local
	Received: from unknown (unknown [192.168.122.146])
		by debian (Postfix) with SMTP id 7DEAD11DF
		for <dua@mail.contoh.local>; Sun,  5 Feb 2023 00:41:33 +0700 (WIB)
	Subject: Testing
	Message-Id: <20230204174142.7DEAD11DF@debian>
	Date: Sun,  5 Feb 2023 00:41:33 +0700 (WIB)
	From: satu@mail.contoh.local
	
	Hello World!
	.
	quit
	+OK Logging out.
	Connection closed by foreign host.

## Konfigurasi Roundcube

### Install Mariadb dan Roundcube

Install roundcube sebagai webmail yang akan digunakan oleh client, dan package mariadb yang nantinya akan digunakan sebagai database dari roundcube.

	apt install mariadb-server roundcube

Pilih yes untuk membuat database secara otomatis oleh roundcube.

![](/notes/image/roundcube-1-mailserver.png)

Masukkan password database roundcube.

![](/notes/image/roundcube-2-mailserver.png)

<p/>

![](/notes/image/roundcube-3-mailserver.png)

Edit file **/etc/roundcube/config.inc.php**.

	vi /etc/roundcube/config.inc.php

Isikan default host dengan nama domain mail server.

	...
	// For example %n = mail.domain.tld, %t = domain.tld
	$config['default_host'] = 'mail.contoh.local';
	...

Ganti smtp server dengan nama domain mail server.

	...
	// For example %n = mail.domain.tld, %t = domain.tld
	$config['smtp_server'] = 'mail.contoh.local';
	...

Ganti smtp port dari 587 ke 25.

	...
	// SMTP port. Use 25 for cleartext, 465 for Implicit TLS, or 587 for STARTTLS (default)
	$config['smtp_port'] = 25;
	...

Kosongkan value dari smtp user.

	...
	// will use the current username for login
	$config['smtp_user'] = '';
	...

Kosongkan value dari smtp password.

	...
	// will use the current user's password for login
	$config['smtp_pass'] = '';
	...

Configure ulang roundcube (langkah ini bisa dilewati).

	dpkg-reconfigure roundcube-core

Kosongkan karena kita tidak menggunakan tls.

![](/notes/image/roundcube-4-mailserver.png)

Pilih bahasa untuk roundcube.

![](/notes/image/roundcube-5-mailserver.png)

Pilih no jika tidak ingin reinstall database yang telah dibuat.

![](/notes/image/roundcube-6-mailserver.png)

Check pada pilihan apache dan uncheck lighttpd.

![](/notes/image/roundcube-7-mailserver.png)

Pilih yes untuk merestart web server.

![](/notes/image/roundcube-8-mailserver.png)

Keep local version jika tidak ingin merubah versi roundcube ke yang lebih terbaru.

![](/notes/image/roundcube-9-mailserver.png)

Edit apache config untuk memasukkan konfigurasi tambahan dari roundcube ke apache config.

	vi /etc/apache2/apache2.conf

Tambahkan pada baris paling bawah.

	Include /etc/roundcube/apache.conf

Selanjutnya, masuk ke directory website apache dan tambahkan file baru untuk mail server.

	cd /etc/apache2/sites-available
	touch mail.conf
	vi mail.conf

<p/>

	<VirtualHost *:80>
        ServerName mail.contoh.local
        DocumentRoot /usr/share/roundcube
	</VirtualHost>

Disable apache default config dan enable kan mail config.

	a2dissite 000-default.conf
	a2ensite mail.conf

Restart apache service.

	systemctl restart apache2

## Testing

Selanjutnya buka web browser pada sisi client dan masukkan domain dari mail server, maka akan muncul interface dari roundcube. Lalu login menggunakan salah satu user yang telah dibuat.

![](/notes/image/testing-1-mailserver.png)

Klik pada compose dan isikan pesan untuk user lainnya. Lalu klik send.

![](/notes/image/testing-2-mailserver.png)

Logout dan login ke user penerima, maka akan muncul pesan yang dikirim.

![](/notes/image/testing-3-mailserver.png)

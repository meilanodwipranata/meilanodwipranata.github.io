---
title: "Installasi Webmin di Debian"
date: 2022-08-03T21:29:52+07:00
---

# Installasi Webmin di Debian

## Install webmin

Pertama-tama, tambahkan repository webmin ke list apt repository kita. Buka file /etc/apt/sources.list dan edit file tersebut

	vi /etc/apt/sources.list

Tambahkan baris berikut

	deb http://download.webmin.com/download/repository sarge contrib

Selanjutnya, tambahkan webmin gpg key agar sistem mempercayai repository yang baru ditambahkan. Agar bisa melakukannya, kita harus install gnupg1 package, yang mana merupakan tools dari GNU yang berfungsi sebagai secure communication and data storage.

Update repository terlebih dahulu

	apt update

Install gnupg1

	apt install gnupg1

Setelah itu download the webmin pgp key dengan wget

	wget http://www.webmin.com/jcameron-key.asc

Tambahkan package key

	apt-key add jcameron-key.asc

Update repository

	apt update

Install webmin

	apt install webmin

Akses Webmin di web browser dengan port 10000 dan memasukkan user dan password

![webmin login page](/notes/image/ss_webmin0.png)

<p/>

![webmin login page](/notes/image/ss_webmin1.png)

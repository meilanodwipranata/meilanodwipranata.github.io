# VLAN Management Pada Perangkat Mikrotik

VLAN merupakan suatu fitur yang sangat berguna untuk menghemat resource hardware di jaringan kita. Kita bisa melewatkan beberapa segmen jaringan di 1 interface fisik atau 1 kabel yang sama.
Untuk tutorial penggunaan vlan sudah sering kami bahas pada Youtube Mikrotik Indonesia (Citraweb) dan Artikel Citraweb.
Pada artikel ini kita akan mencoba untuk membuat VLAN management pada perangkat MikroTik. VLAN management adalah suatu VLAN yang bisa kita gunakan untuk melakukan remote ke perangkat.
Jika tanpa menggunakan VLAN management tentunya kita akan merasa kebingungan ketika ingin meremote perangkat / switch yang baru saja kita konfigurasikan vlan.

Konfigurasi VLAN Management pada CRS 3XX Series
Contoh yang pertama kita akan mencoba untuk menggunakan perangkat CRS 3XX Series. Cara ini juga bisa digunakan untuk perangkat router (routerboard / ccr) yang ingin difungsikan sebagai switch.

## Mode Untagged

Untuk mode untagged akan sederhana karena kita akan memberikan IP pada interface bridge nya langsung. Kita tidak akan membuat interface vlan management pada router maupun switch.

Contoh topologi yang kita gunakan adalah seperti gambar berikut: <img clas="center" src="/notes/image/001-config-vlan.png">

Konfigurasi pada router, IP Address untuk management terpasang pada interface yang mengarah ke switch.

<p align="center"> <img src="/notes/image/002-config-vlan.png"></p>
Dan konfigurasi pada switch adalah sebagai berikut:

Pada kasus ini ether1 adalah trunk, ether2, dan ether3 adalah port access yang akan digunakan untuk client.

<p align="center"> <img src="/notes/image/003-config-vlan.png"></p>

Pertama, buat bridge untuk ether1 (trunk), ether2 (access), dan ether3 (access). Jangan lupa tentukan pvid untuk port access, detail cek pada gambar berikut:<br>

<p align="center"><img src="/notes/image/004-config-vlan.png"><br></p>
<p align="center"><img src="/notes/image/005-config-vlan.png"><br></p>
<p align="center"><img src="/notes/image/006-config-vlan.png"><br></p>
<p align="center"><img src="/notes/image/007-config-vlan.png"><br></p>

Kemudian konfigurasikan pada tab VLANs<br>

<p align="center"><img src="/notes/image/008-config-vlan.png"></p>
<br>
<p align="center"><img src="/notes/image/009-config-vlan.png"></p>

Jangan lupa aktifkan vlan filtering pada bridge yang kita buat tadi.<br>

<p align="center"><img src="/notes/image/010-config-vlan.png"><br></p>

Selanjutnya konfigurasikan IP address untuk vlan management pada interface bridge yang sudah dibuat tadi.<br>

<p align="center"><img src="/notes/image/011-config-vlan.png"><br></p>

## Mode Tagged

<br>
<p align="center"><img src="/notes/image/012-config-vlan.png"></p>
Dengan menggunakan mode tagged ini kita akan membuat interface vlan untuk vlan management. Sebagai contoh disini akan menggunakan vlan 99 untuk vlan management nya.

Konfigurasi pada router<br>

<p align="center"><img src="/notes/image/013-config-vlan.png"><br></p>

Pada router terdapat interface vlan management yaitu vlan 99 dan IP address terpasang pada interface vlan tersebut.

Konfigurasi pada switch
Untuk topologi nya masih sama, di ether1 sebagai trunk, ether2 dan ether3 sebagai port access.<br>

<p align="center"><img src="/notes/image/014-config-vlan.png"><br></p>

<p align="center"><img src="/notes/image/015-config-vlan.png"></p>

Buat bridge untuk ether1 (trunk), ether2 (access), dan ether3 (access). Jangan lupa tentukan pvid untuk port access, detail cek pada gambar berikut:<br> <img src="/notes/image/016-config-vlan.png"><br> <img src="/notes/image/017-config-vlan.png"><br> <img src="/notes/image/018-config-vlan.png"><br>

Selanjutnya buat pada tab VLANs untuk vlan 11, vlan 12, dan vlan 99. Untuk VLAN management yaitu vlan 99, tambahkan juga port bridge sebagai tagged.<br> <img src="/notes/image/019-config-vlan.png"><br> <img src="/notes/image/020-config-vlan.png"><br> <img src="/notes/image/021-config-vlan.png"><br>

Setelah itu bisa kita aktifkan untuk vlan filtering nya.<br> <img src="/notes/image/022-config-vlan.png"><br>

Kemudian kita bisa membuat interface vlan dengan vlan id 99. Setelah itu bisa diberi IP pada interface vlan99 tersebut sesuai dengan alokasi untuk IP vlan management yang sudah temen temen tentukan sebelumnya. Sampai disini vlan management untuk CRS 3XX Series sudah bisa digunakan.<br> <img src="/notes/image/023-config-vlan.png"><br>

## Konfigurasi VLAN Management pada CRS 1XX / 2XX Series

Untuk konfigurasi VLAN pada CRS 1XX / 2XX Series ini sedikit berbeda. Kita tidak menggunakan menu bridge, namun menggunakan menu switch.

## Mode Untagged

Konfigurasi pada router, IP Address untuk management terpasang pada interface yang mengarah ke switch.<br> <img src="/notes/image/024-config-vlan.png"><br>

Untuk konfigurasi pada switch bisa dilihat pada gambar berikut:<br> <img src="/notes/image/025-config-vlan.png"><br> <img src="/notes/image/026-config-vlan.png"><br>

Kita buat terlebih dahulu untuk bridge nya, masukkan port ethernet yang menjadi trunk dan access di satu bridge yang sama. Pada contoh ini ether24 adalah trunk, sedangkan ether1 dan ether2 adalah access.
Selanjutnya kita masuk ke menu Switch → VLAN
Tambahkan konfigurasi Ingress VLAN<br> <img src="/notes/image/027-config-vlan.png"><br>

Tambahkan konfigurasi Egress VLAN<br> <img src="/notes/image/028-config-vlan.png"><br> <img src="/notes/image/029-config-vlan.png"><br>

Konfigurasikan Switch VLAN<br> <img src="/notes/image/030-config-vlan.png"><br> <img src="/notes/image/031-config-vlan.png"><br>

Kita tambahkan juga vlan id 0 untuk port ether24 (trunk) dan switch1-cpu.<br> <img src="/notes/image/032-config-vlan.png"><br>

Konfigurasi pada menu switch → settings dan set untuk Drop If Invalid VLAN On Ports ether24 (trunk), ether1 (access), dan ether2 (access).<br> <img src="/notes/image/033-config-vlan.png"><br>

Kemudian sudah bisa kita tambahkan IP address untuk interface bridge1 nya.<br> <img src="/notes/image/034-config-vlan.png"><br>

## Mode Tagged

<img src="/notes/image/035-config-vlan.png"><br>

Konfigurasi pada router<br> <img src="/notes/image/036-config-vlan.png"><br> <!-- no 37 dlam img drive -->
Seperti kasus pertama, pada router membuat interface vlan management dan berikan ip address pada vlan tersebut.

Konfigurasi pada switch<br> <img src="/notes/image/037-config-vlan.png"><br> <!-- no 38 dlam img drive --> <img src="/notes/image/038-config-vlan.png"><br> <!-- no 39 dlam img drive -->

Tambahkan konfigurasi Ingress VLAN<br> <img src="/notes/image/039-config-vlan.png"><br> <!-- no 40 dlam img drive -->

Kemudian tambahkan konfigurasi Egress VLAN. Pada vlan id 99 tambahkan juga switch1-cpu untuk Tagged Ports nya.<br> <img src="/notes/image/040-config-vlan.png"><br> <img src="/notes/image/041-config-vlan.png"><br> <img src="/notes/image/042-config-vlan.png"><br>

Selanjutnya tambahkan konfigurasi Switch VLAN, pada vlan management yaitu vlan 99 tambahkan switch1-cpu untuk port nya.<br> <img src="/notes/image/043-config-vlan.png"><br> <img src="/notes/image/044-config-vlan.png"><br> <img src="/notes/image/045-config-vlan.png"><br>

Setelah itu kita bisa buat interface vlan baru dengan vlan id 99 dan interface bridge yang kita buat di awal tadi.<br> <img src="/notes/image/046-config-vlan.png"><br>

Terakhir, kita konfigurasi pada menu switch → settings dan set untuk Drop If Invalid VLAN On Ports ether24 (trunk), ether1 (access), dan ether2 (access).

Kita sudah bisa menambahkan IP address pada interface vlan99 yang kita buat tadi dan vlan management sudah bisa digunakan.<br> <img src="/notes/image/047-config-vlan.png"><br>

## Konfigurasi VLAN Management pada CSS (Switch OS)

Karena seri CSS menggunakan Switch OS, maka bisa kita konfigurasi melalui web browser. Memang untuk tampilan nya lebih simpel dari pada CRS yang menggunakan Router OS.

Untuk topologi yang kita gunakan masih sama.<br> <img src="/notes/image/048-config-vlan.png"><br> <img src="/notes/image/049-config-vlan.png"><br> <img src="/notes/image/050-config-vlan.png"><br>

Pertama, kita konfigurasikan terlebih dahulu untuk port yang menjadi trunk dan access. Untuk contoh kali ini kita menggunakan port 1 untuk trunk, port 2 untuk access vlan 11, dan port 3 untuk access vlan 13.<br>

<img src="/notes/image/051-config-vlan.png"><br>
Kemudian untuk membuat vlan management bisa kita atur di menu System.
Tentukan "IP Address" dan "Allow From VLAN" kemudian klik apply.
Tunggu sesaat dan seharusnya switch sudah bisa di akses. Selamat mencoba :D .

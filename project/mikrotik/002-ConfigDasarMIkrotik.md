Langkah Setting Dasar MikroTik dengan winbox khusus untuk pemula, lengkap dengan gambar dan script.
Begini Cara Setting MikroTik di RB750, RB750r2, RB750Gr3, RB450G, RB951G, RB941, hAP Lite dan semua type RouterBoard dari awal sampai terhubung ke internet.
Tutorial MikroTik ini bisa di terapkan untuk Hotspot, Warnet, RT RW NET, dan Jaringan lain nya yang skala kecil menengah.
JIka anda baru membeli produk mikrotik dan masih belum mengerti cara konfigurasi MikroTik dari awal…

Berikut ini langkah langkah konfigurasi MikroTik yang perlu anda perhatikan…

# SETTING DASAR MIKROTIK
Secara default semua MikroTik RouterBoard sudah ada konfigurasi yang siap di pakai tanpa harus di setting terlebih dulu.
Tetapi konfigurasi bawaan mikrotik kadang tidak sesuai dengan apa yang sudah direncanakan dari awal.
Sehingga kita perlu melakukan reset terlebih dulu mikrotik RouterOS nya atau bisa juga menghapus setingan standar mikrotik bawaannya.
Berikut urutan seting mikrotik dasar yang perlu anda perhatikan sebagai pembelajaran awal konfigurasi mikrotik.
Netme akan memberikan contoh Langkah Setting MikroTik dasar dengan Modem Indihome, atau dengan ISP lain nya, menggunakan RB750 atau RouterBoard lain nya.

## 1. TOPOLOGI JARINGAN
Langkah pertama yang perlu anda ketahui ialah menentukan Topologi Jaringan sebelum mulai konfigurasi mikrotik.

Buatlah desain topologi jaringan sesuai dengan kondisi dan rencana yang sudah di rencanakan.
<img src="https://drive.google.com/uc?export=view&id=154YOmLOyIGHe4-GexgbFc8XA4WyspQib"/>
Contoh Topologi Jaringan
Keterangan contoh topologi diatas :
<li>MikroTik Port Internet / Ether1 terhubung ke Modem indihome</li>
<li>Mikrotik ether2 terhubung ke HUB untuk dilanjutkan ke beberapa Komputer</li>
<li>MikroTik ether3 terhubung ke Accest Point untuk Wifi</li>
<li>Mikrotik ether4 dan ether5 tidak dipakai</li>

Topologi Jaringan MikroTik gambar di atas ialah hanya contoh, tetapi topologi di atas hampir sama dengan jaringan Warnet, Hotspot, RT RW NET, kantor dan lain sebagainya.

Untuk itu silahkan buat topologi jaringan sesuai dengan kondisi di tempat.
Karena dengan adanya topologi kita jadi mudah untuk seting mikrotik dan trobleshoting jaringan yang akan di bangun.

## 2. IP ADDRESS
IP Address ialah sebuah alamat identitas yang terdiri dari angka biner antara 32 bit sampai 128 bit untuk tiap perangkat host pada jaringan.
Memberi IP address tiap perangkat hukumnya wajib jika ingin terhubung ke internet bahkan terhubung hanya secara lokal.
IP Address sama hal nya seperti alamat rumah yang perlu kita ketahui jika ingin berkunjung atau kirim surat ke alamat rumah tersebut.

Setelah menentukan topologi jaringan mikrotik yang akan dibangun, maka langkah selanjutnya ialah setting IP Address MikroTik agar terhubung ke internet dan MikroTik sebagai gateway pada beberapa komputer dan perangkat lain nya.

Pada gambar di atas, bahwa Internet yang bersumber dari modem ISP hendak di share ke beberapa perangkat dan MikroTik menjadi router sekaligus firewall dan gateway dari semua perangkat yang terhubung.

Berikut cara setting dasar mikrotik pemberian IP address menggunakan Winbox untuk akses ke dalam MikroTik routerOS.

Oh iya….

Pastikan semua perangkat modem, mikrotik, dan komputer sudah di hubungkan sesuai dengan topologi diatas. Dan setingan mikrotik masih default, NetMe anggap masih bawaan atau belum pernah di setting.

Jika belum punya Winbox, silahkan download terlebih dulu.

Buka Winbox dan login MikroTik menggunakan Mac-Address :

Default login mikrotik

<pre>user: admin
password: [tanpa password]</pre>
<center><img src="https://drive.google.com/uc?export=view&id=14Wf5o_Mv6NncfNOvY5shF4Io-WHVt3RV"></center>
Login ke MikroTik dengan Mac address
Setelah mac address sudah muncul, klik mac address tersebut dan isi kolom login menggunakan user: admin tanpa password.

Kemudian Klik Connect….

Jika berhasil login maka tampilan MikroTik di winbox seperti berikut :

<center><img src="https://drive.google.com/uc?export=view&id=1TYn4m0n87Z6_qcmrOjTRUctwLiONay-C"></center>
Default Konfigurasi MikroTik RouterOs
Silahkan klik [Remove Configuration] untuk reset mikrotik agar semua setingan bawaan mikrotik terhapus.

Atau bisa melakukan reset mikrotik manual dengan perintah :
<pre>/system reset-configuration no-defaults=yes</pre>
Buka new terminal dari menu samping Winbox, kemudian copy lalu pasti script diatas.

Jika keluar peringatan : Dangerous! Reset anyway? [y/N]: …..

Silahkan ketik Huruf ‘Y‘ kemudian [enter]….

Tunggu beberapa detik sampai MikroTik selesai restart…

Silahkan login kembali ke MikroTik dengan winbox seperti diatas.

Setting IP address mikrotik pada setiap ether sesuai dengan Topologi diatas

IP address anggaplah sebagai berikut, silahkan sesuaikan dengan IP yang sudah ditentukan:

<li>IP modem Indihome 192.168.100.1</li>
<li>ether1 – seting IP otomatis ( dhcp client ) dari modem indihome atau IP manual 192.168.100.2/24</li>
<li>ether2 – IP manual 192.168.2.1/24</li>
<li>>ether3 – IP manual 192.168.3.1/24</li>
<center><img src="https://drive.google.com/uc?export=view&id=1bGCgtkmb6GA1nJpjVHbQ795VX-dx_iY8"></center>
Setting IP address di mikrotik
Berikan IP address ke ether2 dan ether3 sama seperti gambar di atas, dan sesuaikan IP address nya.
Jika IP address sudah di setting ke semua ether dan sudah sesuai dengan topologi, maka ke langkah seting mikrotik dasar selanjutnya.

## 3. Gateway Internet MikroTik
Agar semua perangkat komputer, handphone dan lainnya yang terhubung ke mikrotik bisa Internetan, maka mikrotik sebagai router harus mempunyai default gateway ke public.

Modem ISP indihome yang terpasang dan dihubungkan ke mikrotik lewat port ether1 sebagai jalur koneksi ke internet.
Melihat topologi diatas maka default gateway ke internet menggunakan IP dari isp indihome yaitu 192.168.100.1.
Copy script dibawah ini kemudian paste ke new terminal winbox untuk menambahkan default gateway :

<pre>/ip route add gateway=192.168.100.1 distance=1 dst-address=0.0.0.0/0</pre>

Atau bisa menambahkan default gateway secara manual seperti ini:
<center><img src="https://drive.google.com/uc?export=view&id=1jh6yJDYRqEn2S4aAPEf7UFt6t4pE8swa"></center>

Default gateway MikroTIk
Sampai disini seharusnya mikrotik sudah bisa Ping ke IP public seperti : 8.8.8.8.

Jika masih timeout silahkan anda cek kembali IP modem dan IP di mikrotiknya, pastikan sesuai.

Tambahkan DNS dan aktifkan DNS server di mikrotik, agar bisa akses domain di internet.

<pre>/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4</pre>
Copy script diatas kemudian paste kedalam new terminal winbox.

Atau setting dns di mikrotik lewat manual :

<center><img src="https://drive.google.com/uc?export=view&id=1zvjp_1WVebVrUSeDuZFA46AUB1m_WZIF"></center>
setting dns di mikrotik

## 4. NAT – Network Address Translation
Fungsi NAT ini ialah proses pemetaan alamat IP. NAT mentranslasikan alamat IP private untuk dapat mengakses alamat host di internat dengan menggunakan alamat IP public.
Sehingga Semua perangkat bisa akses ke internet melalui MikroTik router. 
Berikut script nya, silahkan copy kemudian paste ke new terminal winbox:

<pre>/ip firewall nat add chain=srcnat action=masquerade</pre>
Itulah 4 Langkah cara setting dasar mikrotik dengan winbox dan script.

Dengan Konfigurasi mikrotik dasar seperti ini, semua perangkat yang terhubung ke mikrotik sudah bisa akses ke internet. Agar komputer bisa akses ke internet silahkan isi IP address dan gatewaynya mengarah ke mikrotik secara manual di komputer local area network.
Atau…
Bisa mengaktifkan dhcp server di mikrotik sehingga semua perangkat otomatis mendapatkan IP dari mikrotik.

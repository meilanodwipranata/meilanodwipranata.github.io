# Dynamic Routing Menggunakan Router Mikrotik                                                                         




# Topologi
![](https://edosyam.wordpress.com/wp-content/uploads/2016/09/1.png?w=422)

Dynamic Routing Menggunakan Router Mikrotik
===========================================


### Dynamic Routing – Praktikum 2 Manajemen Jaringan

### Tujuan

Adapun tujuan dari praktikum adalah agar mahasiswa dapat :  
\-Mahasiswa mampu menganalisa bagaimana cara kerja dynamic routing pada router mikrotik  
\-Mahasiswa dapat melakukan konfigurasi routing dynamic pada router mikrotik.  
\-Mahasiswa dapat menjelaskan perbedaan antara routing dynamic RIP dan OSPF.

**Topologi Jaringan  
**

![1](https://edosyam.wordpress.com/wp-content/uploads/2016/09/1.png?w=300&h=202)

**Dasar Teori**

Dinamik routing adalah sebuah teknik routing dimana jalur koneksi ditentukan otomatis oleh perangkat router itu sendiri. Dimana pada static routing jalur koneksi atau alur data di tentukan oleh admistrator jaringan sedangkan pada dinamik routing administrator hanya memasukkan network ( jaringan ) mana yang terhubung pada router tersebut.

Pada dinamik routing terdapat banyak protokol konfigurasinya, dimana pada percobaan ini dilakukan konfigurasi menggunakan dua buah protokol dinamik routing yaitu OSPF dan RIP.

OSPF adalah suatu protokol pada dynamic routing yang mampu mengatur konfigurasi routing dimana OSPF dapat mengikuti perubahan jaringan dalam skala kecil maupun skala besar.Dimana pada ospf masing masing router akan mencari jalan tercepat atau terpendek untuk mencapai network tujuan. Kebanyakan OSPF digunakan untuk memanajemen jaringan dalam skala besar.

RIP adalah sebuah protokol dyanamic routing yang menggunakan sebuah algoritman bernama Distance Vector dimana maksudnya adalah setiap router akan memberikan informasi tabel jaringan ( informasi jaringan yang di tangani router) secara kontinyu setiap waktu tertentu terhadap router-router tetangganya.

**Langkah Percobaan**

*   Hubungkan PC dengan Router yang akan kita konfigurasi dengan menggunakan kabel UTP
*   Lakukan Konfigurasi IP pada PC yang kita gunakan dengan memasukkan alamat ipnya adalah 192.168.11.254/24 dan gatewaynya arahkan ke IP Router Mikrotik dimana saya akan menggunakan IP 192.168.11.1/24 sebagai ipnya.
*   Matikan Firewall pada PC
*   Buka winbox dan lanjutkan dengan mengkonfigurasi IP pada mikrotik, Gunakan Eth2 sebagai Interface yang akan ber-interaksi langsung dengan PC Client.

*   Setelah melakukan konfigurasi IP untuk PC Client, lanjutkan dengan memasangkan IP ke interface Eth3 yang akan terhubung langsung dengan router tetangga. Gunakan IP 200.200.200.2/24.
 ![2](https://edosyam.wordpress.com/wp-content/uploads/2016/10/2.png?w=640)

*   Setelah melakukan konfigurasi IP selanjutnya adalah melakukan konfigurasi Dinamik routing dengan menggunakan protokol OSPF.

**Langkah Routing Ospf**

*   Untuk melakukan konfigurasi OSPF adalah dengan masuk ke menu OSPF yang terdapat pada Routing – Ospf. Maka akan tampil display seperti dibawah ini 
![3](https://edosyam.wordpress.com/wp-content/uploads/2016/10/3.png?w=439&h=281)

*   Untuk melakukan konfigurasi pada OSPF adalah dengan memasukkan 2 network tetangga, dimana networknya adalah 192.168.11.0/24 dan 200.200.200.0/24 maka masukkan kedua buah network tersebut. Klik pada tab network lalu klik icon “+” masukkan kedua network tersebut.
![4.PNG](https://edosyam.wordpress.com/wp-content/uploads/2016/10/4.png?w=640)

*   Tunggu beberapa saat, maka Router akan mengupdate Routing secara otomatis. Lakukan juga hal tersebut pada Router Kedua agar router sama sama meng-update Routing Tablenya.
*   Coba lakukan Ping Antara PC 1 dan PC 2 Jika berhasil maka anda telah berhasil melakukan routing menggunakan protokol OSPF

Langkah Routing RIP

*   Untuk melakukan Routing menggunakan Protokol RIP masuk pada menu RIP di Routing – RIP.
*   Masukkan Interface yang akan kita gunakan untuk melakukan Dynamic Routing pilih saja ALL agar semua interface masuk kedalam list routing RIP. 
![6.PNG](https://edosyam.wordpress.com/wp-content/uploads/2016/10/6.png?w=640)

*   Lalu masukkan network yang akan kita hubungkan menggunakan Routing RIP, masuk ke tab network,lakukan penambahan network dengan cara klik pada ikon “+” pada tab network dilanjutkan dengan memasukkan dua network yang ingin kita hubungkan.
![7.PNG](https://edosyam.wordpress.com/wp-content/uploads/2016/10/7.png?w=640)

*   Lakukan konfigurasi yang sama pada router 2. Tunggu beberapa saat maka router akan melakukan update routing table. Lakukan PING antar PC client, jika berhasil maka anda terlah berhasil melakukan Dynamic Routing Menggunakan Router Mikrotik.
*   Percobaan selesai.

**Hasil**

![8](https://edosyam.wordpress.com/wp-content/uploads/2016/10/8.png?w=300&h=153)

Kedua pc dapat melakukan ping, yang berarti kedua pc telah tersambung satu sama lain.

**Analisa**

Pada praktikum ini dilakukan konfigurasi dinamik routing menggunakan dua buah protokol dinamic routing yaitu dynamic routing menggunakan OSPF dan juga menggunakan RIP. Dimana dapat dilihat bahwa OSPF adalah dynamic routing yang lebih baru dan unggul daripada Dynamic routing RIP. Hal ini dikarenakan Protokol OSPF lebih baru daripada protokol RIP. Dimana protokol OSPF dapat mengikuti perubahan jaringan secara dinamis, OSPF dapat digunakan pada skala jaringan yang besar, sedangkan RIP biasanya hanya di gunakan untuk jaringan lokal. Pada RIP update Routing Table dilakukan pada jeda waktu tertentu sehingga tidak sedinamis protokol OSPF. Protokol RIP harus mendefenisikan Interface mana yang akan di pakai sebelum memasukkan network – network yang akan saling terkoneksi.

**Kesimpulan**

Pada praktikum ini didapat kesimpulan sebagai berikut :  
1.Dynamic routing digunakan untuk jaringan yang dinamis.  
2.OSPF merupakan protokol dynamic routing yang lebih unggul daripada RIP.


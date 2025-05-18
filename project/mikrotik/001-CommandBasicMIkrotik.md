# MikroTik RouterOS 
Adalah sistem operasi berbasis kernel Linux. MikroTik RouterOS dapat diinstal pada perangkat keras seri RouterBOARD, atau pada komputer berbasis standar x86, komputer tersebut dijadikan sebagai router jaringan dan menerapkan berbagai fitur tambahan, seperti layanan berbagai jenis firewall, virtual private network (VPN), Administrasi MikroTik RouterOS dapat dilakukan menggunakan perangkat lunak berbasis GUI atau console, berikut adalah perintah dasar MikroTik yang umumnya dijalankan pada console berbasis CLI (Command Line Interface).

## 1. ip address add
Perintah “IP Address Add” di gunakan untuk menambahkan atau mengatur IP Address pada suatu NIC (Network Interface Card), caranya cukup ketikkan perintah “ip address add” kemudian di ikuti dengan IP Address yang akan di set misalnya ” address=10.10.10.1/24″ kemudian di ikuti dengan nama NIC misalnya “interface=ether1”.

<pre>[DosenIT@MikroTik] > ip address add address=10.10.10.1/24 interface=ether1</pre>
Catatan : Anda harus tahu betul nama interface yang IP Address-nya ingin Anda atur, nama interface sebenarnya dapat di ubah dengan perintah tertentu untuk memudahkan pengguna dalam mengenali tiap-tiap port NIC (Network Interface Card), perintah tersebut akan kita bahas di bagian selanjutnya.

## 2. ip address print
Perintah “IP Address Print” digunakan untuk melihat IP address pada masing-masing NIC (Network Interface Card), caranya cukup ketikkan perintah “ip address print” pada console kemudian tekan Enter.

<pre>[DosenIT@MikroTik] > ip address print
Flags: X - disabled, I - invalid, D - dynamic
 # ADDRESS        NETWORK     BROADCAST     INTERFACE
 0 2.2.2.1/24     2.2.2.0     2.2.2.255     ether2
 1 10.5.7.244/24  10.5.7.0    10.5.7.255    ether1
 2 10.10.10.1/24  10.10.10.0  10.10.10.255  ether2</pre>
Kolom address berisi alamat IP Address, jika belum di atur maka kolom tersebut kosong, kolom network berisi IP Address untuk jaringan, parameter ini hanya bisa di konfigurasi untuk alamat dengan /32 netmask (point to point links), kolom broadcast berisi IP Address broadcasting yang di hitung dari IP Address dan Network Mask, kolom interface berisi nama antarmuka IP Address yang telah ditetapkan.

## 3. ip dns set
Perintah “IP DNS Set” di gunakan untuk menetapkan IP Address tertentu sebagai server DNS (Domain Name System) dan membuat RouterBoard atau komputer dengan MikroTik RouterOS memiliki fungsi komputer server, caranya cukup ketikkan perintah “ip dns set” kemudian di ikuti dengan IP Address yang akan di set misalnya ” servers=159.148.60.3″ kemudian di ikuti dengan “allow-remote-requests=yes” untuk mengijinkan request jaringan.

<pre>[DosenIT@MikroTik] > ip dns set servers=159.148.60.3 allow-remote-requests=yes</pre>

## 4. ip dns print
Anda dapat mengetikkan perintah “ip dns print” untuk melihat rincian status server DNS dari IP Address yang telah di tetakan diatas.

<pre>[DosenIT@MikroTik] > ip dns print
               servers: 159.148.60.3
 allow-remote-requests: yes
            cache-size: 2048KiB
         cache-max-ttl: 1w
            cache-used: 7KiB</pre>
Baris servers berisi daftar IP DNS yang telah di tetapkan baik IPv4 atau IPv6 (secara default bernilai 0.0.0.0), untuk IP DNS yang berisi lebih dari satu (contoh di atas hanya satu IP Address saja), masing-masing IP Address di pisahkan dengan tanda koma, baris allow-remote-requests merupakan pengaturan untuk mengijinkan (yes) atau menolak (no) request dari jaringan (secara default bernilai “no”).

Baris cache-size berisi ukuran cache DNS dalam satuan KiB (Kilo Bytes) mulai dari 512 KiB hingga maksimal 10240 KiB (10 MB, Mega Bytes) secara default bernilai 2048 KiB (2 MB, Mega Bytes). Baris cache-max-ttl berisi waktu maksimum “time-to-live” (waktu hidup) dari cache, secara default bernilai 1w (1 week atau 1 minggu), setelah lewat masa TTL maka cache akan kedaluarsa. baris cache-used menampilkan ukuran cache yang saat ini di gunakan dalam KiB (Kilo Bytes).

## 5. ip firewall address-list add
Perintah  “ip firewall address-list add” memungkinkan pengguna membuat daftar alamat IP yang dikelompokkan bersama dengan nama yang umum. Dengan begitu filter firewall, mangle dan fasilitas NAT kemudian dapat menggunakan daftar alamat tersebut untuk mencocokkan paket dengan paket pada alamat dalam daftar.

Untuk membuat daftar alamat IP, caranya cukup ketikkan perintah “ip firewall address-list add” kemudian di ikuti dengan IP Address yang akan di tambahkan misalnya “address=192.0.34.166/32” kemudian di ikuti dengan nama list yang di buat misalnya “list=situs_diblokir”.

<pre> [DosenIT@MikroTik] > ip firewall address-list add list=situs_diblokir address=192.0.34.166/32</pre>

## 6. ip firewall address-list print
Jika Anda telah membuat suatu daftar alamat (address list) dan menambahkan IP Address ke dalam daftar tersebut seperti pada langkah di atas, Anda dapat melihat daftar IP Address pada daftar alamat tersebut (dan pada daftar alamat lain jika ada), caranya cukup ketikkan perintah “ip firewall address-list print” pada console kemudian tekan Enter.

<pre>[DosenIT@MikroTik] > ip firewall address-list print
Flags: X - disabled, D - dynamic
# LIST           ADDRESS
0 situs_diblokir 192.0.34.166</pre>

## 7. system backup save
Perintah “System Backup Save” di gunakan untuk mem-backup (mencadangkan) konfigurasi pada perangkat router, artinya segala konfigurasi yang telah di tetapkan (di atur) oleh pengguna akan di cadangkan ke dalam suatu file, cara mem-backup konfigurasi router via console adalah dengan mengetikkan perintah “system backup save” di ikuti dengan nama file backup yang ingin di simpan misalnya “name=cadangan-1” kemudian tekan Enter.

<pre>[DosenIT@MikroTik] > system backup save name=cadangan-1</pre>
Configuration backup saved
Dengan perintah di atas, maka konfigurasi akan tersimpan pada disk drive berupa file bernama “cadangan-1” (dengan ekstensi “.backup”).

## 8. system backup load
Perintah “System Backup Load” di gunakan mengembalikan pengaturan yang tersimpan, ketik perintah “system backup load” pada console di ikuti dengan nama file backup yang ingin di restore misalnya “name=cadangan-1” kemudian tekan Enter. Untuk dapat menerapkan konfigurasi yang di kembalikan (restore), router akan melakukan reboot secara otomatis.

<pre>[DosenIT@MikroTik] > system backup load name=cadangan-1 
Restore and reboot? [y/N]: y
Restoring system configuration
System configuration restored, rebooting now</pre>

## 9. system reset-configuration
Perintah “System Reset-Configuration” di gunakan untuk me-reset (mengatur ulang) perangkat router ke pengaturan default, perintah ini di anggap “berbahaya” karena mungkin akan mengembalikan pengaturan default sepenuhnya, artinya segala konfigurasi yang telah di tetapkan (di atur) oleh pengguna akan di hapus, cara me-reset router via console adalah dengan mengetikkan perintah “system reset-configuration” pada console kemudian tekan Enter.

<pre>[DosenIT@MikroTik] > system reset-configuration
Dangerous! Reset anyway? [y/N]:</pre>

## 10. system shutdown
Perintah “System Shutdown” di gunakan untuk mematikan perangkat router, perlu di ingat bahwa setelah di shutdown router biasanya perlu di nyalakan secara manual, cara mematikan router via console adalah dengan mengetikkan perintah “system shutdown” pada console kemudian tekan Enter.

<pre>[DosenIT@MikroTik] > system shutdown</pre>

## 11. system reboot
Perintah “System Reboot” di gunakan untuk me-reboot atau me-restart perangkat router, cara me-reboot router via console adalah dengan mengetikkan perintah “system reboot” pada console kemudian tekan Enter.

<pre>[DosenIT@MikroTik] > system reboot</pre>

## 12. ip accounting
Perintah IP Accounting di gunakan untuk manajemen pengguna jaringan point-to-point atau peer-to-peer, pengguna hotspot, dan lalu lintas pengguna. Untuk mengaktifkan fitur IP Accounting, ketik perintah berikut pada console:

<pre>[DosenIT@MikroTik]>ip accounting set enabled=yes</pre>

## 13. ip cloud set ddns-enabled = yes | no
MikroTik menawarkan layanan Dynamic DNS (DDNS) untuk perangkat RouterBOARD. Ini berarti perangkat Anda dapat secara otomatis mendapatkan nama domain dengan fungsi DNS yang berguna jika IP Address Anda sering berubah, dengan begitu Anda dapat dengan mudah menyambung ke router Anda. Ketik perintah di bawah ini untuk mengaktifkan layanan DDNS.

<pre>[DosenIT@MikroTik]> ip cloud set ddns-enabled=yes</pre>

## 14. ip cloud set update-time = yes | no
Perintah “ip cloud set update-time” di gunakan untuk menyetel jam pada router. Jika disetel ke “yes” maka jam router akan disetel ke waktu yang disediakan oleh server cloud jika tidak ada layanan SNTP atau NTP yang diaktifkan. Jika disetel ke “no” maka layanan cloud tidak akan pernah memperbarui jam router. Jika update-time = yes, jam router akan diupdate bahkan ketika status ip cloud ddns-enabled = no.

<pre>[DosenIT@MikroTik]> ip cloud set update-time = yes</pre>

## 15. ip cloud print
Perintah “ip cloud print” di gunakan untuk menampilkan status layanan “ip cloud” seperti status DDNS, IP Address Publik, Nama Domain dan lain sebagainya, ketik perintah di bawah ini untuk menampilkan status layanan “ip cloud”, berikut adalah contoh informasi yang di tampilkan.

<pre>[DosenIT@MikroTik]> ip cloud print
   ddns-enabled: yes
    update-time: yes
 public-address: 159.148.172.205
       dns-name: 529c0491d41c.sn.dosenit.com
         status: updated</pre>

## 16. ip hotspot setup
Cara termudah untuk men-setup server HotSpot di router adalah dengan perintah “ip hotspot setup”. Router akan meminta Anda untuk memasukkan parameter yang di butuhkan dalam pengaturan HotSpot. Setelah selesai, konfigurasi default akan di tambahkan ke server HotSpot.

<pre>[DosenIT@MikroTik] > ip hotspot setup 
Select interface to run HotSpot on
hotspot interface: ether3

Set HotSpot address for interface
local address of network: 10.5.50.1/24

masquerade network: yes

Set pool for HotSpot addresses
address pool of network: 10.5.50.2-10.5.50.254

Select hotspot SSL certificate
select certificate: none

Select SMTP server
ip address of smtp server: 0.0.0.0

Setup DNS configuration
dns servers: 10.1.101.1

DNS name of local hotspot server
dns name: myhotspot

Create local hotspot user
name of local hotspot user: dosenit

password for the user:</pre>

## 17. ip proxy set enabled = yes | no
MikroTik RouterOS dapat membatasi permintaan HTTP dan HTTP (untuk FTP dan HTTP) dengan fungsi proxy pada jaringan komputer. Proxy server melakukan fungsi cache objek Internet dengan menyimpan objek Internet yang diminta, yaitu data yang tersedia melalui protokol HTTP dan FTP pada sistem yang diposisikan lebih dekat ke penerima dalam bentuk mempercepat browsing pengguna dengan mengirimkan salinan file yang di minta dari cache proxy di jaringan lokal.

<pre>[admin@MikroTik] ip proxy> set enabled=yes port=8080 src-address=195.10.10.1</pre>

## 18. ip proxy print
Perintah “ip proxy print” digunakan untuk menampilkan status proxy.

<pre>[DosenIT@MikroTik] ip proxy> print
                    enabled: yes
                src-address: 195.10.10.1
                       port: 8080
               parent-proxy: 0.0.0.0:0
                cache-drive: system
        cache-administrator: "admin@dosenit.com"
        max-disk-cache-size: none
         max-ram-cache-size: 100000KiB
         cache-only-on-disk: yes
 maximal-client-connections: 1000
 maximal-server-connections: 1000
             max-fresh-time: 3d</pre>
             
## 19. ip firewall nat add
RouterOS juga dapat bertindak sebagai server Transparan Caching, tanpa konfigurasi di web browser pengguna (pelanggan). Proxy transparan tidak mengubah URL atau respons yang diminta. Untuk mengaktifkan mode transparan, aturan firewall di NAT tujuan harus ditambahkan, dengan menentukan koneksi mana (ke port mana) yang harus dialihkan secara transparan ke proxy. Misalnya redirect pengguna dengan IP Address berikut 192.168.1.0/24 ke server proxy.

<pre>[DosenIT@MikroTik] ip firewall nat> add chain=dstnat protocol=tcp src-address=192.168.1.0/24 dst-port=80 action=redirect to-ports=8080</pre>

## 20. ip firewall nat print
Perintah “ip firewall nat print” digunakan untuk menampilkan status NAT pada Firewall

<pre>[DosenIT@MikroTik] > ip firewall nat print
 Flags: X - disabled, I - invalid, D - dynamic
 0 chain=dstnat protocol=tcp dst-port=80 action=redirect to-ports=8080</pre>
 
## 21. ip proxy access add action = allow | deny
<pre>[DosenIT@MikroTik] > ip proxy access add action=deny dst-host=www.facebook.com</pre>
Perintah di atas di gunakan untuk memblokir situs Facebook (facebook.com) secara total, artinya semua pengguna yang terhubung ke jaringan Anda tidak dapat mengakses situs tersebut.

## 22. ip proxy access add action = allow | deny (with src-address)
<pre>[DosenIT@MikroTik] > ip proxy access add src-address=192.168.1.0/24 dst-host=www.facebook.com action=deny</pre>
Perintah di atas di gunakan untuk mencegah pengguna yang berada pada blok/segmen IP Address  192.168.1.0/24 untuk mengakses situs Facebook (facebook.com) , artinya semua pengguna yang terhubung ke jaringan Anda tidak dapat mengakses situs tersebut.

## 23. ip service set api
Perintah “ip service set api” digunakan untuk menambahkan protokol dan port untuk berbagai layanan MikroTik RouterOS. Perintah ini membantu Anda untuk menentukan port mana yang di-listen oleh MikroTik dan apa saja yang Anda butuhkan untuk mencegah atau memberikan akses ke layanan tertentu.

<pre>[DosenIT@MikroTik] > ip service set api address=10.5.101.0/24,2001:db8:fade::/64</pre>
Perintah diatas digunakan untuk menambahkan “api” yang bekerja dari IP Address “10.5.101.0/24” dan sertifikat “2001:db8:fade::/64”.

## 24. ip service print
Perintah “ip service print” di gunakan untuk  menampilkan detail service yang berjalan pada sistem saat ini.

<pre>[DosenIT@MikroTik] > ip service print 
Flags: X - disabled, I - invalid 
#   NAME     PORT   ADDRESS         CERTIFICATE 
0   telnet   23 
1   ftp      21 
2   www      80 
3   ssh      22 
4 X www-ssl  443                    none 
5   api      8728   10.5.101.0/24   2001:db8:fade::/64 
6   winbox   8291</pre>

## 25. ip upnp set enable = yes | no
MikroTik RouterOS mendukung arsitektur Universal Plug and Play (UPnP) untuk konektivitas jaringan peer-to-peer yang transparan dari komputer pribadi dan smart devices atau peralatan jaringan lainnya. Protokol UPnP digunakan pada banyak aplikasi modern, seperti game DirectX dan berbagai fitur Windows Messenger (remote asisstance, application sharing, transfer file, voice, video) dari balik firewall. Untuk mengaktifkan fitur UPnP, ketik perintah berikut :

<pre>[DosenIT@MikroTik] > ip upnp set enable=yes</pre>

## 26. ip upnp print
Untuk menampilkan status layanan Universal Plug and Play (UPnP), ketik perintah berikut :

<pre>[DosenIT@MikroTik] > ip upnp print
                           enabled: yes
  allow-disable-external-interface: yes
                   show-dummy-rule: yes</pre>
                   
## 27. ip upnp interfaces add type = external | internal
Perintah “ip upnp interfaces add” di gunakan untuk menambahkan suatu interface sebagai UPnP, Anda dapat menambahkan interface “internal” dan interface “external” sebagai UPnP.

<pre>[DosenIT@MikroTik] > ip upnp interfaces add type=external interface=ether1
[DosenIT@MikroTik] > ip upnp interfaces add type=internal interface=ether2</pre>

## 28. ip upnp interfaces print
Perintah “ip upnp interfaces print” di gunakan untuk menampilkan status interface UPnP, misalnya hasil dari perintah “ip upnp interfaces add” di atas akan menghasilkan tampilan seperti di bawah ini.

<pre>[DosenIT@MikroTik] > ip upnp interfaces print
Flags: X - disabled
 #   INTERFACE  TYPE
 0 X ether1     external
 1 X ether2     internal</pre>
 
## 29. ip upnp interfaces enable
Jika Anda perhatikan “flag” pada kedua interface diatas berstatus “disabled” (ditandai “X”), untuk menjadikannya tersedia (“enable”), gunakan perintah berikut :

<pre> [DosenIT@MikroTik] > ip upnp interfaces enable 0,1</pre>

## 30. routing bfd neighbor print detail
Perintah “routing bfd neighbor print detail” digunakan untuk menampilkan status layanan BFD, Bidirectional Forwarding Detection (BFD) adalah protokol dengan overhead rendah dan durasi pendek yang dimaksudkan untuk mendeteksi kesalahan pada jalur dua arah di antara dua forwarder engine. Paket BFD Control ditransmisikan dalam paket UDP dengan port tujuan 3784. Port sumber berada pada kisaran 49152 sampai 65535. Dan paket BFD Echo dienkapsulasi dalam paket UDP dengan port tujuan 3785.

<pre>[DosenIT@MikroTik] > routing bfd neighbor print detail 
Flags: U - up 
0 U state=up address=10.5.101.1 interface=ether1 protocols=ospf multihop=no 
    state-changes=1 uptime=12s desired-tx-interval=0.2sec 
    actual-tx-interval=0.2sec required-min-rx=0.2sec remote-min-rx=0.2sec 
    multiplier=5 hold-time=1sec packets-rx=76 packets-tx=77</pre>
    
## 31. routing igmp-proxy interface add
Perintah “routing igmp-proxy interface add” merupakan perintah untuk menambahkan interface ke IGMP Proxy. Internet Group Management Protocol (IGMP) Proxy digunakan untuk mengimplementasikan routing multicast. IGMP adalah penerusan frame IGMP dan biasanya digunakan bila tidak diperlukan protokol yang lebih maju seperti PIM.

<pre>[DosenIT@MikroTik] /routing igmp-proxy> interface add interface=ether1 upstream=yes
[DosenIT@MikroTik] /routing igmp-proxy> interface add interface=all</pre>

## 32. routing igmp-proxy interface print
Perintah “routing igmp-proxy interface print” digunakan untuk menampilkan interface yang di gunakan pada IGMP Proxy.

<pre>[DosenIT@MikroTik] > routing igmp-proxy interface print
Flags: X - disabled, I - inactive, D - dynamic, U - upstream
 #   INTERFACE   THRESHOLD
 0 U ether1      1
 1   all         1
 2 D ether2      1
 3 D ether3      1</pre>
 
## 33. routing igmp-proxy interface set
Perintah “routing igmp-proxy interface set” digunakan untuk mengkonfigurasi alternative-subnet pada antarmuka upstream jika alamat pengirim multicast ada dalam subnet IP yang tidak dapat dijangkau secara langsung dari router lokal.

<pre>[DosenIT@MikroTik] /routing igmp-proxy> interface set [find upstream=yes] alternative-subnets=1.2.3.0/24,2.3.4.0/24</pre>

## 34. routing ospf instance
Protokol OSPF adalah protokol link-state yang menangani rute dalam struktur jaringan dinamis yang dapat menggunakan jalur yang berbeda ke subnetworknya. OSPF selalu memilih jalur terpendek ke subnetwork terlebih dahulu.

<pre>[DosenIT@MikroTik] > routing ospf instance</pre>

## 35. routing ospf monitor
Perintah “routing ospf monitor” digunakan untuk menampilkan status OSPF

<pre>[DosenIT@MikroTik] > routing ospf monitor</pre>

## 36. routing ospf instance print status
Perintah “routing ospf instance print status” di gunakan untuk menampilkan status OSPF, hampir sama dengan “routing ospf monitor” hanya saja perintah informasi yang ditampilkan dengan perintah “routing ospf instance print status” lebih detail.

<pre>[DosenIT@MikroTik] > routing ospf instance print status</pre>

## 37. routing ospf area
Perintah “routing ospf area” digunakan untuk mengelompokkan router. Kelompok router dalam MikroTik disebut “area”. Setiap area menjalankan salinan terpisah dari algoritma routing link-state dasar. Berarti bahwa masing-masing daerah memiliki basis data link layer jaringan komputer dan pohon jalur terpendek yang sesuai.

<pre>[DosenIT@MikroTik] > routing ospf area</pre>

## 38. routing ospf area print status
Perintah “routing ospf area print status” digunakan untuk menampilkan status routing ospf area.

<pre>[DosenIT@MikroTik] > routing ospf area print status</pre>

## 39. routing ospf area range
Perintah “routing ospf area range” di gunakan untuk menentukan cakupan area routing OSPF.

<pre>[DosenIT@MikroTik] > routing ospf area range</pre>

## 40. routing ospf network
Perintah “routing ospf network” digunakan untuk menentukan jaringan dimana OSPF akan dijalankan dan area yang terkait untuk masing-masing jaringan tersebut.

<pre>[DosenIT@MikroTik] > routing ospf network</pre>

## 41. routing ospf interface
Perintah “routing ospf interface” di gunakan untuk melihat daftar interface yang digunakan oleh layanan OSPF.

<pre>[DosenIT@MikroTik] > routing ospf interface</pre>
## 42. routing ospf interface print status
Perintah “routing ospf interface print status” digunakan untuk melihat status interface yang digunakan oleh layanan OSPF.

<pre>[DosenIT@MikroTik] > routing ospf interface print status</pre>

## 43. routing ospf nbma-neighbor
Perintah “routing ospf nbma-neighbor” digunakan untuk konfigurasi Non-Broadcast Multiple Access. Diperlukan hanya jika antarmuka dengan ‘network-type = nbma’ dikonfigurasi.

<pre>[DosenIT@MikroTik] > routing ospf nbma-neighbor</pre>

## 44. routing ospf virtual-link
Perintah “routing ospf virtual-link” digunakan untuk konfigurasi virtual link di antara dua router melalui area umum yang disebut area transit, salah satunya harus terhubung dengan backbone.

<pre>[DosenIT@MikroTik] > routing ospf virtual-link</pre>

## 45. routing ospf lsa
Perintah “routing ospf lsa” digunakan untuk melihat Link State Advertisement (LSA).

<pre>[DosenIT@MikroTik] > routing ospf lsa</pre>

## 46. routing ospf neighbor
Perintah “routing ospf neighbor” digunakan untuk menentukan “neighbor” dari layanan OSPF saat ini (apabila aktif).

<pre>[DosenIT@MikroTik] > routing ospf neighbor</pre>

## 47. routing ospf ospf-router
Perintah “routing ospf ospf-router” digunakan untuk menentukan OSPF Router pada layanan OSPF saat ini.

<pre>[DosenIT@MikroTik] > routing ospf ospf-router</pre>

## 48. routing ospf route
Perintah “routing ospf route” digunakan untuk menentukan “rute” pada layanan OSPF saat ini.

<pre>[DosenIT@MikroTik] > routing ospf route</pre>

## 49. routing ospf sham-link
Perintah “routing ospf sham-link” digunakan untuk menentukan sham-link yang diperlukan antara dua situs VPN yang termasuk dalam area OSPF yang sama dan berbagi back link OSPF.

<pre>[DosenIT@MikroTik] > routing ospf sham-link</pre>

## 50. routing rip
Perintah “routing rip” digunakan untuk konfigurasi Routing Information Protocol (RIP) pada MikroTik.

<pre>[DosenIT@MikroTik] > routing rip</pre>

## 51. routing rip interface
Perintah “routing rip interface” digunakan untuk menambahkan interface pada layanan RIP.

<pre>[DosenIT@MikroTik] > routing rip interface</pre>

## 52. routing rip keys
Perintah “routing rip keys” digunakan untuk menentukan kunci otentikasi MD5.

<pre>[DosenIT@MikroTik] > routing rip keys</pre>

## 53. routing rip network
Perintah “routing rip network” digunakan untuk menentukan jaringan yang akan dijalankan RIP.

<pre>[DosenIT@MikroTik] > routing rip network</pre>

## 54. routing rip neighbor
Perintah “routing rip neighbor” digunakan untuk mendefinisikan router neighbor untuk bertukar informasi routing.

<pre>[DosenIT@MikroTik] >  routing rip neighbor</pre>

## 55. routing rip route
Perintah “routing rip route” digunakan untuk rute RIP (IP Address awal, IP Address tujuan, dsb)

<pre>[DosenIT@MikroTik] > routing rip route</pre>

Sekian pembahasan mengenai perintah dasar MikroTik, untuk simulasi atau pembelajaran, ada baiknya Anda gunakan perangkat lunak simulator seperti Graphical Network Simulator-3 (GNS-3), selamat mencoba dan sampai jumpa di pembahasan selanjutnya.



















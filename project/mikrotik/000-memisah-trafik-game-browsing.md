Semakin hari kebutuhan akan manajemen jaringan semakin beragam. Hal ini tidak lepas dari semakin beragam nya pula layanan internet yang ada. Dari mulai portal berita, forum, sosial media serta game online yang saat ini banyak digemari pengguna internet. 
Sebagai penyedia layanan akses internet, tentu kita ingin memberikan layanan terbaik sehingga semua kebutuhan pengguna internet dapat diakomodasi dan dapat menjalankan aktifitas browsing, chating maupun bermain game online dengan nyaman.
Problem yang biasa terjadi adalah ketika 2 atau lebih akses yang berbeda, seperti browsing dan game online terjadi pada satu jaringan yang sama, antara keduanya dapat saling menganggu.  
Misalnya, pada warnet atau wargame (warnet dan game online) ketika banyak yang bermain game online, traffic browsing akan terganggu. Atau bisa juga terjadi sebaliknya. Yang dimaksud game online disini adalah game yang sudah terinstall di PC, kemudian dimainkan secara online, bukan game yang disediakan oleh website-website tertentu.
Pada artikel ini, akan diulas bagaimana cara memisahkan dan melakukan manajemen yang berbeda untuk traffic browsing dan game online.

**Mangle**

>Traffic browsing dan game online dapat dibedakan berdasarkan protocol dan port yang digunakan. Fitur yang dapat digunakan untuk kebutuhan tersebut adalah mangle, dimana mangle dapat digunakan untuk menandai (marking) paket data berdasarkan port, protocol, src dan dst address, serta paramater lain yang dibutuhkan.

>Untuk kasus ini, berarti kita harus mengetahui protocol dan port berapa yang digunakan oleh game online untuk menjalankan fungsi nya. Ada 2 cara untuk mendapatkan informasi tersebut.  

>Pertama, dengan melakukan Torch pada saat client menjalankan game tersebut. Sehingga akan didapat port dan protocol yang digunakan.

![](https://citraweb.com/images/artikel/Browsing-VS-game/Torch.png)  

>Disamping itu, kita bisa mencari referensi lain dari internet, dimana sudah banyak yang berhasil mengetahui port dan protocol yang digunakan oleh setiap game online yang ada. Tentu setiap game menggunakan port dan protocol yang berbeda.  

>Jika dilihat sebenarnya tipe traffic yang akan di-manage bisa digolongkan menjadi 2 tipe saja, yaitu traffic game online dan traffic selain game online (browsing,chating,dsb). Maka kita bisa membuat mangle untuk game online terlebih dahulu, baru setelahnya buat untuk selain game online berdasarkan port dan protocol yang sudah di dapat sebelumnya.  

**Mangle Game Online**

>Untuk pembuatan mangle game, karena cukup banyak game-game yang akan di-mangle, akan lebih mudah jika dibuat mark-connection semua game terlebih dahulu dengan marking yang sama.

![](https://citraweb.com/images/artikel/Browsing-VS-game/Game-CS-Conn-Mark-400.png)

>Langkah di atas merupakan salah satu contoh melakukan mar-connection dengan game yang menggunakan protocol tcp port 36567,8001 . Untuk game lakukan dengan langkah yang sama, sesuaikan protocol dan port yang digunakan.  

>Setelah langkah mark-connection selesai, barulah dibuat mark-packet berdasar mark-connection=Koneksi-Game yang sebelumnya telah dibuat  

![](https://citraweb.com/images/artikel/Browsing-VS-game/Game-Mark-Pack-400.png)

**Mangle Selain Game Online**

>Pada langkah sebelumnya telah dibuat mangle untuk game. Selanjutnya tinggal dibuat mangle untuk traffic selain game online. Di dalam nya bisa terdapat traffic browsing,chating,dsb.

**![](https://citraweb.com/images/artikel/Browsing-VS-game/Browsing-Mark-Conn.png)**

>Sama dengan langkah marking pada traffic game, buat mark-packet setelah langkah mark-connection selesai.

![](https://citraweb.com/images/artikel/Browsing-VS-game/Browsing-Mark-Pack-400.png)

>Hasil akhir dari konfigurasi mangle seperti berikut

![](https://citraweb.com/images/artikel/Browsing-VS-game/Mangle-Result-400.png)  

**Manajemen bandwidth**

>Pada artikel ini akan digunakan Queue tree untuk melakukan manajemen bandwidth berdasarkan mangle mark-packet yang sudah dibuat sebelumnya. Sebagai asumsi, bandwidth total yang dimiliki dedicated 1Mbps

>Langkah pertama, definisikan terlebih dahulu total bandwidth yang ada, baik untuk upload maupun download.

![](https://citraweb.com/images/artikel/Browsing-VS-game/Queue-Total.png)

>Selanjutnya, buat queue untuk traffic browsing dan game berdasarkan mark-packet yang sudah dibuat sebelumnya. Pada contoh ini menggunakan model HTB dengan bandwidth minimal (limit-at)=512k dan max-limit=1Mbps.

![](https://citraweb.com/images/artikel/Browsing-VS-game/Queue-Down.png)

>Lakukan juga untuk traffic browsing upload dan game upload  

![](https://citraweb.com/images/artikel/Browsing-VS-game/Queue-Up.png)

**Test**

>Dengan menggunakan model HTB, antar traffic browsing dengan game sudah memiliki bandwidth garansi masing-masing, sehingga jika keduanya berjalan bersamaan tidak akan saling mengganggu.

![](https://citraweb.com/images/artikel/Browsing-VS-game/queue-result.png)

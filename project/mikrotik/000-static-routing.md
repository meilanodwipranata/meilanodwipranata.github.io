*Topologi 1*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/Routing1.png)  

Topologi yang paling sederhana. Router A dan Router B direct connect / terhubung langsung via ethernet. Maka pengaturan routing yang perlu ditambahkan sebagai berikut

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing1-A.png)  
*Penambahan routing di Router A*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing1-b.png)  
*Penambahan routing di Router B*  

Cukup mudah bukan??

Sekarang bagaimana kalau router A dan router B tidak bisa direct connect, mungkin harus melewati perangkat lain, misalnya link wireless, atau mungkin tunnel / VPN?.  
Contoh berikutnya yaitu topologi 2.

*Topologi 2*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/Routing2.png)  

Disini Router A dan Router B supaya bisa berkomunikasi harus melewati perangkat lain yang melakukan *BRIDGING*. Pada umumnya, perangkat-perangkat router / wireless bisa melakukan fungsi bridging. Ciri paling mudah mengenali perangkat yang dilewati (dalam contoh ini perangkat wireless) apakah melakukan bridging atau tidak adalah IP Router A, IP wireless router/perangkat lain dan IP Router B memiliki IP segment yang sama (10.10.10.x/24)  
Karena Router A dan Router B memiliki IP segment yang sama, maka metode routingnya sama dengan contoh topologi 1. Tinggal disesuaikan IPnya

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing2-A.png)  
*Penambahan routing di Router A*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing2-B.png)  
*Penambahan routing di Router B*

Dari kedua contoh topologi diatas, mungkin masih terlalu sederhana. Mari kita ulas untuk topologi yang sedikit lebih kompleks.

*Topologi 3.*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3.png)  

Topologi 3 ini mirip dengan contoh topologi sebelumnya (topologi 2), tetapi untuk topologi 3 ini, perangkat yang menghubungkan antara Router A dan Router B juga menggunakan metode *ROUTING*. Apakah anda melihat perbedaannya??

Benar sekali, antara router A, wireless Router, dan router B menggunakan IP segment yang berbeda.  
Apakah sudah mulai ada bayangan di router mana kita harus membuat membuat tabel routingnya? Jawabannya adalah di keempat router tersebut.  
Capture dari tabel routing keempat router tersebut sebagai berikut :

*Di sisi Router Indoor A :*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-A1.png)  

*Penambahan routing di Router indoor A pertama*  

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-A2.png)  
*Penambahan routing di Router indoor A kedua*  

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-A3.png)  
*Penambahan routing di Router indoor A ketiga*  

*Di sisi Wireless Router A :*

![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-C1.png)  
*Penambahan routing di Wireless Router A pertama*

![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-c2.png)  
*Penambahan routing di Wireless Router A kedua*
*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-c3.png)  
*Penambahan routing di wireless Router A ketiga*

*Di sisi Wireless Router B :*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-d1.png)  
*Penambahan routing di wireless Router B pertama* 
*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-d2.png)  
*Penambahan routing di wireless Router B kedua*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-d3.png)*

*Penambahan routing di wireless Router B ketiga*

*Di sisi Router Indoor B :*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-b1.png)  
*Penambahan routing di Router indoor B pertama*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-b2.png)  
*Penambahan routing di Router indoor B kedua*

*![](https://citraweb.com/images/artikel/Simple-Static-Route/routing3-b3.png)  
*Penambahan routing di Router indoor B ketiga*  

Done..  


By : meilano404

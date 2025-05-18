_Topologi 1_

![](/notes/image/Routing1.png)

Topologi yang paling sederhana. Router A dan Router B direct connect / terhubung langsung via ethernet. Maka pengaturan routing yang perlu ditambahkan sebagai berikut

![](/notes/image/routing1-A.png)  
_Penambahan routing di Router A_

![](/notes/image/routing1-b.png)  
_Penambahan routing di Router B_

Cukup mudah bukan??

Sekarang bagaimana kalau router A dan router B tidak bisa direct connect, mungkin harus melewati perangkat lain, misalnya link wireless, atau mungkin tunnel / VPN?.  
Contoh berikutnya yaitu topologi 2.

_Topologi 2_

![](/notes/image/Routing2.png)

Disini Router A dan Router B supaya bisa berkomunikasi harus melewati perangkat lain yang melakukan _BRIDGING_. Pada umumnya, perangkat-perangkat router / wireless bisa melakukan fungsi bridging. Ciri paling mudah mengenali perangkat yang dilewati (dalam contoh ini perangkat wireless) apakah melakukan bridging atau tidak adalah IP Router A, IP wireless router/perangkat lain dan IP Router B memiliki IP segment yang sama (10.10.10.x/24)  
Karena Router A dan Router B memiliki IP segment yang sama, maka metode routingnya sama dengan contoh topologi 1. Tinggal disesuaikan IPnya

![](/notes/image/routing2-A.png)  
_Penambahan routing di Router A_

![](/notes/image/routing2-B.png)  
_Penambahan routing di Router B_

Dari kedua contoh topologi diatas, mungkin masih terlalu sederhana. Mari kita ulas untuk topologi yang sedikit lebih kompleks.

_Topologi 3._

![](/notes/image/routing3.png)

Topologi 3 ini mirip dengan contoh topologi sebelumnya (topologi 2), tetapi untuk topologi 3 ini, perangkat yang menghubungkan antara Router A dan Router B juga menggunakan metode _ROUTING_. Apakah anda melihat perbedaannya??

Benar sekali, antara router A, wireless Router, dan router B menggunakan IP segment yang berbeda.  
Apakah sudah mulai ada bayangan di router mana kita harus membuat membuat tabel routingnya? Jawabannya adalah di keempat router tersebut.  
Capture dari tabel routing keempat router tersebut sebagai berikut :

_Di sisi Router Indoor A :_

![](/notes/image/routing3-A1.png)

_Penambahan routing di Router indoor A pertama_

![](/notes/image/routing3-A2.png)  
_Penambahan routing di Router indoor A kedua_

![](/notes/image/routing3-A3.png)  
_Penambahan routing di Router indoor A ketiga_

_Di sisi Wireless Router A :_

![](/notes/image/routing3-C1.png)  
_Penambahan routing di Wireless Router A pertama_

![](/notes/image/routing3-c2.png)  
_Penambahan routing di Wireless Router A kedua_

![](/notes/image/routing3-c3.png)  
_Penambahan routing di wireless Router A ketiga_

_Di sisi Wireless Router B :_

![](/notes/image/routing3-d1.png)  
_Penambahan routing di wireless Router B pertama_

![](/notes/image/routing3-d2.png)  
_Penambahan routing di wireless Router B kedua_

![](/notes/image/routing3-d3.png)

> _Penambahan routing di wireless Router B ketiga_

_Di sisi Router Indoor B :_

![](/notes/image/routing3-b1.png)

> _Penambahan routing di Router indoor B pertama_

![](/notes/image/routing3-b2.png)  
_Penambahan routing di Router indoor B kedua_

![](/notes/image/routing3-b3.png)  
_Penambahan routing di Router indoor B ketiga_

Done..

By : meilano404

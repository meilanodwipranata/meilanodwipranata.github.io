<style>
body{display:grid;place-items:center;background:linear-gradient(180deg,#071025 0%, #07192b 60%), radial-gradient(600px 300px at 10% 10%, rgba(110,231,183,0.06), transparent), radial-gradient(500px 250px at 90% 90%, rgba(99,102,241,0.04), transparent);color:#e6eef6}.card{width:360px;max-width:92vw;background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));border:1px solid rgba(255,255,255,0.04);padding:28px;border-radius:16px;box-shadow:0 6px 30px rgba(2,6,23,0.6);backdrop-filter: blur(6px)}
</style>


---
title: "File Sharing Antara Host dan Guest di Virt Manager/KVM/QEMU"
date: 2021-12-04T17:15:16+07:00
draft: false
toc: false
images: 
tags:
  - untagged
---

# File Sharing Antara Host dan Guest di Virt Manager/KVM/QEMU

Cara file sharing antara host dengan guest OS di Virt Manager/KVM/QEMU :

**1. Buat folder/directory di host os sebagai directory file sharing**
{{< highlight bash >}}
mkdir ~/FileSharing
{{< /highlight>}}
Ubah permission directory untuk file sharing
{{< highlight bash >}}
chmod 777 ~/FileSharing
{{< /highlight >}}

**2. Add hardware Filesystem**

Buka guest OS di virt manager(dalam keadaan mati), dan masuk ke Details, Add Hardware, dan pilih Filesystem.

Source path = directory di host os untuk filesharing  
Target path = nama untuk target path untuk di mount di guest OS  

![images](/notes/image/filesharing1.png)

Lalu finish dan hidupkan guest OS


**3. Mounting di Guest OS** 
 
Buat folder/directory baru di guest
{{< highlight bash >}}
mkdir ~/sharing-guest
{{< /highlight >}}

Mount file system yang dibuat sebelumnya dengan perintah
{{< highlight bash >}}
sudo mount -t 9p -o trans=virtio /sharing sharing-guest
{{< /highlight >}}

Done!!

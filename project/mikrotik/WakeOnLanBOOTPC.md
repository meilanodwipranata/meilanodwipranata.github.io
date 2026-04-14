MikroTik Auto Wake-on-LAN Saat Boot (Super Ringan)

Script ini digunakan untuk menyalakan PC otomatis menggunakan Wake-on-LAN (WoL) saat MikroTik hidup (misalnya setelah mati listrik).

Menggunakan metode Netwatch (event-based) sehingga sangat ringan dan tidak membebani CPU router.

---

🚀 Script Final (Copy Paste Sekali Jadi)

/system script add name=send_wol source=":local targetMac \"AA:BB:CC:DD:EE:FF\"; /tool wol mac=\$targetMac interface=bridge; :log info \"Kirim WOL ke \$targetMac\"";

/tool netwatch add host=192.168.1.10 interval=20s timeout=2s down-script="/system script run send_wol" up-script=":log info \"PC sudah hidup - Netwatch OK\"";

/system scheduler add name=enable_netwatch start-time=startup on-event=":delay 30s; /tool netwatch enable [find host=192.168.1.10]";

---

⚙️ Konfigurasi

Silakan ubah sesuai kebutuhan:

Parameter| Keterangan
"AA:BB:CC:DD:EE:FF"| MAC Address PC target
"192.168.1.10"| IP Address PC (static)
"bridge"| Interface LAN MikroTik

---

🔁 Cara Kerja

1. MikroTik menyala (boot)
2. Menunggu 30 detik (agar jaringan stabil)
3. Netwatch mulai monitoring IP PC setiap 20 detik
4. Jika PC mati (DOWN) → kirim Wake-on-LAN
5. Jika PC hidup (UP) → berhenti otomatis

---

📊 Flow Diagram

Boot MikroTik
      ↓
Delay 30 detik
      ↓
Netwatch aktif
      ↓
┌───────────────┬─────────────────┐
│ PC Mati (DOWN)│ PC Hidup (UP)   │
├───────────────┼─────────────────┤
│ Kirim WoL     │ Stop            │
│ tiap 20 detik │                 │
└───────────────┴─────────────────┘

---

✅ Kelebihan

- ✔ Super ringan (tanpa loop manual)
- ✔ Tidak spam ping / CPU rendah
- ✔ Otomatis setiap boot (cocok untuk mati listrik)
- ✔ Stabil & best practice MikroTik

---

⚠️ Syarat Agar Berfungsi

Di PC:

- Aktifkan Wake-on-LAN di BIOS/UEFI
- Aktifkan Allow Wake from Magic Packet (LAN)
- Nonaktifkan Fast Startup (Windows)

Di MikroTik:

- Interface LAN benar
- MAC Address & IP sesuai

---

💡 Tips

- Gunakan UPS untuk MikroTik agar tetap hidup saat listrik padam
- Pastikan PC tetap terhubung kabel LAN (bukan WiFi)
- Bisa dikembangkan untuk multi-device

---

📌 Use Case

- Server rumah / homelab
- PC monitoring
- Lab sekolah
- CCTV / NVR otomatis hidup

---

🧠 Kesimpulan

Solusi ini menjadikan MikroTik sebagai auto power trigger untuk PC yang tidak memiliki fitur auto boot saat listrik kembali.

Efisien, ringan, dan sangat cocok untuk penggunaan jangka panjang.

---

📬 Pengembangan Selanjutnya

- Multi PC Wake-on-LAN
- Notifikasi Telegram saat PC hidup
- Integrasi dengan sistem monitoring

---

Author:
Konfigurasi & optimasi oleh ChatGPT + User 🚀

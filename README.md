# GO-EAT
COMMAND LINE APP (GO-EAT)

----------------------
Command Line Arguments
----------------------

1 | 2 | 3 | 0 
  (required) Specifies the choice that user chooce to enter any menu
  
---------------
CLASS & METHOD
---------------
Terdapat 4 Class dalam program:
1) Map -> class ini terdiri dari 2 method yaitu initialize dan show_map
       Digunakan untuk menginisiasi dan menampilkan map
2) User -> class ini terdiri dari beberapa method yaitu initialize, generate_location dan resto_distance
       Digunakan untuk menginisiasi user, mendefinisikan posisi user dalam map dan mendefinisikan jarak user ke restoran
3) Driver -> class ini terdiri dari beberapa method yaitu initialize, generate_location, take_route, get_rating
       Digunakan untuk menginisiasi driver, mendefinisikan posisi driver dalam map, menentukan rute yang dilalui untuk mengantar
       pesanan user, dan mendapatkan rating dari user
4) Restaurant -> class ini terdiri dari beberapa method yaitu initialize, generate_location
       Digunakan untuk menginisiasi driver, mendefinisikan posisi restoran dalam map

Terdapat beberapa method di luar class :
1) choose_resto -> Berfungsi untuk memilih restoran
2) choose_food -> Berfungsi untuk memilih makanan
3) create_cart -> Berfungsi untuk membuat keranjang pesanan
4) get_total_cost -> Berfungsi untuk mendapatkan nilai total biaya yang harus dibayar pemesan
5) get_driver -> Berfungsi untuk mendapatkan driver yang akan mengantar pesanan
6) get_order_information -> Berfungsi untuk merekap pesanan user
7) finish_order -> Berfungsi untuk mengkonfirmasi apakah user akan menyelesaikan pesanan atau membatalkannya
8) view_history -> Berfungsi untuk menampilkan riwayat pesanan user

-------------------------
Design Decisions & Issues
-------------------------
Mengapa terdapat method di luar class?
- Ini dikarenakan pada awalnya saya belum paham dengan OOP dan masih mengadaptasi cara lama yang sudah saya pahami
  yaitu Modullar Programming, dan setelah sedikit memahami OOP saya tidak merubahnya karena takut akan menghasilkan
  banyak error ketika program dijalankan

Tampilan masuk program
- Menampilkan 4 pilihan yaitu : 
1. Tampilkan peta
2. Pesan makanan
3. Tampilkan riwayat pesanan
4. Keluar program

Alur Memesan Makanan
1. Memilih restoran (dengan mengetikkan nomor dari 3 pilihan restoran)
2. Memesan makanan (dengan mengetikkan nama makanan diikuti jumlah makanan yang dipesan)
3. Megkonfirmasi atau membatalkan pesanan (dengan mengetikkan huruf 'Y' atau 'N')
4. Memberikan rating untuk driver (dengan mengetikkan nilai antara 1 sampai 5)

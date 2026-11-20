
# Food Store - Backend

Aplikasi backend Food Store menggunakan Laravel dan Filament.

## Teknologi
- Laravel
- PHP
- MySQL
- Filament
- Midtrans Payment Gateway

## Fitur
- Dashboard Admin menggunakan Filament
- Manajemen Produk
- Manajemen Kategori
- Manajemen Transaksi
- API untuk aplikasi Flutter
- Integrasi pembayaran Midtrans

## Instalasi

Clone repository:

```bash
git clone https://github.com/Maldiria/food-store.git
```

Masuk ke folder project:

```bash
cd food-store
```

Install dependency:

```bash
composer install
```

Salin file konfigurasi:

```bash
copy .env.example .env
```

Generate application key:

```bash
php artisan key:generate
```

Atur konfigurasi database di file `.env`, kemudian jalankan:

```bash
php artisan migrate
```

Jalankan aplikasi:

```bash
php artisan serve
```

Dashboard admin:

```text
http://127.0.0.1:8000/admin
```

## Developer

Maldiria

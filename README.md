
# Dokumentasi Aplikasi

## Pages & Widgets

### News Page
- File: lib/pages/news_page.dart
- Tujuan: Menampilkan headline utama berdasarkan genre/kategori, memungkinkan pengguna mengganti genre, membuka kartu artikel, dan menavigasi ke halaman Tersimpan dan Pengaturan.
- Widget utama: `AppBar` (tombol ke Saved/Settings), barisan `FilterChip` untuk memilih genre, `ListView` berisi `NewsCard`.
- Perilaku penting: mengambil data via `GNewsClient`, menangani state loading/error, dan meneruskan callback perubahan tema melalui `onThemeChanged`.

### News Card
- File: lib/pages/news_card.dart
- Tujuan: Komponen kartu yang menampilkan gambar artikel, judul, deskripsi singkat, sumber/tanggal, serta tombol simpan (bookmark).
- Widget utama: `Image.network`, teks judul/deskripsi, format tanggal dengan paket `intl`, `OutlinedButton.icon` untuk toggle simpan.
- Perilaku penting: membuka `WebViewPage` saat diketuk, menggunakan `SavedNewsService` untuk menyimpan/menghapus artikel serta memilih folder saat menyimpan.

### Saved News Page
- File: lib/pages/saved_news_page.dart
- Tujuan: Menampilkan artikel yang disimpan dikelompokkan per folder; memungkinkan membuat, mengganti nama, menghapus folder dan menghapus semua artikel tersimpan.
- Widget utama: barisan `FilterChip` untuk folder, `ActionChip` untuk membuat folder baru, `FutureBuilder` + `ListView` berisi `NewsCard`, menu konteks `SavedFolderContextMenu` pada long-press.
- Perilaku penting: berinteraksi dengan `SavedNewsService` (`getFolders`, `getSavedArticles`, `createFolder`, `renameFolder`, `deleteFolder`, `clearAll`).

### Saved Folder Context Menu
- File: lib/pages/saved_folder_context_menu.dart
- Tujuan: UI bottom-sheet sederhana untuk aksi folder (`Rename` / `Delete`).
- Catatan: Komponen UI murni; callback (`onRename`, `onDelete`) ditangani oleh `SavedNewsPage`.

### Settings Page
- File: lib/pages/settings_page.dart
- Tujuan: Mengizinkan pengguna memilih tema aplikasi: Light, Dark, atau System.
- Widget utama: `Radio<ThemeMode>` di dalam `ListTile` dan pemanggilan `onThemeChanged` untuk menerapkan perubahan.

### WebView Page
- File: lib/pages/webview_page.dart
- Tujuan: Menampilkan halaman artikel di dalam WebView.
- Widget utama: `WebViewController`, `WebViewWidget`, dan `NavigationDelegate` untuk hook navigasi.

---

## Commands

### Generate JSON Serializable
```
flutter pub run build_runner build --delete-conflicting-outputs
```

### Build App
```
flutter build aab --release

flutter build apk --release
```
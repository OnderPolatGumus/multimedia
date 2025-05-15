# Flutter Vehicle Dashboard UI

Bu proje, Flutter kullanılarak geliştirilmiş basit bir araç veri ekranı simülasyonudur.

## Kurulum

### Gerekli Araçlar

* Flutter SDK (>=3.0)
* Dart SDK (Flutter ile birlikte gelir)
* Linux veya Windows cihaz
* Eğer Windows kullanılıyorsa Visual Studio ve ilgili C++ geliştirme araçları yüklü olmalıdır.

### Bağımlılıkları Kur

Projeyi GitHub’dan çektikten sonra terminalde proje klasörüne gidin:

```bash
cd multimedia  # ya da klasör adınız neyse
```

Şu komutları sırasıyla çalıştırın:

```bash
flutter clean
flutter pub get
```

Bu komutlar eski build verilerini temizler ve proje bağımlılıklarını yükler.

## Çalıştırma

### Linux için:

```bash
flutter run -d linux
```

### Windows için:

```bash
flutter run -d windows
```

### Web için (test amaçlı):

```bash
flutter run -d chrome
```

## Notlar

* Proje içinde veri kaydetme veya dosya erişimi yapılmamaktadır.
* `Timer.periodic` kullanılarak simüle edilen verilerle güncellenen bir UI yapısı vardır.

---

Proje ile ilgili katkıda bulunmak isterseniz pull request gönderebilirsiniz.

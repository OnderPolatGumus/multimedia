#!/usr/bin/env bash
set -e

# X11 backend önerisi (Wayland'da sorun olabiliyor)
#!/usr/bin/env bash
set -e

# Wayland'da GL sorunlarına karşı X11 backend önerisi:
export GDK_BACKEND=x11

# Önce varsa eski süreçleri kapat (isteğe bağlı, temiz başlangıç)
pkill -f "flutter_tool" || true
pkill -f "multimedia"   || true

# SAĞ pencere
APP_ROLE=right flutter run -d linux &

# Küçük gecikme
sleep 0.5

# SOL pencere
APP_ROLE=left  flutter run -d linux &

# Her iki süreç bitene kadar bekle
wait
export GDK_BACKEND=x11

# Sağ pencere (right)
flutter run -d linux --dart-define=APP_ROLE=right &

# Küçük gecikme (sağ pencere açılmadan sol başlamasın)
sleep 1

# Sol pencere (left)
flutter run -d linux --dart-define=APP_ROLE=left &

# Script beklesin, iki process kapanınca bitsin
wait

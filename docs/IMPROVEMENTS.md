# ETA Tenis CRM — UX İyileştirmeleri

Bu sürümde antrenör panelinin günlük kullanımını hızlandırmak için **öğrenciler**, **yoklama** ve **görsel kontrast** odaklı iyileştirmeler yapıldı. Aşağıdaki görseller geliştirme sırasında yakalanan ekranlardır.

---

## 1. Öğrenciler: arama, filtre ve seviye

Öğrenci listesi artık hızlı taranabilir:

- İsim / e-posta / grup / seviye **arama**
- Top seviyesi ve grup için **yatay kaydırılabilir** filtreler
- Seviye chip’leri kompakt: top görseli + tek harf (`K` `T` `Y` `S`)
- Kartlarda seviye metni kaldırıldı; seviye yalnızca top görseliyle anlaşılıyor

![Öğrenciler — arama ve filtreler](screenshots/01-ogrenciler-arama-filtre.png)

![Öğrenciler — seviye chip’leri](screenshots/02-ogrenciler-seviye-chip.png)

---

## 2. Yoklama: daha az yer, daha hızlı işaretleme

Grup yoklamasında dört seçenek iki satıra yayılıyordu ve diyalog şişiyordu.

**Önce:** Geldi / Gelmedi / Geç / İzinli

![Yoklama diyaloğu — önceki yoğun düzen](screenshots/03-yoklama-dialog-once.png)

**Sonra:**

- Tek satır: **Geldi · Gelmedi · Diğer**
- **Diğer** → Geç / İzinli popup
- Sekmede **Bugün** / **Tüm yoklamalar**
- Varsayılan: bugünün dersleri
- **Alındı / Alınmadı** durumu görünür
- **Alınmayanlar** filtresi + hızlı **Al** butonu

---

## 3. Kontrast ve marka okunabilirliği

Koyu app bar üzerinde logonun koyu kısmı kayboluyor, diyaloglarda **İptal** açık yeşil olduğu için zor okunuyordu.

![Kontrast sorunları — logo ve İptal](screenshots/04-kontrast-logo-iptal.png)

**Düzeltmeler:**

- App bar’da logo beyaz kapsül içinde (`EtaLogo(onDark: true)`)
- Tüm `TextButton` / diyalog metinleri lacivert (okunabilir)
- Ortak tema: diyalog, menü, outlined buton kontrastı

---

## Teknik özet

| Alan | Değişiklik |
|------|------------|
| Öğrenciler | Arama, yatay filtre scroll, ITF top görselleri |
| Yoklama | Kompakt durum seçimi, Bugün/Tümü, alınmayanlar |
| Tema | Kontrast odaklı `AppTheme` + `EtaLogo` |
| Veri | Ball level, grup notları, yoklama toplu sorgu |

---

*ETA Tenis Akademisi — antrenör CRM*

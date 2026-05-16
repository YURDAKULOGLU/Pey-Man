# Pey-Man Pixel UI

Bu dosya hackathon demosu icin Pac-Man esinli MATLAB arayuzunun hizli notudur.

## Calistirma

MATLAB'da repo klasorunu current folder yapin ve sunu calistirin:

```matlab
runPeyManPixelApp
```

## MVP mantigi

Arayuz tamamen MATLAB icinde cizilir. Dis gorsel asset yoktur.

- Pey-Man sari pixel karakterdir.
- Hayalet hedef kacirma riskini temsil eder.
- Ortadaki noktalar gunluk mikro hedeflerdir.
- Gunluk hedefler tamamlandikca Pey-Man hedefe yaklasir.
- Hedefler kacirildikca hayalet Pey-Man'e yaklasir.
- Skor ve streak sag ustte guncellenir.

## Gunluk hedefler

Baslangic hedefleri:

- 8000 adim
- 30 dakika egzersiz
- 8 bardak su
- 7 saat uyku

Skor agirliklari:

- Adim: %45
- Egzersiz: %25
- Su: %15
- Uyku: %15

## Hackathon fazlari

1. Pixel UI demosu: `runPeyManPixelApp`
2. Ornek veri metrikleri: `source/matlab-mobile-fitness-tracker-master/ExampleModel.mlx`
3. MATLAB Mobile sensor kaydi
4. Adim, mesafe, kalori ve aktivite sinifi hesaplama
5. UI'a gercek metrikleri otomatik basma
6. Streak, rozet ve haftalik harita ekleme

## Sonraki baglanti fikri

Starter live script icindeki metrik ciktisini daha sonra arayuze baglamak icin bir fonksiyon haline getirin:

```matlab
metrics = calculateFitnessMetrics("ExampleData.mat");
```

Sonra `peyManPixelApp` icindeki input alanlari yerine bu metrikleri otomatik doldurabilirsiniz.

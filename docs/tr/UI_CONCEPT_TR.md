# Pey-Man Arayuz Konsepti

Pey-Man Fitness Tracker, tamamen MATLAB ile gelistirilecek Pac-Man temali bir fitness takip uygulamasidir. Projede kullanilan tum kodlar, arayuz bilesenleri, grafik cizimleri, animasyonlar, veri isleme adimlari ve kullanici etkilesimleri yalnizca MATLAB ortaminda hazirlanacaktir. Harici oyun motoru, web teknolojisi, mobil framework veya farkli bir programlama dili kullanilmayacaktir.

Uygulamanin genel arayuz dili klasik Pac-Man oyunundan ilham alan pixel-art tasarim uzerine kurulacaktir. Yani sadece bir bolum veya kucuk bir animasyon degil, uygulamanin tamami Pac-Man evrenine benzer retro bir gorsel stile sahip olacaktir. Siyah arka plan, neon mavi labirent cizgileri, sari ana karakter, renkli hayaletler, beyaz hedef noktalari, skor alanlari ve pixel fontlar arayuzun temel gorsel yapisini olusturacaktir.

Kullanici, uygulamada Pey-Man adli Pac-Man benzeri bir karakterle temsil edilecektir. Fitness hedefleri ise oyun haritasindaki pixel noktalar, ozel yemler veya labirent hedefleri seklinde gosterilecektir. Kullanici fiziksel aktivite yaptikca, gunluk veriler MATLAB tarafindan islenecek ve Pey-Man'in oyun alanindaki ilerleyisine yansitilacaktir.

Arayuzde klasik fitness uygulamalarindaki sade tablo ve grafik yapisi yerine, veriler oyunlastirilmis bir deneyim olarak sunulacaktir. Ornegin adim sayisi, egzersiz suresi, kalori, su tuketimi, uyku veya aktivite skoru gibi metrikler Pac-Man tarzi harita parcalariyla iliskilendirilecektir. Kullanici hedeflerine yaklastikca Pey-Man labirent icinde ilerleyecek, hedef noktalarini toplayacak ve skor kazanacaktir.

## Ana Arayuz Yapisi

Uygulamanin ana ekrani Pac-Man labirentine benzeyen pixel bir oyun alani olacaktir. Bu alanda Pey-Man, kullanicinin gunluk fitness durumuna gore hareket edecektir. Ekranin ust bolumunde skor, gunluk ilerleme, hedef yuzdesi ve kullanici seviyesi yer alacaktir. Yan panellerde ise adim, kalori, egzersiz suresi, mesafe ve aktivite durumu gibi fitness metrikleri pixel kutular icerisinde gosterilecektir.

Her metrik, Pac-Man tarzi bir gorsel karsilikla temsil edilecektir:

- Adim hedefi: labirentte toplanan kucuk noktalar
- Kalori hedefi: bonus meyve veya ozel yem
- Egzersiz suresi: haritada ilerleme mesafesi
- Su tuketimi: enerji noktalari
- Uyku veya dinlenme: can yenileme alani
- Gunluk basari: bolum tamamlama ekrani

Bu sayede kullanici yalnizca sayisal veri gormeyecek; fitness ilerlemesini bir oyun haritasi uzerinde deneyimleyecektir.

## Streak Mode

Streak Mode, uygulamadaki ozel modlardan sadece biri olacaktir. Bu modda kullanicinin gun ust uste hedeflerini tamamlama basarisi takip edilecektir. Kullanici hedeflerini duzenli olarak tamamladiginda streak artacak ve Pey-Man daha avantajli hale gelecektir.

Streak Mode'da hayalet karakterler onemli bir rol oynayacaktir. Hayaletler; hedef kacirmayi, motivasyon kaybini, hareketsizligi veya gunluk rutinden sapmayi temsil edecektir. Kullanici gunluk hedeflerini yerine getirmezse hayaletler Pey-Man'e yaklasacaktir. Hedefler tamamlandiginda ise Pey-Man hayaletlerden uzaklasacak veya ozel guc kazanacaktir.

Ancak hayalet sistemi yalnizca Streak Mode'a bagli bir ozellik olarak dusunulecektir. Uygulamanin tamami zaten Pac-Man tarzinda tasarlanacak, Streak Mode ise bu temanin icinde yer alan ekstra bir oyunlastirma mekanizmasi olacaktir.

## Diger Olasi Modlar

Streak Mode disinda uygulamada farkli Pac-Man tarzi modlar da bulunabilir:

- Daily Maze Mode: kullanicinin gunluk hedeflerini tamamlamaya calistigi ana mod
- Challenge Mode: belirli sure icinde belirli aktivite hedeflerine ulasma modu
- Calories Hunt: kalori yakimina odaklanan bonus toplama modu
- Step Quest: adim sayisina gore labirentte ilerleme modu
- Recovery Mode: uyku, dinlenme ve su tuketimi gibi toparlanma metriklerine odaklanan mod
- Boss Chase: haftalik hedeflerin toplu olarak degerlendirildigi daha zorlu mod

Bu modlarin tamami ayni Pac-Man pixel evreni icinde calisacaktir. Boylece uygulama sadece tek bir animasyondan ibaret olmayacak, butun kullanici deneyimi oyunlastirilmis bir fitness takip sistemine donusecektir.

## Tasarim Dili

Arayuz tamamen retro ve pixel temelli olacaktir. MATLAB icinde cizilecek sekiller, paneller, grafikler ve animasyonlar bu stile uygun tasarlanacaktir. Modern, yuvarlak ve minimalist fitness uygulamasi gorunumu yerine; arcade makinesi hissi veren, canli renkli ve oyun ekrani benzeri bir yapi tercih edilecektir.

Tasarimda kullanilacak ana ogeler:

- Siyah veya cok koyu lacivert arka plan
- Neon mavi labirent cizgileri
- Sari Pey-Man karakteri
- Kirmizi, pembe, mavi ve turuncu hayaletler
- Beyaz pixel hedef noktalari
- Pixel font hissi veren yazilar
- Skor, can, seviye ve hedef panelleri
- MATLAB ile cizilmis barlar, gostergeler ve grafikler

## Teknik Yaklasim

Proje tamamen MATLAB ile gelistirilecektir. Arayuz icin MATLAB'in kendi gorsel bilesenleri kullanilacaktir. Grafikler, karakterler, labirent cizimleri ve ilerleme animasyonlari MATLAB icerisinde uretilecektir.

Kullanilabilecek MATLAB bilesenleri:

- `uifigure`
- `uigridlayout`
- `uipanel`
- `uilabel`
- `uibutton`
- `uieditfield`
- `uiaxes`
- `rectangle`
- `patch`
- `plot`
- MATLAB tabanli veri isleme fonksiyonlari

Fitness verileri MATLAB Mobile uzerinden alinabilecek sensor verileriyle desteklenebilir. Adim sayisi, ivme, GPS, hiz, mesafe ve aktivite suresi gibi veriler MATLAB icinde islenerek arayuzde oyunlastirilmis sekilde gosterilecektir.

## Amac

Pey-Man'in temel amaci, fitness takibini sikici grafiklerden cikarip kullaniciyi motive eden bir oyun deneyimine donusturmektir. Kullanici her gun uygulamayi actiginda yalnizca kac adim attigini gormekle kalmayacak; kendi karakterinin labirentte ne kadar ilerledigini, hangi hedefleri topladigini ve hangi modlarda basarili oldugunu gorecektir.

Bu sayede uygulama hem teknik olarak MATLAB tabanli bir fitness tracker olacak hem de yaratici olarak Pac-Man tarzinda tasarlanmis ozgun bir arayuz deneyimi sunacaktir. Streak Mode bu deneyimin onemli bir parcasi olacak, ancak uygulamanin genel tasarim anlayisi tamamen Pac-Man pixel-art konsepti uzerine kurulacaktir.

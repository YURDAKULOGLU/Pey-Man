# Pey-Man UI Feature Fikirleri

Bu dokuman, Pey-Man'in Pac-Man temali arayuzunu guclendirecek ek modlari ve urun fikirlerini tanimlar. Tum fikirler MATLAB tabanli fitness pipeline'i ile uyumlu olacak sekilde dusunulmustur.

## 1. Pixel UI ve Gercek Model Metriklerinin Baglanmasi

Pey-Man arayuzu yalnizca gorsel bir Pac-Man temasi olmayacak; arka planda calisan MATLAB modelinden gelen gercek fitness metrikleriyle beslenecektir. MATLAB Mobile'dan alinan sensor verileri islendikten sonra sistem; Workout Quality Score, Fatigue Index, Confidence Index, adim sayisi, mesafe, kalori ve kadans gibi degerleri hesaplayacaktir.

Bu metrikler arayuzde Pac-Man tarzi oyun ogelerine donusturulecektir. Ornegin Workout Quality Score, Pey-Man'in bolumde ne kadar ilerledigini belirleyecektir. Fatigue Index yukseldiginde hayaletler Pey-Man'e yaklasacak, Confidence Index dusuk oldugunda sensor sinyali uyarisi gosterilecektir. Boylece kullanici yalnizca sayisal sonuclar gormek yerine, kendi egzersiz performansini oyunlastirilmis bir Pac-Man haritasi uzerinde takip edecektir.

Bu ozellik, arayuzun sadece dekoratif degil, model ciktilariyla dogrudan baglantili ve anlamli olmasini saglayacaktir.

## 2. Activity Replay Mode

Activity Replay Mode, kullanicinin egzersiz seansini Pac-Man tarzi bir tekrar animasyonuna donusturen ozel bir mod olacaktir. MATLAB modeli, sensor verilerini zaman pencerelerine ayirarak kullanicinin o anki aktivitesini sit, walk veya run olarak siniflandiracaktir. Bu aktivite etiketleri arayuzde Pey-Man'in davranislarina yansitilacaktir.

Kullanici yurudugunde Pey-Man normal hizda ilerleyecek, kostugunda daha hizli hareket edecek, hareketsiz kaldiginda ise duracak ve hayaletler ona yaklasacaktir. Eger seansin ilerleyen dakikalarinda Fatigue Index yukselirse arayuzde uyari renkleri, tehlike gostergeleri veya hayalet hareketleri daha belirgin hale gelecektir.

Bu mod sayesinde ham sensor verisi, kullanici tarafindan kolayca anlasilabilen gorsel bir hikayeye donusecektir. Kullanici egzersizinin hangi bolumunde hizlandigini, nerede yavasladigini ve nerede yorulmaya basladigini Pac-Man tarzi bir tekrar ekraninda gorebilecektir.

## 3. Judge Demo Mode

Judge Demo Mode, hackathon sunumu sirasinda projenin tum onemli ozelliklerini tek komutla gostermek icin tasarlanacaktir. Bu modun amaci, juri karsisinda veri dosyasi secme, ayar yapma veya manuel hazirlikla zaman kaybetmeden calisan bir demo sunmaktir.

Bu mod calistirildiginda MATLAB once ornek veya sentetik fitness verisini isleyecek, ardindan model metriklerini hesaplayacaktir. Daha sonra Fatigue Index Timeline, Activity Breakdown, Workout Quality Score ve Confidence Index gibi gorsellestirmeler uretilecektir. Son adimda Pac-Man temali Pey-Man arayuzu acilacak ve hesaplanan metrikler oyunlastirilmis sekilde gosterilecektir.

Judge Demo Mode, projenin hem teknik tarafini hem de urun deneyimini tek akista gosterecektir. Boylece juri, MATLAB Mobile sensor verisinden baslayip Pac-Man temali fitness arayuzune kadar uzanan tum sureci net sekilde gorebilecektir.

## 4. Pac-Man Score Engine

Pac-Man Score Engine, fitness metriklerini klasik arcade oyun skoruna donusturen sistem olacaktir. Bu sistem sayesinde kullanici yalnizca "8000 adim attim" veya "250 kalori yaktim" gibi standart veriler gormeyecek; bunun yerine bu veriler oyun ici puana cevrilecektir.

Ornegin adim sayisi kucuk hedef noktalarindan gelen puanlari, egzersiz suresi bolum ilerlemesini, dusuk Fatigue Index bonus puani, yuksek Confidence Index ise sensor guven bonusunu temsil edecektir. Kullanici gunluk hedeflerini tamamladiginda Perfect Day Bonus alabilecek, haftalik hedefleri tamamladiginda ise ekstra seviye puani kazanabilecektir.

Bu sistem, fitness takibini daha motive edici hale getirecektir. Kullanici her gun kendi skorunu artirmaya calisacak, onceki gunlerle yarisacak ve hedeflerini oyun mantigiyla takip edecektir.

## 5. Ghost Types

Ghost Types sistemi, Pac-Man temasindaki hayaletleri farkli fitness risklerini temsil edecek sekilde kullanacaktir. Her hayalet, kullanicinin performansindaki farkli bir problemi sembolize edecektir. Boylece arayuz sadece eglenceli gorunmekle kalmayacak, ayni zamanda kullanicinin hangi alanda eksik kaldigini hizlica anlamasini saglayacaktir.

Ornegin kirmizi hayalet yuksek yorgunlugu temsil edebilir. Fatigue Index yukseldiginde kirmizi hayalet Pey-Man'e yaklasir. Mavi hayalet dusuk sensor guvenini temsil eder; Confidence Index dusukse gorunur hale gelir. Pembe hayalet hareketsizligi, turuncu hayalet ise dusuk Workout Quality Score degerini temsil edebilir.

Bu sistem sayesinde kullanici tek bir genel basarisizlik mesaji yerine, hangi fitness metrigindeki sorunun one ciktigini gorsel olarak anlayacaktir. Hayaletler, kullanicinin dikkat etmesi gereken alanlari oyunlastirilmis bir uyari sistemi olarak gosterecektir.

## 6. Automatic Report / Presentation Generator

Automatic Report / Presentation Generator, MATLAB tarafindan egzersiz seansi tamamlandiktan sonra otomatik olarak ozet rapor veya sunum icerigi uretilmesini saglayacaktir. Modelin hesapladigi metrikler, grafikler ve aciklamalar tek bir duzenli ciktida toplanacaktir.

Bu raporda Workout Quality Score, Fatigue Index, Confidence Index, aktivite dagilimi, adim sayisi, mesafe, kalori ve kadans gibi temel sonuclar yer alacaktir. Ayrica sistem, kullanicinin seansina gore kisa bir yorum metni uretecektir. Ornegin seansin guclu yonleri, yorgunluk artis noktasi ve sensor guvenilirligi raporda belirtilecektir.

Hackathon acisindan bu ozellik, projenin sunum kalitesini artiracaktir. Juriye yalnizca calisan bir uygulama degil, ayni zamanda sonuclari anlasilir sekilde raporlayan tam bir MATLAB fitness tracker sistemi gosterilmis olacaktir.

## 7. Ghost Chase Streak Mode

Ghost Chase Streak Mode, kullanicinin gunluk hedeflerini duzenli olarak tamamlama aliskanligini oyunlastiran ozel bir mod olacaktir. Bu mod, uygulamanin tamami degil; Pac-Man tarzi genel arayuzun icinde yer alan bir motivasyon ozelligi olacaktir.

Kullanici hedeflerini ust uste tamamladikca streak degeri artacak ve Pey-Man labirentte avantaj kazanacaktir. Streak arttikca ekstra puanlar, bonus hedef noktalari veya Power Pellet gibi ozel gucler acilabilir. Eger kullanici gunluk hedeflerini kacirirsa hayaletler Pey-Man'e yaklasacak ve streak tehlikeye girecektir.

Bu modun amaci kullaniciyi yalnizca tek bir egzersiz seansinda degil, gunler boyunca duzenli kalmaya tesvik etmektir. Boylece Pey-Man, kisa sureli performans takibinin yaninda uzun vadeli aliskanlik takibini de destekleyecektir.

## 8. Weekly Boss Mode

Weekly Boss Mode, haftalik fitness hedeflerinin oyunlastirilmis final degerlendirmesi olacaktir. Kullanicinin hafta boyunca topladigi adimlar, egzersiz suresi, kalite skoru, yorgunluk seviyesi ve duzenliligi bu modda degerlendirilir.

Haftanin sonunda kullanici ozel bir boss ekraniyla karsilasir. Bu boss, haftalik hedeflerin zorlugunu temsil eder. Kullanici yeterli adim attiysa, egzersiz suresini tamamladiysa, Workout Quality Score belirli bir seviyenin ustundeyse ve streak degerini koruduysa boss yenilmis sayilir.

Weekly Boss Mode, gunluk hedeflerin haftalik buyuk bir amaca baglanmasini saglar. Boylece kullanici sadece bugunku performansini degil, tum haftalik fitness disiplinini Pac-Man tarzi bir oyun bolumu olarak gorebilir.

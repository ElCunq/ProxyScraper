# ProxyScrapper

ProxyScrapper, çeşitli kaynaklardan proxy adreslerini toplayan, bu proxy'leri doğrulayan ve güncelleyen bir Bash betiğidir. Proxy'ler JSON formatında bir veritabanında saklanır ve Google üzerinden doğrulama yapılır.

## Özellikler

- **Proxy Toplayıcı (Scraper)**: Belirtilen kaynaklardan proxy adreslerini toplar ve bir JSON dosyasına kaydeder.
- **Proxy Doğrulayıcı (Controller)**: Toplanan proxy'leri Google üzerinden test ederek çalışan proxy'leri belirler.
- **Proxy Güncelleyici (Updater)**: Proxy listesindeki tekrar eden kayıtları kaldırır ve listeyi temizler.
- **JSON Formatında Saklama**: Proxy bilgileri (IP, port, protokol, son kontrol tarihi, çalışma durumu) JSON formatında saklanır.

## Nasıl Kullanılır?

1. **Betiği Çalıştırma**:
   ```bash
   ./ProxyScrapper.sh
   ```
   Betiği çalıştırmadan önce çalıştırılabilir hale getirin:
   ```bash
   chmod +x ProxyScrapper.sh
   ```

2. **Menü Seçenekleri**:
   Betik çalıştırıldığında aşağıdaki menü görüntülenir:
   ```plaintext
   === Proxy Manager Menu ===
   1. Proxy Scraper
   2. Proxy Controller
   3. Proxy Updater
   4. Exit
   ```
   - **1**: Proxy adreslerini toplar ve `proxy_database.json` dosyasına kaydeder.
   - **2**: Toplanan proxy'leri Google üzerinden test eder ve çalışan proxy'leri işaretler.
   - **3**: Proxy listesindeki tekrar eden kayıtları kaldırır.
   - **4**: Betikten çıkış yapar.

## Örnek Kullanım

### Proxy Toplama
```plaintext
=== Proxy Manager Menu ===
1. Proxy Scraper
2. Proxy Controller
3. Proxy Updater
4. Exit
Seçiminiz: 1
Scraping proxies...
Scraping completed. Total proxies: 150
```

### Proxy Doğrulama
```plaintext
=== Proxy Manager Menu ===
1. Proxy Scraper
2. Proxy Controller
3. Proxy Updater
4. Exit
Seçiminiz: 2
Checking proxies with Google...
✓ 192.168.1.1:8080
✗ 192.168.1.2:8080
Validation complete. Working proxies: 50
```

### Proxy Güncelleme
```plaintext
=== Proxy Manager Menu ===
1. Proxy Scraper
2. Proxy Controller
3. Proxy Updater
4. Exit
Seçiminiz: 3
Removing duplicates...
Duplicates removed. Unique proxies: 100
```

## Gereksinimler

- **Bash**: Betik bir Bash ortamında çalıştırılmalıdır.
- **`curl`**: Proxy adreslerini toplamak için kullanılır.
- **`jq`**: JSON dosyalarını işlemek için kullanılır.

## Notlar

- Proxy kaynakları `SITES` dizisinde tanımlanmıştır. Yeni kaynaklar eklemek için bu listeyi düzenleyebilirsiniz.
- Proxy doğrulama işlemi sırasında Google kullanılır. Bu nedenle internet bağlantısı gereklidir.
- Proxy bilgileri `proxy_database.json` dosyasında saklanır.

## Lisans

Bu proje açık kaynaklıdır ve [MIT Lisansı](https://opensource.org/licenses/MIT) altında sunulmaktadır.

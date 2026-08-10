# treasurio-uptime-monitor

10 dakikada bir `app.treasurio.xyz` ve `treasurio.xyz`'i kontrol eder, durum değiştiğinde (down/recovered) Telegram'a mesaj atar.

## Kurulum

1. Bu repoyu GitHub'da **public** olarak oluştur (Actions dakika kotasını sıfırdan tutmak için).
2. Repo Settings → Secrets and variables → Actions → **New repository secret**:
   - `TELEGRAM_BOT_TOKEN`: BotFather'dan aldığın token
   - `TELEGRAM_CHAT_ID`: alert kanalının chat ID'si
3. Actions sekmesinden "Uptime Check" workflow'unu bul, **Run workflow** ile elle bir kere tetikle, Telegram'a mesaj düşüyor mu kontrol et.

## Chat ID nasıl bulunur

1. Botu kanala admin olarak ekle.
2. Kanalda herhangi bir mesaj paylaş.
3. Tarayıcıda şu adrese git: `https://api.telegram.org/bot<TOKEN>/getUpdates`
4. Dönen JSON'da `"chat":{"id":-100...}` şeklindeki negatif sayı, kanalın chat ID'sidir.

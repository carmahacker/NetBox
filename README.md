# NetBox

## Motivation  

Netbox предназначен как простой/минималистичный DNS-менеджер для организаций с десятками-сотнями зон, когда не нужна “вся мощь” традиционных DNS-менеджеров (ldap, php-web, etc).  

### Задачи, которые закрывает Netbox

- BIND → NetBox синхронизация + автоматизация (через SSH / API)  
- Единое “источниковое” хранилище конфигураций DNS-зон  
- История изменений, экспорт/импорт, version control  

## Возможности  

- Импорт зон из BIND (*.zone / db.*)  
- Парсинг zone-файлов, в том числе построенных вручную  
- Поддержка основных типов записей DNS: A, AAAA, CNAME, MX, NS, SOA, TXT, PTR и др.  
- HTTP API (плагин “netbox-dns”) для работы с записями и зонами  
- SSH-доступ + SFTP чтение zone-файлов — можно держать BIND на отдельном сервере  

## Установка  
```bash
curl -L -o install.sh https://raw.githubusercontent.com/carmahacker/NetBox/main/install.sh
chmod +x install.sh
sudo ./install.sh
```


```bash
git clone https://github.com/carmahacker/NetBox.git
cd NetBox
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt  # либо pip install requests paramiko
Настройка
Скопируй example.env → .env, отредактируй:

text
Копировать код
NETBOX_URL=https://your-netbox.example.com
NETBOX_TOKEN=ваш_токен

SSH_HOST=your-bind-server
SSH_USER=bindreader
SSH_KEY_PATH=/path/to/private/key
SSH_ZONES_PATH=/etc/bind/master

SYNC_SECRET_KEY=любое_секретное_слово
Запуск вручную
bash
Копировать код
./venv/bin/python3 bind_netbox_sync.py --apply --secret-key $SYNC_SECRET_KEY
Автозапуск (systemd)
Скопируй файлы:

bash
Копировать код
systemd/bind-sync.service → /etc/systemd/system/
systemd/bind-sync.timer   → /etc/systemd/system/
Затем:

bash
Копировать код
systemctl daemon-reload
systemctl enable --now bind-sync.timer
systemctl status bind-sync.timer
Для ручного запуска:

bash
Копировать код
systemctl start bind-sync.service
journalctl -u bind-sync.service -f
Лицензия
MIT

yaml
Копировать код

---

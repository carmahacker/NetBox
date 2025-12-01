# NetBox
NetBox integrations..
BIND → NetBox DNS Synchronizer

Скрипт для синхронизации DNS-зон с BIND-сервера в NetBox DNS Plugin через SSH.

Использует:

SSH + SFTP для чтения zone-файлов с удалённого BIND

парсер зон, совместимый с BIND

API NetBox DNS Plugin (создание/обновление зон и записей)

systemd timer для регулярной синхронизации

📦 Структура репозитория
bind_sync/
 ├── bind_netbox_sync.py
 ├── venv/                       # виртуальное окружение Python
 ├── certs/                      # (опционально) SSL сертификаты
 ├── .env                        # переменные окружения (не обязательно)
 ├── systemd/
 │     ├── bind-sync.service
 │     └── bind-sync.timer
 └── README.md

🚀 Установка
1. Клонировать репозиторий
cd /opt
git clone https://github.com/YOUR-ORG/bind-sync.git
cd bind-sync


(замени YOUR-ORG на свой GitHub)

2. Создать виртуальное окружение (если его нет)
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt


(если requirements.txt нет — установить основные модули)

pip install requests paramiko

3. Настроить окружение

Создай .env:

nano /opt/bind_sync/.env


Пример:

NETBOX_URL=https://odinhub-spb.pharmasyntez.com
NETBOX_TOKEN=ВАШ_ТОКЕН

SSH_HOST=ns1.pharmasyntez.com
SSH_USER=bindreader
SSH_KEY_PATH=/opt/netbox/.ssh/id_rsa
SSH_ZONES_PATH=/etc/bind/master

SYNC_SECRET_KEY=supersecret

4. Установить systemd service + timer
cp systemd/bind-sync.service /etc/systemd/system/
cp systemd/bind-sync.timer /etc/systemd/system/

systemctl daemon-reload
systemctl enable --now bind-sync.timer


Проверить:

systemctl status bind-sync.timer
systemctl list-timers --all | grep bind-sync

5. Ручной запуск
systemctl start bind-sync.service
journalctl -u bind-sync.service -n 200 -f

🛠 Возможные настройки
Изменить частоту синхронизации

В файле:

/etc/systemd/system/bind-sync.timer

Можно задать расписание, напр.:

OnCalendar=hourly


или

OnCalendar=*-*-* 00,12:00

📄 Лицензия

MIT (или любая нужная — допиши при публикации)

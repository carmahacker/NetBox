#!/bin/bash
set -e

ARCHIVE_URL="https://raw.githubusercontent.com/carmahacker/NetBox/main/bind_sync_full.tar.gz"
INSTALL_DIR="/opt/bind_sync"
SYSTEMD_DIR="/etc/systemd/system"

echo "=== BIND → NetBox Sync Installer ==="
echo "Скачиваем архив: $ARCHIVE_URL"
curl -L -o /tmp/bind_sync_full.tar.gz "$ARCHIVE_URL"

echo "Удаляем старую установку (если была)..."
rm -rf "$INSTALL_DIR"

echo "Создаём директорию /opt/bind_sync..."
mkdir -p "$INSTALL_DIR"

echo "Распаковываем архив..."
tar -xzvf /tmp/bind_sync_full.tar.gz -C /opt/

echo "Переходим в каталог..."
cd "$INSTALL_DIR"

echo "=== Создаём Python venv ==="
python3 -m venv venv

echo "Активируем venv..."
source venv/bin/activate

echo "Устанавливаем зависимости..."
if [[ -f requirements.txt ]]; then
    pip install -r requirements.txt
else
    pip install requests paramiko
fi

echo "=== Установка systemd service & timer ==="
cp systemd/bind-sync.service "$SYSTEMD_DIR/"
cp systemd/bind-sync.timer "$SYSTEMD_DIR/"

echo "Перезагружаем systemd..."
systemctl daemon-reload

echo "Включаем и запускаем таймер..."
systemctl enable --now bind-sync.timer

echo "Готово!"
echo "Проверить таймер можно командой:"
echo "  systemctl list-timers --all | grep bind-sync"
echo "Ручной запуск:"
echo "  systemctl start bind-sync.service"
echo "Логи:"
echo "  journalctl -u bind-sync.service -f"

#!/bin/bash

#--------------------------------------------------#
# Скрипт выполняет миграции в Clickhouse (создаёт БД и таблицы)
# Run: bash modules/tokenbox/bin/04-migrate.sh
#--------------------------------------------------#

TARGET_DIR=$(dirname "${BASH_SOURCE[0]}")          # Получить каталог, в котором находится запускаемый скрипт
MODULE_DIR=$(echo "$TARGET_DIR" | cut -d'/' -f-2)  # Обрезать путь до двух верхних уровней

source "$MODULE_DIR/config/clickhouse.sh"

#--------------------------------------------------#

CH_INIT_MIGRATE_SQL="$MODULE_DIR/migrations/clickhouse.sql"

clear;

time {

echo "Clickhouse migrations: create database..."
clickhouse-client --host="$CH_HOST" -u "$CH_USER" --password="$CH_PASS" --query="CREATE DATABASE IF NOT EXISTS $CH_DBNAME"

echo "Clickhouse migrations: create tables..."
while IFS= read -r line; do
    clickhouse-client --host="$CH_HOST" -u "$CH_USER" --password="$CH_PASS" --database="$CH_DBNAME" --query="$line"
done < "$CH_INIT_MIGRATE_SQL"

}

echo "Memory Usage: $(ps -o rss= -p $$) KB"
exit;


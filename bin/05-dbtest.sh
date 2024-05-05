#!/bin/bash

#--------------------------------------------------#
# Скрипт проверяет доступность БД Clickhouse
# Run: bash modules/tokenbox/bin/05-dbtest.sh
#--------------------------------------------------#

TARGET_DIR=$(dirname "${BASH_SOURCE[0]}")          # Получить каталог, в котором находится запускаемый скрипт
MODULE_DIR=$(echo "$TARGET_DIR" | cut -d'/' -f-2)  # Обрезать путь до двух верхних уровней

source "$MODULE_DIR/config/dirs.sh"
source "$MODULE_DIR/config/clickhouse.sh"

#--------------------------------------------------#

dbTest="$SRC""dbtest.php"

clear;

time {

php "$dbTest" "$CH_HOST" "$CH_USER" "$CH_PASS" "$CH_DBNAME" "$CH_PORT" "$CH_HTTPS";  # Строго соблюдаем очерёдность параметров...

}

echo "Memory Usage: $(ps -o rss= -p $$) KB"
exit;


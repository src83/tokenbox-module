#!/bin/bash

#--------------------------------------------------#
# Скрипт загружает токены из CSV в БД Clickhouse
# Run: bash modules/tokenbox/bin/06-upload.sh
#--------------------------------------------------#

TARGET_DIR=$(dirname "${BASH_SOURCE[0]}")          # Получить каталог, в котором находится запускаемый скрипт
MODULE_DIR=$(echo "$TARGET_DIR" | cut -d'/' -f-2)  # Обрезать путь до двух верхних уровней

source "$MODULE_DIR/config/dirs.sh"
source "$MODULE_DIR/config/clickhouse.sh"

#--------------------------------------------------#

L1="$DATA_CSV""data_l1.csv"
L2="$DATA_CSV""data_l2.csv"
L3="$DATA_CSV""data_l3.csv"
L4="$DATA_CSV""data_l4.csv"
L5="$DATA_CSV""data_l5.csv"
L6="$DATA_CSV""data_l6.csv"

clear;

time {

# Проверка существования файлов
for file in "$L1" "$L2" "$L3" "$L4" "$L5" "$L6"; do
    if [ ! -e "$file" ]; then
        echo "Файл $file не существует."
        exit 1
    fi
done

echo "Up 1..."
query="INSERT INTO hash_pool_v1 FORMAT CSV"
cat $L1 | clickhouse-client --host="$CH_HOST" -u "$CH_USER" --password="$CH_PASS" --database="$CH_DBNAME" --query="$query"

echo "Up 2..."
query="INSERT INTO hash_pool_v2 FORMAT CSV"
cat $L2 | clickhouse-client --host="$CH_HOST" -u "$CH_USER" --password="$CH_PASS" --database="$CH_DBNAME" --query="$query"

echo "Up 3..."
query="INSERT INTO hash_pool_v3 FORMAT CSV"
cat $L3 | clickhouse-client --host="$CH_HOST" -u "$CH_USER" --password="$CH_PASS" --database="$CH_DBNAME" --query="$query"

echo "Up 4..."
query="INSERT INTO hash_pool_v4 FORMAT CSV"
cat $L4 | clickhouse-client --host="$CH_HOST" -u "$CH_USER" --password="$CH_PASS" --database="$CH_DBNAME" --query="$query"

echo "Up 5..."
query="INSERT INTO hash_pool_v5 FORMAT CSV"
cat $L5 | clickhouse-client --host="$CH_HOST" -u "$CH_USER" --password="$CH_PASS" --database="$CH_DBNAME" --query="$query"

echo "Up 6..."
query="INSERT INTO hash_pool_v6 FORMAT CSV"
cat $L6 | clickhouse-client --host="$CH_HOST" -u "$CH_USER" --password="$CH_PASS" --database="$CH_DBNAME" --query="$query"

}

echo "Memory Usage: $(ps -o rss= -p $$) KB"
exit;


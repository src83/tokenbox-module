#!/bin/bash

#--------------------------------------------------#
# Скрипт конвертит данные токенов в CSV (для загрузки в БД)
# Run: bash modules/tokenbox/bin/03-txt2csv.sh
#--------------------------------------------------#

TARGET_DIR=$(dirname "${BASH_SOURCE[0]}")          # Получить каталог, в котором находится запускаемый скрипт
MODULE_DIR=$(echo "$TARGET_DIR" | cut -d'/' -f-2)  # Обрезать путь до двух верхних уровней

source "$MODULE_DIR/config/dirs.sh"

#--------------------------------------------------#

L1_in="$DATA_TXT""box_L1_8x8_01.txt"
L2_in="$DATA_TXT""box_L2_62x62_01.txt"
L3_in="$DATA_TXT""box_L3_485x485_01.txt"
L4_in="$DATA_TXT""box_L4_3813x3813_01.txt"
L5_in="$DATA_TXT""box_L5_5000x5000_A1.txt"
L6_in="$DATA_TXT""box_L6_5000x5000_01.txt"

L1_out="$DATA_CSV""data_l1.csv"
L2_out="$DATA_CSV""data_l2.csv"
L3_out="$DATA_CSV""data_l3.csv"
L4_out="$DATA_CSV""data_l4.csv"
L5_out="$DATA_CSV""data_l5.csv"
L6_out="$DATA_CSV""data_l6.csv"

clear;

time {

# Проверка существования файлов
for file in "$L1_in" "$L2_in" "$L3_in" "$L4_in" "$L5_in" "$L6_in"; do
    if [ ! -e "$file" ]; then
        echo "Файл $file не существует."
        exit 1
    fi
done

# Проставление номера строки в список хешей
cat -n "$L1_in" | awk '{print $1 "," $2}' > "$L1_out"
cat -n "$L2_in" | awk '{print $1 "," $2}' > "$L2_out"
cat -n "$L3_in" | awk '{print $1 "," $2}' > "$L3_out"
cat -n "$L4_in" | awk '{print $1 "," $2}' > "$L4_out"
cat -n "$L5_in" | awk '{print $1 "," $2}' > "$L5_out"
cat -n "$L6_in" | awk '{print $1 "," $2}' > "$L6_out"

}

echo "Memory Usage: $(ps -o rss= -p $$) KB"
exit;


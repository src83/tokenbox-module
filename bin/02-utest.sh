#!/bin/bash

#--------------------------------------------------#
# Скрипт проверяет наличие дублей токенов
# Run: bash modules/tokenbox/bin/02-utest.sh
#--------------------------------------------------#

TARGET_DIR=$(dirname "${BASH_SOURCE[0]}")          # Получить каталог, в котором находится запускаемый скрипт
MODULE_DIR=$(echo "$TARGET_DIR" | cut -d'/' -f-2)  # Обрезать путь до двух верхних уровней

source "$MODULE_DIR/config/dirs.sh"

#--------------------------------------------------#

clear;

time {

files=(
    "$DATA_TXT""box_L1_8x8_01.txt"
    "$DATA_TXT""box_L2_62x62_01.txt"
    "$DATA_TXT""box_L3_485x485_01.txt"
    "$DATA_TXT""box_L4_3813x3813_01.txt"
    "$DATA_TXT""box_L5_5000x5000_A1.txt"
    "$DATA_TXT""box_L6_5000x5000_01.txt"
)

# Проверка существования файлов
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "Файл $file не существует."
        exit 1
    fi
done

for file in "${files[@]}"; do
    if [ "$(sort -u "$file" | wc -l)" -eq "$(wc -l < "$file")" ]; then
        echo "$file: Дубликатов строк в файле нет."
    else
        echo "$file: Обнаружены дубликаты строк в файле."
    fi
done

}

echo "Memory Usage: $(ps -o rss= -p $$) KB"
exit;


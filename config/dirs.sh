#!/bin/bash

TARGET_DIR=$(dirname "${BASH_SOURCE[0]}")          # Получить каталог, в котором находится запускаемый скрипт
MODULE_DIR=$(echo "$TARGET_DIR" | cut -d'/' -f-2)  # Обрезать путь до двух верхних уровней

export DATA_TXT=$MODULE_DIR/data/txt/
export DATA_CSV=$MODULE_DIR/data/csv/

export SRC=$MODULE_DIR/src/

# Tokenbox Module

## О проекте

Данный пакет - модуль, предназначенный для работы в составе отдельного целевого проекта. 
Он является учебным, но вполне может применяться и для использования на production среде.
Единственная его цель - сгенерировать 1 млрд уникальных, хорошо перемешанных токенов и загрузить их в БД ClickHouse.

В проекте могут встречаться недоработанные части кода, места, которые можно улучшить и оптимизировать, незавершённые
реализации (например, тесты), что является допустимым, поскольку упор делается на возможность быстрого решения
основной задачи.

Текущая реализация исправна и протестирована. В среднем, на весь цикл уходит примерно 25 минут. Упаковка токенов реализована
через открытую библиотеку Base62. Для ознакомления с библиотекой ниже описан пример утилиты "Калькулятор".
Также, есть и описание непосредственно работы с токенами.

**P.S.** Проект выполнен на базе Docker-сборки из соседнего репозитория: https://github.com/src83/docker

Предполагается, что есть, по крайней мере запущенный контейнер с PHP и отдельно с ClickHouse.

В проекте используется ядро, подключаемое к целевому проекту, как зависимость и внешний репозиторий: https://github.com/src83/tokenbox-core


## Текущая структура папок модуля
```bash
ProjectRootFolder
└─ modules
   └─ tokenbox
      ├─ bin
      ├─ config
      ├─ data
      │  ├─ csv
      │  └─ txt
      ├─ migrations
      └─ src
```
**ProjectRootFolder** - это **корневая** папка вашего целевого проекта, например, на базе фреймворка Laravel.


## Требования и зависимости
Данный модуль работает в составе проекта, который в своих зависимостях использует библиотеку из внешнего репозитория: https://github.com/src83/tokenbox-core
Поэтому её необходимо подключить к проекту. Ниже описано как это сделать.


## Установка

1. Склонировать модуль и разместить его, как описано в разделе "Текущая структура папок" (см.выше).
```bash
git clone git@github.com:src83/tokenbox-module.git
```
Важно, что папку .git модуля в целевой проект переносить не нужно! Также, важно то, что вся структура модуля в кодовую
базу проекта не попадает и git-ом не отслеживается. По крайней мере пока что.

2. В файле `.gitignore` целевого проекта добавить строчку `/modules`

3. В папке `config` (в **модуле** tokenbox):
   * указать нужные креды в `clickhouse.sh`
   * проверить пути в `dirs.sh`, `dirs.php`

4. Убедиться, что в целевом проекте установлена библиотека в виде зависимости, как описано здесь: https://github.com/src83/tokenbox-core#установка


## Запуск

#### ! Все команды выполняем в PHP-контейнере из корня проекта...

#### Для начала работы с токенами нужно убедиться, что библиотека tokenbox-core и данный модуль подключены и доступны. 
Воспользуемся следующей утилитой... **Калькулятор** - тестовая утилита для конвертации из одних систем счисления в другие в диапазоне [0 - 62].

### 1. Общий случай (для справки)
```bash
php modules/tokenbox/src/calc.php <from> <to> <value> [--stat]
```
"from" и "to" - номера систем счисления (от 2 до 62).

"--stat" - опциональный ключ для вывода статистики.

### 2. Перевод с 10й в 62ю систему счисления:
```bash
php modules/tokenbox/src/calc.php 10 62 100000
```
Ответ: q0U

### 3. Перевод с 62й в 10ю систему счисления:
```bash
php modules/tokenbox/src/calc.php 62 10 16LAzd
```
Ответ: 1016132831

Если всё работает - переходим к основной части...



## Генерация токенов и наполнение базы (по шагам):

#### ! Все команды выполняем в PHP-контейнере из корня проекта...

### 1. Инициализация проекта
```bash
bash modules/tokenbox/bin/00-init.sh
```
Результат: создание папок "data/txt", "data/csv".
Время: ~0 min


### 2. Запуск генерации токенов
```bash
bash modules/tokenbox/bin/01-generator.sh
```
Результат: выходные файлы с токенами появится в папке "data/txt".
Время: ~18 min


### 2.1. Проверка наличия дубликатов в итоговых файлах (опционально)
```bash
bash modules/tokenbox/bin/02-utest.sh
```
Результат: общая информация о факте нахождения дубликатов в консоли.
Время: ~12 min


### 3. Перевод токенов из txt в csv (для загрузки в ClickHouse)
```bash
bash modules/tokenbox/bin/03-txt2csv.sh
```
Результат: выходные файлы с токенами появится в папке "data/csv".
Время: ~5 min


### 4. Выполнение миграций
```bash
bash modules/tokenbox/bin/04-migrate.sh
```
Результат: В БД Clickhouse появится база и пустые таблицы
Время: ~0 min


### 5. Проверка доступности базы
```bash
bash modules/tokenbox/bin/05-dbtest.sh
```
Результат: Статус подключения в виде строки в консоли.
Время: ~0 min


### 6. Загрузка данных в БД ClickHouse:
```bash
bash modules/tokenbox/bin/06-upload.sh
```
Результат: Загруженные токены в таблицы ClickHouse.
Время: ~2.5 min


### 7. Удаление с диска токенов в виде txt и csv (опционально)
Удаление txt:
```bash
rm modules/tokenbox/data/txt/*
```
Удаление csv:
```bash
rm modules/tokenbox/data/csv/*
```


## Unit-тесты:
```bash
clear; vendor/bin/phpunit --testdox vendor/src83/tokenbox-core/tests --colors
```


## Дополнительно:

### 1. Немного теории (расчёты диапазонов)

Таблица диапазонов токенов:
* Ёмкость диапазона равна длине токена.
* Колонке "Capacity" - количество токенов в диапазоне.

```
======================================================================================================================
I | Pow  | Maxs offset |      Ranges [10]       |   Ranges [62]   | Capacity  | Side   |    Side^2 | cutoff | offset
---+------+-------------+------------------------+-----------------+-----------+--------+-----------+--------+--------
1 | 62^1 |          62 |         0 -         61 |      0 -      Z |        62 |      8 |        64 |      2 | 0
2 | 62^2 |        3844 |        62 -       3843 |     10 -     ZZ |      3782 |   base |      3844 |   base | base^1
3 | 62^3 |      238328 |      3844 -     238327 |    100 -    ZZZ |    234484 |    485 |    235225 |    741 | base^2
4 | 62^4 |    14776336 |    238328 -   14776335 |   1000 -   ZZZZ |  14538008 |   3813 |  14538969 |    961 | base^3
5 | 62^5 |   916132832 |  14776336 -  916132831 |  10000 -  ZZZZZ | 901356496 |  30023 | 901380529 |  24033 | base^4
6 | 62^6 | 56800235584 | 916132832 - 1000000000 | 100000 - 15FTGg |  83867168 |   9158 |  83868964 |   1796 | base^5
======================================================================================================================
```


### 2. Проверка кода на соответствие PSR-12 (codeStyle)
Проверка:
```bash
clear; vendor/bin/php-cs-fixer -vvv check modules/tokenbox/src
clear; vendor/bin/php-cs-fixer -vvv check vendor/src83/tokenbox-core
```

Исправления:
```bash
clear; vendor/bin/php-cs-fixer -vvv fix modules/tokenbox/src
clear; vendor/bin/php-cs-fixer -vvv fix vendor/src83/tokenbox-core
```

### 3. Оценки времени - приблизительны
Оценочное время выполнения скриптов приводится исходя из производительности того ПК, на котором они выполнялись.
В данном случае, это был ноут с 12 ядрами CPU 3GHz, 16Gb Mem. В ином случае эти показатели могут отличаться в любую сторону.

----------------------------------------------------------------------------------------------------------------------

# sambada
Linux samba-server + windows clients

# Docker
Use [dperson/samba](https://github.com/dperson/samba) docker image to run samba server within docker container.

## Запуск докера
```
./run-docker.sh -u samba_user_name -p samba_user_password -d dir1=net_dir1,dir2=net_dir2,dir3=net_dir3
```

# Windows

## Адрес серевера
Добавляем в конец файла ***C:\windows\system32\drivers\etc\hosts*** строку:
```
192.168.0.123 cubix # <адрес в локальной сети> <имя хоста>
```

## Подключаем сетевую папку через консоль
```
net use \\cubix\bob1 /u:samba_user_name
```
тут нужно ответить на запрос пароля вбиванием ***<samba_user_password>***

## Подключаем сетевой диск через Мой Компьютер

1. Правой кнопкой мыши на ***Мой компьютер*** и выбираем ***Подключить сетевой диск***
1. Диск: выбираем любимую букву для обозначения сетевого диска
1. Папка: вбиваем адрес удалённого каталога ***\\cubix\bob1***
1. Отмечаем галочками пункты ***Восстанавливать при входе в систему*** и ***Использовать другие учётные данные***
1. Окаем
1. Вводим имя сетевого пользователя и пароль - те самые ***<samba_user_name>*** и ***<samba_user_password>***
1. Отмечаем галочкой ***Запомнить учётные данные***
1. Окаем

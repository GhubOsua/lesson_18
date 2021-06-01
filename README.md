# Урок 18. Docker

## 1. Задание №1. Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx);

### 1.1 Установка Docker, согласно https://docs.docker.com/engine/install/centos/;
yum install -y yum-utils
yum install docker-ce docker-ce-cli containerd.io
systemctl start docker

### 1.2 Сборка Docker контейнера на основе Dockerfile и с index.html;
```
docker build -t osua/lesson18dockernginx:alpine_ver1 .
```
### 1.3 После успешной сборки, запускаем контейнер;
```
[root@lesson18 tmp]# docker image ls
REPOSITORY                 TAG           IMAGE ID       CREATED          SIZE
osua/lesson18dockernginx   alpine_ver1   2875bf2678c6   15 seconds ago   14.4MB
alpine                     latest        6dbb9cc54074   6 weeks ago      5.61MB

[root@lesson18 tmp]# docker run -d -p 80:8080 osua/lesson18dockernginx:alpine_ver1
45ad8701f51f7920a89ba4796078036ab1636a74363ce61aed2811f4ad85c51d

[root@lesson18 ~]# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                         NAMES
60a0eec68a9a   2875bf2678c6   "nginx -g 'daemon of…"   16 minutes ago   Up 16 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp, 8080/tcp   hungry_bartik

[root@lesson18 ~]# curl localhost
Otus. Task 18. Docker-Aplpine.
Очень мало практики. очень жаль :((((((
[root@lesson18 ~]# 
```

### 1.4 Выложить собранный образ в docker hub. Вход в docker hub выполняется с помощью команды docker login;
```
[root@lesson18 ~]# docker tag 2875bf2678c6 ghubosua/lesson18dockernginx:ver3
[root@lesson18 ~]# docker image ls 
REPOSITORY                          TAG           IMAGE ID       CREATED        SIZE
ghubosua/lesson18dockernginx        ver3          2875bf2678c6   25 hours ago   14.4MB
ghubosua/osua/lesson18dockernginx   ver2          2875bf2678c6   25 hours ago   14.4MB
osua/lesson18dockernginx            alpine_ver1   2875bf2678c6   25 hours ago   14.4MB
alpine                              latest        6dbb9cc54074   6 weeks ago    5.61MB
[root@lesson18 ~]# docker push ghubosua/lesson18dockernginx:ver3
The push refers to repository [docker.io/ghubosua/lesson18dockernginx]
34b968b72c2b: Pushed 
1302a0d5e446: Pushed 
036b98a7c6e9: Pushed 
b2d5eeeaba3a: Pushed 
ver3: digest: sha256:539e3eb1ddbaa6b04bb3daaa09b03023409aed3ee3aa68fc85aac3b36475ee0b size: 1157
```
Ссылка на репозиторий - https://hub.docker.com/r/ghubosua/lesson18dockernginx

## 2. Определите разницу между контейнером и образом;
Образ - на основе чего создается контейнер, это множество слоев для чтения. Образы создаются на основе Dockerfile с помощью команды docker build. Docker образы находятся на Docker hub.
Контейнер - верхний слой, который доступен для записи. Образ набор слоев, которые можно описать, может быть много контейнеро на одном образе. Чтобы создать контейнер, движок Docker берет образ, добавляет доступный для записи верхний слой и инициализирует различные параметры (сетевые порты, имя контейнера, идентификатор и лимиты ресурсов). Контейнеры создаются из образов с помощью команды docker run, а выполнив команду docker ps можно узнать какие контейнеры в данный момент запущены. Несколько контейнеров могут использоваться один и тотже образ, но быть каждый в своем состоянии. 

## 3. Можно ли собрать ядро в docker. Да можно - https://itnan.ru/post.php?c=1&p=331938. В файле Dockerfile идет сборка nginx;

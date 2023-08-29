# transmission

[![Build transmission image](https://github.com/DDS-Derek/transmission-Docker/actions/workflows/docker.yml/badge.svg)](https://github.com/DDS-Derek/transmission-Docker/actions/workflows/docker.yml)[![Docker Hub Description](https://github.com/DDS-Derek/transmission-Docker/actions/workflows/docker-Hub-Description.yml/badge.svg)](https://github.com/DDS-Derek/transmission-Docker/actions/workflows/docker-Hub-Description.yml)

## 部署

### docker-compose
```
version: "2.1"
services:
  transmission:
    image: ddsderek/transmission:latest
    container_name: transmission
    environment:
      - PUID=1000
      - PGID=1000
      - UMASK=022
      - TZ=Asia/Shanghai
      - USER=username #optional
      - PASS=password #optional
      - WHITELIST=iplist #optional
      - PEERPORT=peerport #optional
      - PRCPORT=rpcport #optional
      - HOST_WHITELIST=dnsname list #optional
      - TRANSMISSION_WEB_HOME=/transmission-web-control/
      - DOWNLOAD_DIR=/downloads #optional
    volumes:
      - /path/to/data:/config
      - /path/to/downloads:/downloads
      - /path/to/watch/folder:/watch
    ports:
      - 9091:9091
      - 51413:51413
      - 51413:51413/udp
    restart: unless-stopped
```
#### docker-cli
```
docker run -d \
  --name=transmission \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=022 \
  -e TZ=Asia/Shanghai \
  -e USER=username `#optional` \
  -e PASS=password `#optional` \
  -e WHITELIST=iplist `#optional` \
  -e PRCPORT=rpcport `#optional` \
  -e PEERPORT=peerport `#optional` \
  -e HOST_WHITELIST=dnsname list `#optional` \
  -e TRANSMISSION_WEB_HOME=/transmission-web-control/ `#optional` \
  -e DOWNLOAD_DIR=/downloads `#optional` \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /path/to/data:/config \
  -v /path/to/downloads:/downloads \
  -v /path/to/watch/folder:/watch \
  --restart unless-stopped \
  ddsderek/transmission:latest
```

## 参数

|                  **Parameter**                  |                         **Function**                         |
| :---------------------------------------------: | :----------------------------------------------------------: |
|                    `-p 9091`                    |                           网页界面                           |
|                   `-p 51413`                    |                         种子端口 TCP                         |
|                 `-p 51413/udp`                  |                       Torrent 端口 UDP                       |
|                 `-e PUID=1000`                  |               对于 User ID - 请参阅上面的说明                |
|                 `-e PGID=1000`                  |               对于 GroupID - 请参阅上面的说明                |
|                 `-e UMASK=022`                  |               对于 UMASK - 请参阅上面的说明                |
|              `-e TZ=Asia/Shanghai`              |                        指定时区以使用                        |
|               `-e USER=username`                |                     指定接口的可选用户名                     |
|               `-e PASS=password`                |                      指定接口的可选密码                      |
|              `-e WHITELIST=iplist`              | 指定逗号分隔的 ip 白名单的可选列表。填写 rpc-whitelist 设置。 |
|             `-e PRCPORT=rpcport`                | 为 web rpc 连接指定一个可选端口。填充对等端口设置。  |
|             `-e PEERPORT=peerport`              | 为 torrent TCP/UDP 连接指定一个可选端口。填充对等端口设置。  |
|        `-e HOST_WHITELIST=dnsname list`         | 指定逗号分隔的 dns 名称白名单的可选列表。填写 rpc-host-whitelist 设置。 |
|        `-e TRANSMISSION_WEB_HOME=/transmission-web-control/`         | 设置 Web UI 界面 可选 `/transmission-web-control/` `/transmissionic/` `/combustion/` `/kettu/` `/flood/` |
|        ```-e DOWNLOAD_DIR=/downloads```         | 下载目录，默认```/downloads```，如果此处更改，`-v /downloads`也要更改为你更改后的下载路径 |
|                  `-v /config`                   |               传输应存储配置文件和日志的位置。               |
|                 `-v /downloads`                 |                        本地下载路径。                        |
|                   `-v /watch`                   |                 监视 torrent 文件的文件夹。                  |

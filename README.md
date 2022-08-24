# transmission

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
      - TZ=Europe/London
      - TRANSMISSION_WEB_HOME=/combustion-release/ #optional
      - USER=username #optional
      - PASS=password #optional
      - WHITELIST=iplist #optional
      - PEERPORT=peerport #optional
      - HOST_WHITELIST=dnsname list #optional
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
  -e TZ=Europe/London \
  -e TRANSMISSION_WEB_HOME=/combustion-release/ `#optional` \
  -e USER=username `#optional` \
  -e PASS=password `#optional` \
  -e WHITELIST=iplist `#optional` \
  -e PEERPORT=peerport `#optional` \
  -e HOST_WHITELIST=dnsname list `#optional` \
  -e DOWNLOAD_DIR=/downloads #optional \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /path/to/data:/config \
  -v /path/to/downloads:/downloads \
  -v /path/to/watch/folder:/watch \
  --restart unless-stopped \
  ddsderek/transmission:latest
```

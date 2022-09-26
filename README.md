# docker-bf2

[![github-actions](https://github.com/startersclan/docker-bf2/workflows/ci-master-pr/badge.svg)](https://github.com/startersclan/docker-bf2/actions)
[![github-release](https://img.shields.io/github/v/release/startersclan/docker-bf2?style=flat-square)](https://github.com/startersclan/docker-bf2/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/startersclan/docker-bf2/latest)](https://hub.docker.com/r/startersclan/docker-bf2)

Dockerized [Battlefield 2 Server](https://www.ea.com/games/battlefield/battlefield-2).

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:v1.5.3153.0`, `:latest` | [View](variants/v1.5.3153.0 ) |
| `:v1.5.3153.0-bf2hub` | [View](variants/v1.5.3153.0-bf2hub ) |
| `:v1.5.3153.0-bf2stats` | [View](variants/v1.5.3153.0-bf2stats ) |
| `:v1.5.3153.0-fh2-4.6.304` | [View](variants/v1.5.3153.0-fh2-4.6.304 ) |

## Usage

```sh
# By using this image, you agree to the licenses
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/eula.txt # EULA for the BF2 dedicated Linux server
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/lgpl.txt # LGPL
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/pb_eula.txt # EULA for the EULA for PunkBuster

# Read server readme
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/readme-linux.txt # Linux
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/readmeserver.txt # Windows

# Run server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0 /server/bf2/start.sh
67/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0 /server/bf2/start.sh

# Run server with custom configs
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con:ro \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con:ro \
    startersclan/docker-bf2:v1.5.3153.0

# Run server with bf2stats
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con \
    -v BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats

# Run fh2 server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/fh2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/fh2/settings/maplist.con \
    startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304
```

## Links

- https://www.bf-games.net/downloads/category/153/serverfiles.html
- https://bf2hub.com
- https://code.google.com/archive/p/bf2stats/
- http://www.forgottenhope.warumdarum.de
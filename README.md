# docker-bf2

[![github-actions](https://github.com/startersclan/docker-bf2/workflows/ci-master-pr/badge.svg)](https://github.com/startersclan/docker-bf2/actions)
[![github-release](https://img.shields.io/github/v/release/startersclan/docker-bf2?style=flat-square)](https://github.com/startersclan/docker-bf2/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/startersclan/docker-bf2/latest)](https://hub.docker.com/r/startersclan/docker-bf2)

Dockerized [Battlefield 2 Server](https://www.ea.com/games/battlefield/battlefield-2).

## Tags

- `bf2stats` - Battlefield 2 with support for private statistics using [bf2statistics](https://code.google.com/archive/p/bf2stats/) python files to send stats snapshots to a webserver at the end of each map. Must be paired [ASP](https://github.com/BF2Statistics/ASP) webserver that receives stats snapshots.
- `bf2hub` -  Battlefield 2 with support for [BF2Hub.com](https://www.bf2hub.com/home/serversetup.php) statistics.
- `esai` - Battlefield 2 with [Enhanced Strategic AI](https://www.moddb.com/mods/esai-enhanced-strategic-ai)
- `fh2` - Battlefield 2 with [Forgotten Hope 2](http://www.forgottenhope.warumdarum.de) mod

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:v1.5.3153.0`, `:latest` | [View](variants/v1.5.3153.0 ) |
| `:v1.5.3153.0-bf2hub` | [View](variants/v1.5.3153.0-bf2hub ) |
| `:v1.5.3153.0-bf2stats` | [View](variants/v1.5.3153.0-bf2stats ) |
| `:v1.5.3153.0-esai-v4.2` | [View](variants/v1.5.3153.0-esai-v4.2 ) |
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

# Run server with ESAI. Optimized ESAI strategies applied to all levels in entrypoint
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/fh2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/fh2/settings/maplist.con \
    --entrypoint /bin/bash \
    startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 \
    -c "esai-helper apply -f /esai-optimized-strategies-bf2.txt && cd /server/bf2 && exec ./start.sh"

# Run fh2 server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/fh2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/fh2/settings/maplist.con \
    startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304
```

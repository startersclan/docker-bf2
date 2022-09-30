# docker-bf2

[![github-actions](https://github.com/startersclan/docker-bf2/workflows/ci-master-pr/badge.svg)](https://github.com/startersclan/docker-bf2/actions)
[![github-release](https://img.shields.io/github/v/release/startersclan/docker-bf2?style=flat-square)](https://github.com/startersclan/docker-bf2/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/startersclan/docker-bf2/latest)](https://hub.docker.com/r/startersclan/docker-bf2)

Dockerized [Battlefield 2 Server](https://www.ea.com/games/battlefield/battlefield-2).

## Tags

All images contain [`Battlefield 2 Server 1.50`](https://www.bf-games.net/downloads/category/153/serverfiles.html), and include [Enhanced Strategic AI (ESAI)](https://www.moddb.com/mods/esai-enhanced-strategic-ai), which may be activated if needed.

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:v1.5.3153.0`, `:latest` | [View](variants/v1.5.3153.0 ) |
| `:v1.5.3153.0-bf2hub` | [View](variants/v1.5.3153.0-bf2hub ) |
| `:v1.5.3153.0-bf2stats-2.2.0` | [View](variants/v1.5.3153.0-bf2stats-2.2.0 ) |
| `:v1.5.3153.0-bf2stats-3.1.0` | [View](variants/v1.5.3153.0-bf2stats-3.1.0 ) |
| `:v1.5.3153.0-fh2-4.6.304` | [View](variants/v1.5.3153.0-fh2-4.6.304 ) |

- `bf2hub` - Support for [bf2hub.com](https://www.bf2hub.com/home/serversetup.php) statistics.
- `bf2stats-2.2.0` - Includes [bf2statistics](https://code.google.com/archive/p/bf2stats/) v2 python files to send stats snapshots to a webserver at the end of each map. Must be paired [ASP](https://github.com/BF2Statistics/ASP) v2 webserver. See [here](https://github.com/startersclan/bf2stats) for a fully dockerized stack example.
- `bf2stats-3.1.0` - Includes [bf2statistics](https://github.com/BF2Statistics/StatsPython) v3 python files to send stats snapshots to a webserver at the end of each map. Must be paired [ASP](https://github.com/BF2Statistics/ASP) v3 webserver. See [here](https://github.com/startersclan/ASP) for a dockerized ASP.
- `fh2` - [Forgotten Hope 2](http://www.forgottenhope.warumdarum.de) mod

## Usage

```sh
# bf2 server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0

# bf2 server with custom configs
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con:ro \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con:ro \
    startersclan/docker-bf2:v1.5.3153.0

# bf2 server with bf2stats 2.2.0 python files.
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con \
    -v BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.2.0

# bf2 server with bf2stats 3.1.0
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con \
    -v BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-3.1.0

# bf2 server with bf2hub support
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con \
    -v BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro \
    startersclan/docker-bf2:v1.5.3153.0-bf2hub

# fh2 server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/fh2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/fh2/settings/maplist.con \
    startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304

# Read server readme
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/readme-linux.txt # Linux
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/readmeserver.txt # Windows

# By using this image, you agree to the licenses
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/eula.txt # EULA for the BF2 dedicated Linux server
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/lgpl.txt # LGPL
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/pb_eula.txt # EULA for the EULA for PunkBuster
```

## ESAI

ESAI greatly enhances bot performance, and is compatible with any BF2 mod. It is included but not enabled by default.

[`esai-helper`](vendor/esai-helper) is included to manage ESAI strategies for levels.

Optimized strategies config files [``/esai-optimized-strategies-bf2.txt``](vendor/esai-optimized-strategies-bf2.txt) and [``/esai-optimized-strategies-xpack.txt``](vendor/esai-optimized-strategies-xpack.txt) are included. These strategies have been optimized by the BF2SP64 community.

To apply the included optimized ESAI strategies:

```sh
# Run server with custom configs, and optimized ESAI strategies
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con:ro \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con:ro \
    --entrypoint /bin/bash \
    startersclan/docker-bf2:v1.5.3153.0 \
    -c "esai-helper apply -f /esai-optimized-strategies-bf2.txt && cd /server/bf2 && exec ./start.sh"
```

To apply custom ESAI strategies, mount the custom config:

```sh
# bf2 server
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 get gamemodes > strategies.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod xpack get gamemodes >> strategies.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 get strategies # Get all available strategies
vi strategies.txt # Add <strategy> to each entry
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/fh2/settings/serversettings.con:ro \
    -v maplist.con:/server/bf2/mods/fh2/settings/maplist.con:ro \
    -v strategies.txt:/strategies.txt:ro \
    --entrypoint /bin/bash \
    startersclan/docker-bf2:v1.5.3153.0 \
    -c "esai-helper apply -f /strategies.txt && cd /server/bf2 && exec ./start.sh"

# fh2 server
docker run --rm startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 esai-helper --mod fh2 get gamemodes > strategies.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 esai-helper --mod fh2 get strategies # Get all available strategies
vi strategies.txt # Add <strategy> field to each entry
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/fh2/settings/serversettings.con:ro \
    -v maplist.con:/server/bf2/mods/fh2/settings/maplist.con:ro \
    -v strategies.txt:/strategies.txt:ro \
    --entrypoint /bin/bash \
    startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 \
    -c "esai-helper apply -f /strategies.txt && cd /server/bf2 && exec ./start.sh"
```
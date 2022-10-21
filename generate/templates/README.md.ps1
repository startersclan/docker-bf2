@"
# docker-bf2

[![github-actions](https://github.com/startersclan/docker-bf2/workflows/ci-master-pr/badge.svg)](https://github.com/startersclan/docker-bf2/actions)
[![github-release](https://img.shields.io/github/v/release/startersclan/docker-bf2?style=flat-square)](https://github.com/startersclan/docker-bf2/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/startersclan/docker-bf2/latest)](https://hub.docker.com/r/startersclan/docker-bf2)

Dockerized [Battlefield 2 Server](https://www.ea.com/games/battlefield/battlefield-2).

## Tags

All images contain [``Battlefield 2 Server 1.50``](https://www.bf-games.net/downloads/category/153/serverfiles.html), and include [Enhanced Strategic AI (ESAI)](https://www.moddb.com/mods/esai-enhanced-strategic-ai), which may be activated if needed.

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
$(
($VARIANTS | % {
    if ( $_['tag_as_latest'] ) {
@"
| ``:$( $_['tag'] )``, ``:latest`` | [View](variants/$( $_['tag'] ) ) |

"@
    }else {
@"
| ``:$( $_['tag'] )`` | [View](variants/$( $_['tag'] ) ) |

"@
    }
}) -join ''
)
- ``bf2hub`` - Includes [BF2Hub](https://www.bf2hub.com/home/serversetup.php) server binaries.
- ``bf2stats-2.3.3`` - Includes [BF2Statistics](https://github.com/startersclan/bf2stats) 2 python files to send stats snapshots to the [ASP](https://github.com/startersclan/bf2stats) v2 webserver. See [here](https://github.com/startersclan/bf2stats) for a fully dockerized example.
- ``bf2stats-3.1.1`` - Includes [BF2Statistics](https://github.com/startersclan/StatsPython) 3 python files to send stats snapshots to the [ASP](https://github.com/startersclan/ASP) v3 webserver. See [here](https://github.com/startersclan/ASP) for a fully dockerized example.
- ``fh2`` - [Forgotten Hope 2](http://www.forgottenhope.warumdarum.de) mod


"@

@'
## Usage

See [here](docs/examples) for some good examples.

```sh
# bf2 server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0

# bf2 server with custom configs
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con:ro \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con:ro \
    startersclan/docker-bf2:v1.5.3153.0

# bf2 server with bf2hub support
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-bf2hub

# bf2 server with bf2stats 2 python files and custom configs
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con \
    -v BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.3.3

# bf2 server with bf2stats 3 python files and custom configs
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con \
    -v BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-3.1.0

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

A handy tool called [`esai-helper`](vendor/esai-helper) is included in all images. It can be used to generate maplists for a mod, list gamemodes, list a levels' `strategies.ai`, apply custom `strategies.ai` to levels, and more. See `esai-helper --help` for usage.

To use a default strategy for all levels, see [this example](docs/examples/v1.5-esai-default-strategy/).

To override the default strategy with a level-specific strategy, optimized strategies config files [``/esai-optimized-strategies-bf2.txt``](vendor/esai-optimized-strategies-bf2.txt) and [``/esai-optimized-strategies-xpack.txt``](vendor/esai-optimized-strategies-xpack.txt) are included in each image. These strategies have been optimized by the BF2SP64 community.

To use optimized strategies for levels, see [this example](docs/examples/v1.5-esai-optimized-strategies/).

To use custom strategies for levels, see [example](docs/examples/v1.5-esai-custom-strategies/).

'@


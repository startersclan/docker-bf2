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
| `:v1.5.3153.0-bf2all64` | [View](variants/v1.5.3153.0-bf2all64 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-2.2.0` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-2.2.0 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-2.4.1` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-2.4.1 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-3.1.1` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-3.1.1 ) |
| `:v1.5.3153.0-bf2hub` | [View](variants/v1.5.3153.0-bf2hub ) |
| `:v1.5.3153.0-bf2stats-2.2.0` | [View](variants/v1.5.3153.0-bf2stats-2.2.0 ) |
| `:v1.5.3153.0-bf2stats-2.4.1` | [View](variants/v1.5.3153.0-bf2stats-2.4.1 ) |
| `:v1.5.3153.0-bf2stats-3.1.1` | [View](variants/v1.5.3153.0-bf2stats-3.1.1 ) |
| `:v1.5.3153.0-fh2-4.6.304` | [View](variants/v1.5.3153.0-fh2-4.6.304 ) |

- `bf2all64` - [BF2All64](https://www.bf-games.net/downloads/2533/bf2-singleplayer-all-in-one-package.html) mod.
- `bf2hub` - Includes [BF2Hub](https://www.bf2hub.com/home/serversetup.php) server binaries.
- `bf2stats-2.4.1` - Includes [BF2Statistics](https://github.com/startersclan/bf2stats) 2 python files to send stats snapshots to the [ASP](https://github.com/startersclan/bf2stats) v2 webserver. See [here](https://github.com/startersclan/bf2stats) for a fully dockerized example.
- `bf2stats-3.1.1` - Includes [BF2Statistics](https://github.com/startersclan/StatsPython) 3 python files to send stats snapshots to the [ASP](https://github.com/startersclan/ASP) v3 webserver. See [here](https://github.com/startersclan/ASP) for a fully dockerized example.
- `fh2` - [Forgotten Hope 2](http://www.forgottenhope.warumdarum.de) mod

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

# bf2 server with bf2all64 mod
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-bf2all64

# bf2 server with bf2hub support
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-bf2hub

# bf2 server with bf2stats 2 python files and custom configs
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con \
    -v maplist.con:/server/bf2/mods/bf2/settings/maplist.con \
    -v BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.4.1

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

A handy tool called [`esai-helper`](vendor/esai-helper) is included in all images. It can be used to list gamemodes, generate maplists for a mod, list a levels' `strategies.ai`, apply default or custom `strategies.ai` to levels, and more. See `esai-helper --help` for usage.

To use a default strategy for all levels, see [this example](docs/examples/v1.5-esai-default-strategy/).

To override the default strategy with a level-specific strategy, optimized strategies config files are included in each image. These strategies have been optimized by the BF2SP64 community:
- [`/esai-optimized-strategies-bf2.txt`](vendor/esai-optimized-strategies-bf2.txt)
- [`/esai-optimized-strategies-bf2all64.txt`](vendor/esai-optimized-strategies-bf2all64.txt)
- [`/esai-optimized-strategies-xpack.txt`](vendor/esai-optimized-strategies-xpack.txt)

To use optimized strategies for levels, see [this example](docs/examples/v1.5-esai-optimized-strategies/). For `bf2all64` mod, see [this example](docs/examples/v1.5-bf2all64-esai-optimized-strategies/).

To use custom strategies for levels, see [example](docs/examples/v1.5-esai-custom-strategies/).

```sh
# Read ESAI readmes
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/readme.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/directory.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/docs/credits.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat "/server/bf2/mods/bf2/esai/docs/quick start.txt"
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat "/server/bf2/mods/bf2/esai/docs/users guide.txt"
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/docs/version.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/mapfiles/dir.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/plugin/dir.txt

# esai-helper useful one-liners
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --help # See usage
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 get gamemodes # Get gamemodes
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 get levels # Get levels
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 get maplist # Generate a maplist for maplist.con
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 get mods # Get mods
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 get strategies # Get strategies
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 apply default-strategy <strategy> # Apply a default strategy
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 apply <level> <gamemode> <size> <strategy> # Apply a strategy for a level
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 delete <level> <gamemode> <size> <strategy> # Delete a strategy for a level
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 apply -f strategies.txt # Apply strategies for levels
docker run --rm startersclan/docker-bf2:v1.5.3153.0 esai-helper --mod bf2 delete -f strategies.txt # Delete strategies for levels
```

## FAQ

### Q: Server not listed on master server

A: Ensure you spoof Gamespy DNS for the gameserver. See [this example](docs/examples/v1.5-bf2hub-spoofed).

In addition, the gameserver lists its info on master server based on the `sv.serverPort` and `sv.gameSpyPort` in `serversettings.con`. If you are running on non-standard ports instead of the standard gameserver ports UDP `16567` and UDP `29900`, you need to use those ports in `docker-compose.yml` and `serversettings.con`.

### Q: Server not listed on master server after `docker-compose down && docker-compose up`

A: This is caused by stale UDP conntrack entries which are not deleted up by `docker` on container teardown. See [this issue](https://github.com/moby/moby/issues/8795).

The solution is to run a sidecar container that deletes the stale UDP conntrack entries on BF2 container startup, see [this example](docs/examples/delete-udp-conntrack). Alternatively, a sidecar `init-container` can achieve the same result, see [this example](docs/examples/v1.5-with-delete-udp-conntrack). Alternatively, run on host networking (i.e. `network_mode: host` in docker-compose.yml) to avoid SNAT completely, but that is not advised because it defeats the purpose of containerization.

To illustate the details:

```sh
# Start BF2 server
$ docker-compose up
$ sleep 10

# Get UDP conntrack entries
# 91.51.181.102:27900 is BF2Hub master server
# 91.51.181.102:29910 is BF2Hub cdkey server
# 91.51.149.13 is the BF2Hub master listing server
# 192.168.1.100 is our host machine's IP address
# 172.17.48.2:29900 is the bf2 container's IP address and gamespy port
# 1st line: On init, the BF2 server talks to the BF2Hub master server and registers itself to be listed. After which, both send heartbeats to each other at regular intervals. Hence [ASSURED]
# 2st line: The BF2 server sends heartbeats to the cd key server at regular intervals without a response. Hence [UNREPLIED]
# 3rd line: A few seconds after the BF2 server registers itself to be listed, the BF2 master listing server talks with the BF2 server, and the BF2 server sends its details, at regular intervals. Hence [ASSURED]
$ sudo conntrack -L -p udp | grep 92.51
udp      17 115 src=172.17.48.2 dst=92.51.181.102 sport=29900 dport=27900 src=92.51.181.102 dst=192.168.1.100 sport=27900 dport=29900 [ASSURED] mark=0 use=1
udp      17 25 src=172.17.48.2 dst=92.51.181.102 sport=29900 dport=29910 [UNREPLIED] src=92.51.181.102 dst=192.168.1.100 sport=29910 dport=29900 mark=0 use=1
udp      17 118 src=92.51.149.13 dst=192.168.1.100 sport=58665 dport=29900 src=172.17.48.2 dst=92.51.149.13 sport=29900 dport=58665 [ASSURED] mark=0 use=1

# Stop and tearfown BF2 server
$ docker-compose down

# Get UDP conntrack entries
# Line 1: Notice that this UDP conntrack entry to the BF2 master server remains and is not removed
# Line 2: Notice that this UDP conntrack entry to the BF2 master server remains and is not removed
# If we started a new BF2 server container now, it will not receive any UDP packets from the BF2Hub master server and listing server, since the packets will end up being sent to the old container's IP (172.17.64.2), and instead of the new container's IP
$ sudo conntrack -L -p udp | grep 92.51
udp      17 23 src=172.17.48.2 dst=92.51.181.102 sport=29900 dport=29910 [UNREPLIED] src=92.51.181.102 dst=192.168.1.100 sport=29910 dport=29900 mark=0 use=1
udp      17 113 src=172.17.48.2 dst=92.51.181.102 sport=29900 dport=27900 src=92.51.181.102 dst=192.168.1.100 sport=27900 dport=29900 [ASSURED] mark=0 use=1

# Start BF2 server with a new container IP address
$ docker-compose up
$ sleep 10

# Get UDP conntrack entries
# 172.17.64.2 is the new BF2 container's IP address
# Line 1: BF2 server talking with the BF2Hub master server. However, instead of [ASSURED], it is [UNREPLIED]
# Line 2: This is the culprit. This stale UDP conntrack entry is directing BF2Hub master server replies to the old container IP (172.17.48.2), and the entry remains [ASSURED]
# Line 3: BF2 server talking with the BF2Hub cd key server. [UNREPLIED] is expected
# Line 4: The master listing server talks with the BF2 server. [ASSURED] is expected
# Hence, to solve this we need to remove the 3rd line from the conntrack table
$ sudo conntrack -L -p udp | grep 92.51
udp      17 26 src=172.17.64.2 dst=92.51.181.102 sport=29900 dport=27900 [UNREPLIED] src=92.51.181.102 dst=192.168.1.100 sport=27900 dport=40589 mark=0 use=1
udp      17 77 src=172.17.48.2 dst=92.51.181.102 sport=29900 dport=27900 src=92.51.181.102 dst=192.168.1.100 sport=27900 dport=29900 [ASSURED] mark=0 use=1
udp      17 26 src=172.17.64.2 dst=92.51.181.102 sport=29900 dport=29910 [UNREPLIED] src=92.51.181.102 dst=192.168.1.100 sport=29910 dport=40589 mark=0 use=1
udp      17 106 src=92.51.149.13 dst=192.168.1.100 sport=58665 dport=29900 src=172.17.64.2 dst=92.51.149.13 sport=29900 dport=58665 [ASSURED] mark=0 use=1

# Delete the stale UDP conntrack entries from gameserver destined for BF2Hub master server
$ conntrack -D -p udp --orig-port-dst 27900
udp      17 24 src=172.17.64.2 dst=92.51.181.102 sport=29900 dport=27900 [UNREPLIED] src=92.51.181.102 dst=192.168.1.100 sport=27900 dport=40589 mark=0 use=1
udp      17 77 src=172.17.48.2 dst=92.51.181.102 sport=29900 dport=27900 src=92.51.181.102 dst=192.168.1.100 sport=27900 dport=29900 [ASSURED] mark=0 use=1
conntrack v1.4.5 (conntrack-tools): 2 flow entries have been deleted
$ conntrack -D -p udp --orig-port-dst 29910
udp      17 25 src=172.17.64.2 dst=92.51.181.102 sport=29900 dport=29910 [UNREPLIED] src=92.51.181.102 dst=192.168.1.100 sport=29910 dport=40589 mark=0 use=1
conntrack v1.4.5 (conntrack-tools): 1 flow entries have been deleted

# Delete the stale UDP conntrack entries from master listing server destined for gameserver
$ conntrack -D -p udp --orig-port-src 58665
udp      17 106 src=92.51.149.13 dst=192.168.1.100 sport=58665 dport=29900 src=172.17.64.2 dst=92.51.149.13 sport=29900 dport=58665 [ASSURED] mark=0 use=1
conntrack v1.4.5 (conntrack-tools): 1 flow entries have been deleted

# Get UDP conntrack entries
# Line 1: BF2 server talking with the BF2Hub master server. It is now [ASSURED] which is expected
# Line 2: BF2 server talking with the BF2Hub cd key server. [UNREPLIED] is expected
# Line 3: The master listing server talks with the BF2 server. [ASSURED] is expected
# Now we see that the new BF2 container IP (172.17.64.2) correctly talks with the BF2Hub master server, and our server is now listed
$ sudo conntrack -L -p udp | grep 92.51
udp      17 114 src=172.17.64.2 dst=92.51.181.102 sport=29900 dport=27900 src=92.51.181.102 dst=192.168.1.100 sport=27900 dport=29900 [ASSURED] mark=0 use=1
udp      17 25 src=172.17.64.2 dst=92.51.181.102 sport=29900 dport=29910 [UNREPLIED] src=92.51.181.102 dst=192.168.1.100 sport=29910 dport=29900 mark=0 use=1
udp      17 119 src=92.51.149.13 dst=192.168.1.100 sport=58665 dport=29900 src=172.17.64.2 dst=92.51.149.13 sport=29900 dport=58665 [ASSURED] mark=0 use=1
```

## Development

Requires Windows `powershell` or [`pwsh`](https://github.com/PowerShell/PowerShell).

```powershell
# Install Generate-DockerImageVariants module: https://github.com/theohbrothers/Generate-DockerImageVariants
Install-Module -Name Generate-DockerImageVariants -Repository PSGallery -Scope CurrentUser -Force -Verbose

# Edit ./generate templates

# Generate the variants
Generate-DockerImageVariants .
```

### Bump a variant

```sh
# Replace occurrences with new semver
git ls-files | grep -E '^(docs|generate)' | xargs sed -i 's/2.3.3/2.4.1/'

# Update the sha256sum of archives if needed
vi generate/templates/Dockerfile.ps1

# Generate the variants
Generate-DockerImageVariants .
```

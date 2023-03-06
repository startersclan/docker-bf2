## Usage

Here are some one-liners to quickly start a BF2 server.

If you want the BF2 server to be listed on a master server, see [DNS Spoofing](#dns-spoofing).

### BF2

```sh
# BF2 server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0

# BF2 server with random coop maps
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0 bash -c '(esai-helper -m bf2 get maplist; esai-helper -m xpack get maplist) | grep gpm_coop | shuf > /server/bf2/mods/bf2/settings/maplist.con && exec ./start.sh'

# BF2 server with random conquest maps
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0 bash -c '(esai-helper -m bf2 get maplist; esai-helper -m xpack get maplist) | grep gpm_cq | shuf > /server/bf2/mods/bf2/settings/maplist.con && exec ./start.sh'

# Read BF2 server readme
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/readme-linux.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/readmeserver.txt

# By using this image, you agree to the licenses
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/eula.txt # EULA for the BF2 dedicated Linux server
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/lgpl.txt # LGPL
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/readmes/pb_eula.txt # EULA for the EULA for PunkBuster
```

To customize the server, edit `serversettings.con` and `maplist.con` accordingly, and start the server:

```sh
# Generate serversettings.con and customize
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/settings/serversettings.con > serversettings.con
# Generate maplist.con (coop)
docker run --rm startersclan/docker-bf2:v1.5.3153.0 bash -c '(esai-helper -m bf2 get maplist; esai-helper -m xpack get maplist) | grep gpm_coop' > maplist.con
# Generate maplist.con (conquest)
docker run --rm startersclan/docker-bf2:v1.5.3153.0 bash -c '(esai-helper -m bf2 get maplist; esai-helper -m xpack get maplist) | grep gpm_cq' > maplist.con
# BF2 server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v "$(pwd)/serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con:ro" \
    -v "$(pwd)/maplist.con:/server/bf2/mods/bf2/settings/maplist.con:ro" \
    startersclan/docker-bf2:v1.5.3153.0
```

See `docker-compose` examples:

- [BF2 LAN server](examples/v1.5)
- [BF2 server with PRMasterServer as master server](examples/v1.5-prmasterserver)
- [BF2 server with PRMasterServer as master server running as a sidecar](examples/v1.5-prmasterserver)
- [BF2 server with BF2Hub as master server](examples/v1.5-bf2hub-spoofed)
- [BF2 server with BF2Hub as master server (using bf2hub binaries)](examples/v1.5-bf2hub)
- [BF2 LAN server with an ESAI default strategy](examples/v1.5-esai-default-strategy)
- [BF2 LAN server with community-optimized ESAI strategies](examples/v1.5-esai-optimized-strategies)
- [BF2 LAN server with custom ESAI strategies](examples/v1.5-esai-custom-strategies)

### BF2 with BF2Statistics 2.x.x

To customize the server, edit `serversettings.con` and `maplist.con` accordingly, and start the server with [DNS spoofing](#dns-spoofing-for-server-to-send-stats-snapshots-to-bf2statistics-2xx) to the ASP webserver `192.168.1.100`:

```sh
# Generate serversettings.con and customize
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.5.1 cat /server/bf2/mods/bf2/settings/serversettings.con > serversettings.con
# Generate maplist.con (coop)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.5.1 bash -c '(esai-helper -m bf2 get maplist; esai-helper -m xpack get maplist) | grep gpm_coop' > maplist.con
# Generate maplist.con (conquest)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.5.1 bash -c '(esai-helper -m bf2 get maplist; esai-helper -m xpack get maplist) | grep gpm_cq' > maplist.con
# Generate BF2StatisticsConfig.py and customize
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.5.1 cat /server/bf2/python/bf2/BF2StatisticsConfig.py > BF2StatisticsConfig.py
# BF2 server with BF2Statistics 2.x.x
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v "$(pwd)/serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con:ro" \
    -v "$(pwd)/maplist.con:/server/bf2/mods/bf2/settings/maplist.con:ro" \
    -v "$(pwd)/BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro" \
    --add-host bf2web.gamespy.com:192.168.1.100 \
    --add-host gamestats.gamespy.com:192.168.1.100 \
    --add-host eapusher.dice.se:192.168.1.100 \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.5.1
```

See `docker-compose` examples:

- [BF2 LAN server with BF2Statistics 2.x.x ASP as stats server](examples/v1.5-bf2stats-2)
- [BF2 server with BF2Hub as master server and BF2Statistics 2.x.x ASP as stats server](examples/v1.5-bf2hub-bf2stats-2)

### BF2 with BF2Statistics 3.x.x

To customize the server, edit `serversettings.con` and `maplist.con` accordingly, and start the server with [DNS spoofing](#dns-spoofing-for-server-to-send-stats-snapshots-to-bf2statistics-3xx) to the ASP webserver `192.168.1.100`:

```sh
# Generate serversettings.con and customize
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2stats-3.1.2 cat /server/bf2/mods/bf2/settings/serversettings.con > serversettings.con
# Generate maplist.con (coop)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2stats-3.1.2 bash -c '(esai-helper -m bf2 get maplist; esai-helper -m xpack get maplist) | grep gpm_coop' > maplist.con
# Generate maplist.con (conquest)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2stats-3.1.2 bash -c '(esai-helper -m bf2 get maplist; esai-helper -m xpack get maplist) | grep gpm_cq' > maplist.con
# Generate BF2StatisticsConfig.py and customize
docker run --rm -it startersclan/docker-bf2:v1.5.3153.0-bf2stats-3.1.2 cat /server/bf2/python/bf2/BF2StatisticsConfig.py > BF2StatisticsConfig.py
# BF2 server with BF2Statistics 3.x.x
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v "$(pwd)/serversettings.con:/server/bf2/mods/bf2/settings/serversettings.con:ro" \
    -v "$(pwd)/maplist.con:/server/bf2/mods/bf2/settings/maplist.con:ro" \
    -v "$(pwd)/BF2StatisticsConfig.py:/server/bf2/python/bf2/BF2StatisticsConfig.py:ro" \
    --add-host bf2web.gamespy.com:192.168.1.100 \
    --add-host gamestats.gamespy.com:192.168.1.100 \
    --add-host eapusher.dice.se:192.168.1.100 \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-3.1.2
```

See `docker-compose` examples:

- [BF2 LAN server with BF2Statistics 3.x.x ASP as stats server](examples/v1.5-bf2stats-3)
- [BF2 server with BF2Hub as master server and BF2Statistics 3.x.x ASP as stats server](examples/v1.5-bf2hub-bf2stats-3)

### AIX 2.0 mod

```sh
# BF2 server running AIX 2.0 mod
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-aix2

# BF2 server running AIX 2.0 mod with random coop maps
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-aix2 bash -c 'esai-helper -m aix2 get maplist | grep gpm_coop | shuf > /server/bf2/mods/aix2/settings/maplist.con && exec ./start.sh +modPath mods/aix2'

# BF2 server running AIX 2.0 mod with random conquest maps
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-aix2 bash -c 'esai-helper -m aix2 get maplist | grep gpm_cq | shuf > /server/bf2/mods/aix2/settings/maplist.con && exec ./start.sh +modPath mods/aix2'
```

To customize the server, edit `serversettings.con` and `maplist.con` accordingly:

```sh
# Generate serversettings.con and customize
docker run --rm startersclan/docker-bf2:v1.5.3153.0-aix2 cat /server/bf2/mods/aix2/settings/serversettings.con > serversettings.con
# Generate maplist.con (coop)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-aix2 esai-helper -m aix2 get maplist | grep gpm_coop > maplist.con
# Generate maplist.con (conquest)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-aix2 esai-helper -m aix2 get maplist | grep gpm_cq > maplist.con
# BF2 server running AIX 2.0 mod
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v "$(pwd)/serversettings.con:/server/bf2/mods/aix2/settings/serversettings.con:ro" \
    -v "$(pwd)/maplist.con:/server/bf2/mods/aix2/settings/maplist.con:ro" \
    startersclan/docker-bf2:v1.5.3153.0-aix2
```

See `docker-compose` examples:

- [BF2 LAN server running AIX 2.0 mod](examples/v1.5-aix2)

### BF2All64 mod

```sh
# BF2 server running BF2All64 mod
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-bf2all64

# BF2 server running BF2All64 mod with random coop maps
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-bf2all64 bash -c 'esai-helper -m bf2all64 get maplist | grep gpm_coop | shuf > /server/bf2/mods/bf2all64/settings/maplist.con && exec ./start.sh +modPath mods/bf2all64'

# BF2 server running BF2All64 mod with random conquest maps
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-bf2all64 bash -c 'esai-helper -m bf2all64 get maplist | grep gpm_cq | shuf > /server/bf2/mods/bf2all64/settings/maplist.con && exec ./start.sh +modPath mods/bf2all64'
```

To customize the server, edit `serversettings.con` and `maplist.con` accordingly:

```sh
# Generate serversettings.con and customize
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2all64 cat /server/bf2/mods/bf2all64/settings/serversettings.con > serversettings.con
# Generate maplist.con (coop)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2all64 esai-helper -m bf2all64 get maplist | grep gpm_coop > maplist.con
# Generate maplist.con (conquest)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-bf2all64 esai-helper -m bf2all64 get maplist | grep gpm_cq > maplist.con
# BF2 server running BF2All64 mod
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v "$(pwd)/serversettings.con:/server/bf2/mods/bf2all64/settings/serversettings.con:ro" \
    -v "$(pwd)/maplist.con:/server/bf2/mods/bf2all64/settings/maplist.con:ro" \
    startersclan/docker-bf2:v1.5.3153.0-bf2all64
```

See `docker-compose` examples:

- [BF2 LAN server running BF2All64 mod](examples/v1.5-bf2all64)
- [BF2 LAN server running BF2All64 mod with ESAI optimized strategies](examples/v1.5-bf2all64-esai-optimized-strategies)

### Forgotten Hope 2 mod

```sh
# BF2 server running Forgotten Hope 2 mod
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304

# BF2 server running Forgotten Hope 2 mod with random coop maps
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 bash -c 'esai-helper -m fh2 get maplist | grep gpm_coop | shuf > /server/bf2/mods/fh2/settings/maplist.con && exec ./start.sh +modPath mods/fh2'

# BF2 server running Forgotten Hope 2 mod with random conquest maps
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 bash -c 'esai-helper -m fh2 get maplist | grep gpm_cq | shuf > /server/bf2/mods/fh2/settings/maplist.con && exec ./start.sh +modPath mods/fh2'
```

To customize the server, edit `serversettings.con` and `maplist.con` accordingly:

```sh
# Generate serversettings.con and customize
docker run --rm startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 cat /server/bf2/mods/fh2/settings/serversettings.con > serversettings.con
# Generate maplist.con (coop)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 esai-helper -m fh2 get maplist | grep gpm_coop > maplist.con
# Generate maplist.con (conquest)
docker run --rm startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304 esai-helper -m fh2 get maplist | grep gpm_cq > maplist.con
# BF2 server running fh2 mod
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    -v "$(pwd)/serversettings.con:/server/bf2/mods/fh2/settings/serversettings.con" \
    -v "$(pwd)/maplist.con:/server/bf2/mods/fh2/settings/maplist.con" \
    startersclan/docker-bf2:v1.5.3153.0-fh2-4.6.304
```

See `docker-compose` examples:

- [BF2 LAN server running Forgotten Hope 2 mod](examples/v1.5-fh2)

## DNS spoofing

### DNS spoofing: for server to be listed on BF2Hub master server

If you want the BF2 server to be listed a public master server such as [BF2Hub](https://bf2hub.com/servers), for better server discoverability by clients and to make it easier for clients to connect to your server, DNS spoofing is needed for the BF2 server. DNS spoofing can be done using `--add-host` on `docker run`, or `extra_hosts` key in `docker-compose.yml`.

To list a BF2 server on BF2Hub (IP address `92.51.181.102`):

> If the server is behind NAT, ensure to port-forward both UDP ports `16567` and `29900` to your server. `sv.internet 1` must be used in `serversettings.con` (already present by default).

> The server will be listed as an unranked server on BF2Hub, since it is not a BF2Hub official server.

```sh
# BF2 server with BF2Hub as master server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    --add-host battlefield2.available.gamespy.com:92.51.181.102 \
    --add-host battlefield2.master.gamespy.com:92.51.181.102 \
    --add-host battlefield2.ms14.gamespy.com:92.51.181.102 \
    --add-host master.gamespy.com:92.51.181.102 \
    --add-host motd.gamespy.com:92.51.181.102 \
    --add-host gpsp.gamespy.com:92.51.181.102 \
    --add-host gpcm.gamespy.com:92.51.181.102 \
    --add-host gamespy.com:92.51.181.102 \
    startersclan/docker-bf2:v1.5.3153.0
```

To get BF2Hub.com IP addresses:

```sh
nslookup servers.bf2hub.com
```

See docker-compose example:

- [BF2 server with BF2Hub as master server](examples/v1.5-bf2hub-spoofed)

### DNS spoofing: for server to be listed on PRMasterServer master server

If you want the BF2 server to be listed on a private master server such as [PRMasterServer](https://github.com/startersclan/prmasterserver), for better server discoverability by clients and to make it easier for clients to connect to your server, DNS spoofing is needed for the BF2 server. DNS spoofing can be done using `--add-host` on `docker run`, or `extra_hosts` key in `docker-compose.yml`.

To list a BF2 server on PRMasterServer (assuming `PRMasterServer` IP address is `192.168.1.100`):

> If the server is behind NAT, ensure to port-forward both UDP ports 16567 and 29900 to your server. `sv.internet 1` must be used in `serversettings.con` (already present by default).

```sh
# BF2 server with PRMasterServer as master server
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    --add-host battlefield2.available.gamespy.com:192.168.1.100 \
    --add-host battlefield2.master.gamespy.com:192.168.1.100 \
    --add-host battlefield2.ms14.gamespy.com:192.168.1.100 \
    --add-host master.gamespy.com:192.168.1.100 \
    --add-host motd.gamespy.com:192.168.1.100 \
    --add-host gpsp.gamespy.com:192.168.1.100 \
    --add-host gpcm.gamespy.com:192.168.1.100 \
    --add-host gamespy.com:192.168.1.100 \
    startersclan/docker-bf2:v1.5.3153.0
```

See `docker-compose` examples:

- [BF2 server with PRMasterServer as master server](examples/v1.5-prmasterserver)
- [BF2 server with PRMasterServer as master server running as a sidecar](examples/v1.5-prmasterserver)

### DNS spoofing: for server to send stats snapshots to BF2Statistics 2.x.x

In order for `bf2stats-2.x.x` variants to be able to send stats snapshots to a [BF2Statistics 2.x.x ASP](https://github.com/startersclan/bf2stats) webserver, DNS spoofing is needed for the BF2 server. DNS spoofing can be done using `--add-host` on `docker run`, or `extra_hosts` key in `docker-compose.yml`.

To send stats snapshots from `bf2stats-2.x.x` (assuming `BF2Statistics 2.x.x ASP` webserver IP address is `192.168.1.100`):

```sh
# BF2 server with BF2Statistics 2.x.x
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    --add-host bf2web.gamespy.com:192.168.1.100 \
    --add-host gamestats.gamespy.com:192.168.1.100 \
    --add-host eapusher.dice.se:192.168.1.100 \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-2.5.1
```

See `docker-compose` examples:

- [BF2 server with BF2Statistics 2.x.x ASP as stats server](examples/v1.5-bf2stats-2)
- [BF2 server with BF2Hub as master server and BF2Statistics 2.x.x ASP as stats server](examples/v1.5-bf2hub-bf2stats-2)

### DNS spoofing: for server to send stats snapshots to BF2Statistics 3.x.x

In order for `bf2stats-3.x.x` variants to be able to send stats snapshots to a [BF2Statistics 3.x.x ASP](https://github.com/startersclan/ASP) webserver, DNS spoofing is needed for the BF2 server. DNS spoofing can be done using `--add-host` on `docker run`, or `extra_hosts` key in `docker-compose.yml`.

To send stats snapshots from `bf2stats-3.x.x` (assuming BF2Statistics 3.x.x ASP webserver IP address is 192.168.1.100):

```sh
# BF2 server with BF2Statistics 3.x.x
docker run --rm -it -p 16567:16567/udp -p 29900:29900/udp \
    --add-host bf2web.gamespy.com:192.168.1.100 \
    --add-host gamestats.gamespy.com:192.168.1.100 \
    --add-host eapusher.dice.se:192.168.1.100 \
    startersclan/docker-bf2:v1.5.3153.0-bf2stats-3.1.2
```

See `docker-compose` examples:

- [BF2 server with BF2Statistics 3.x.x ASP as stats server](examples/v1.5-bf2stats-3)
- [BF2 server with BF2Hub as master server and BF2Statistics 3.x.x ASP as stats server](examples/v1.5-bf2hub-bf2stats-3)

## ESAI

[ESAI](https://www.moddb.com/mods/esai-enhanced-strategic-ai) greatly enhances bot performance, and is compatible with any BF2 mod. It is included but not enabled by default.

A handy tool called [`esai-helper`](vendor/esai-helper) is included in all images. It can be used to list gamemodes, generate maplists for a mod, list a levels' `strategies.ai`, apply default or custom `strategies.ai` to levels, and more. See `esai-helper --help` for usage.

To use a default strategy for all levels, see [this example](examples/v1.5-esai-default-strategy/).

To override the default strategy with a level-specific strategy, optimized strategies config files are included in each image. These strategies have been optimized by the BF2SP64 community:

- [`/esai-optimized-strategies-bf2.txt`](vendor/esai-optimized-strategies-bf2.txt)
- [`/esai-optimized-strategies-bf2all64.txt`](vendor/esai-optimized-strategies-bf2all64.txt)
- [`/esai-optimized-strategies-xpack.txt`](vendor/esai-optimized-strategies-xpack.txt)

To use optimized strategies for levels, see [this example](examples/v1.5-esai-optimized-strategies/). For `bf2all64` mod, see [this example](examples/v1.5-bf2all64-esai-optimized-strategies/).

To use custom strategies for levels, see [example](examples/v1.5-esai-custom-strategies/).

```sh
# Read ESAI readmes
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/readme.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/directory.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/credits.txt
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat "/server/bf2/mods/bf2/esai/quick start.txt"
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat "/server/bf2/mods/bf2/esai/users guide.txt"
docker run --rm startersclan/docker-bf2:v1.5.3153.0 cat /server/bf2/mods/bf2/esai/version.txt
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

A: Ensure you spoof Gamespy DNS for the gameserver. See [this example](examples/v1.5-bf2hub-spoofed).

In addition, the gameserver lists its info on master server based on the `sv.serverPort` and `sv.gameSpyPort` in `serversettings.con`. If you are running on non-standard ports instead of the standard gameserver ports UDP `16567` and UDP `29900`, you need to use those ports in `docker-compose.yml` and `serversettings.con`.

### Q: Server not listed on master server after `docker-compose down && docker-compose up`

A: This is caused by stale [UDP conntrack entries which are not deleted](https://github.com/moby/moby/issues/8795) by `docker` on container teardown that was recently fixed in docker [`v23.0.0`](https://github.com/moby/moby/pull/44752).

For older docker version, the solution is to run a sidecar container that deletes the stale UDP conntrack entries on BF2 container startup, see [this example](examples/delete-udp-conntrack). Alternatively, a sidecar `init-container` can achieve the same result, see [this example](examples/v1.5-with-delete-udp-conntrack). Alternatively, run on host networking (i.e. `network_mode: host` in docker-compose.yml) to avoid SNAT completely, but that is not advised because it defeats the purpose of containerization.

To illustate the details:

<details>

```sh
# Start BF2 server
$ docker-compose up
$ sleep 10

# Get UDP conntrack entries
# 92.51.181.102:27900 is BF2Hub master server
# 92.51.181.102:29910 is BF2Hub cdkey server
# 92.51.149.13 is the BF2Hub master listing server
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
# Line 1: BF2 server talking with the BF2Hub cd key server. [UNREPLIED] is expected
# Line 2: BF2 server talking with the BF2Hub master server. It is now [ASSURED] which is expected
# Line 3: The master listing server talks with the BF2 server. [ASSURED] is expected
# Now we see that the new BF2 container IP (172.17.64.2) correctly talks with the BF2Hub master server, and our server is now listed
$ sudo conntrack -L -p udp | grep 92.51
udp      17 25 src=172.17.64.2 dst=92.51.181.102 sport=29900 dport=29910 [UNREPLIED] src=92.51.181.102 dst=192.168.1.100 sport=29910 dport=29900 mark=0 use=1
udp      17 114 src=172.17.64.2 dst=92.51.181.102 sport=29900 dport=27900 src=92.51.181.102 dst=192.168.1.100 sport=27900 dport=29900 [ASSURED] mark=0 use=1
udp      17 119 src=92.51.149.13 dst=192.168.1.100 sport=58665 dport=29900 src=172.17.64.2 dst=92.51.149.13 sport=29900 dport=58665 [ASSURED] mark=0 use=1
```

</details>
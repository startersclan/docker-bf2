# docker-bf2

[![github-actions](https://github.com/startersclan/docker-bf2/workflows/ci-master-pr/badge.svg)](https://github.com/startersclan/docker-bf2/actions)
[![github-release](https://img.shields.io/github/v/release/startersclan/docker-bf2?style=flat-square)](https://github.com/startersclan/docker-bf2/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/startersclan/docker-bf2/latest)](https://hub.docker.com/r/startersclan/docker-bf2)

Dockerized [Battlefield 2 Server](https://www.ea.com/games/battlefield/battlefield-2).

## Tags

All images contain [`Battlefield 2 Server 1.50`](https://www.bf-games.net/downloads/category/153/serverfiles.html), and include [Enhanced Strategic AI (ESAI)](docs/usage.md#esai), which may be activated if needed.

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:v1.5.3153.0`, `:latest` | [View](variants/v1.5.3153.0 ) |
| `:v1.5.3153.0-aix2` | [View](variants/v1.5.3153.0-aix2 ) |
| `:v1.5.3153.0-bf2all64` | [View](variants/v1.5.3153.0-bf2all64 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-2.2.0` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-2.2.0 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-2.3.8` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-2.3.8 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-2.4.6` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-2.4.6 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-2.5.1` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-2.5.1 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-3.1.0` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-3.1.0 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-3.1.2` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-3.1.2 ) |
| `:v1.5.3153.0-bf2all64-bf2stats-3.2.0` | [View](variants/v1.5.3153.0-bf2all64-bf2stats-3.2.0 ) |
| `:v1.5.3153.0-bf2hub` | [View](variants/v1.5.3153.0-bf2hub ) |
| `:v1.5.3153.0-bf2stats-2.2.0` | [View](variants/v1.5.3153.0-bf2stats-2.2.0 ) |
| `:v1.5.3153.0-bf2stats-2.3.8` | [View](variants/v1.5.3153.0-bf2stats-2.3.8 ) |
| `:v1.5.3153.0-bf2stats-2.4.6` | [View](variants/v1.5.3153.0-bf2stats-2.4.6 ) |
| `:v1.5.3153.0-bf2stats-2.5.1` | [View](variants/v1.5.3153.0-bf2stats-2.5.1 ) |
| `:v1.5.3153.0-bf2stats-3.1.0` | [View](variants/v1.5.3153.0-bf2stats-3.1.0 ) |
| `:v1.5.3153.0-bf2stats-3.1.2` | [View](variants/v1.5.3153.0-bf2stats-3.1.2 ) |
| `:v1.5.3153.0-bf2stats-3.2.0` | [View](variants/v1.5.3153.0-bf2stats-3.2.0 ) |
| `:v1.5.3153.0-fh2-4.6.304` | [View](variants/v1.5.3153.0-fh2-4.6.304 ) |

- `aix2` - [AIX-2.0](https://www.moddb.com/mods/allied-intent-xtended/downloads/aix-20-server-files) mod.
- `bf2all64` - [BF2All64](https://www.bf-games.net/downloads/2533/bf2-singleplayer-all-in-one-package.html) mod.
- `bf2hub` - Includes [BF2Hub](https://www.bf2hub.com/home/serversetup.php) server binaries.
- `bf2stats-2.x.x` - Includes [BF2Statistics 2.x.x python files](https://github.com/startersclan/bf2stats) to send stats snapshots to the [BF2Statistics 2.x.x ASP](https://github.com/startersclan/bf2stats) webserver. See [here](https://github.com/startersclan/bf2stats) for a fully dockerized example.
- `bf2stats-3.x.x` - Includes [BF2Statistics 3.x.x python files](https://github.com/startersclan/StatsPython) to send stats snapshots to the [BF2Statistics 3.x.x ASP](https://github.com/startersclan/ASP) webserver. See [here](https://github.com/startersclan/ASP) for a fully dockerized example.
- `fh2` - [Forgotten Hope 2](http://www.forgottenhope.warumdarum.de) mod

## Usage

For usage and `docker-compose` examples, see [here](docs/usage.md).

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
git ls-files | grep -E '^docs' | xargs sed -i 's/2.5.0/2.5.1/'

# Update the sha256sum of archives if needed
vi generate/templates/Dockerfile.ps1

# Generate the variants
Generate-DockerImageVariants .
```

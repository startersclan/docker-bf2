FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# Install network utilities which can be useful for debugging issues
# Install unzip and zip for the sake of applying ESAI strategies in ./mods/*/levels/*/server.zip at './GameModes/[gpm_coop|gpm_cq|sp1|sp2|sp3]/[16|32|64]/AI/Strategies.ai'
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update;  \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
        conntrack dnsutils iproute2 netcat net-tools tcpdump \
        unzip zip \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*;

# Install Battlefield 2 server
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://files.startersclan.com/ea/bf2/bf2-linuxded-1.5.3153.0-installer.tgz; \
    sha256sum bf2-linuxded-1.5.3153.0-installer.tgz | grep "^4d849218c1725e7bd6a7e7f164e27b036248f8ded2e30340dd0722c1dfffbab6 "; \
    tar -zxvf bf2-linuxded-1.5.3153.0-installer.tgz; \
    sh bf2-linuxded-1.5.3153.0-installer.sh --target /install --noexec --info; \
    sh bf2-linuxded-1.5.3153.0-installer.sh --target /install --noexec; \
    rm -v bf2-linuxded-1.5.3153.0-installer.sh; \
    rm -v bf2-linuxded-1.5.3153.0-installer.tgz; \
    cd /install; \
    mkdir -p /server; \
    # Show the licenses without a pager
    cat /install/license.sh | sed 's/^more/cat/' > /install/license-fixed.sh; \
    # Agree to licenses
    printf '\naccept\n\nyes\n/server\ny\n' | sh /install/license-fixed.sh; \
    find /server; \
    rm -rf /install;

# Install bf2stats 3.1.0
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://github.com/BF2Statistics/StatsPython/archive/2197486.zip; \
    sha256sum 2197486.zip | grep '^881ddc8f77a573be661f68a146883bc5e23b3d1b1a4d4323496d66d405744232 '; \
    unzip 2197486.zip -d 2197486; \
    cp -r 2197486/*/. /server/bf2/python/bf2/; \
    rm -fv 2197486.zip;
# Install ESAI in all mods
WORKDIR /root
COPY ESAI-Standard-v4.2.zip ESAI-Standard-v4.2.zip
COPY lowercase-helper /usr/local/bin/lowercase-helper
RUN set -eux; \
    sha256sum ESAI-Standard-v4.2.zip | grep '^ef4e5d0f1446b9a2ddb0b350f1334273681c0f64d9c38c506320db769b24499c '; \
    # Lowercase all files in ESAI folder
    for i in $( ls /server/bf2/mods ); do \
        unzip ESAI-Standard-v4.2.zip -d /server/bf2/mods/$i; \
        lowercase-helper --dir "/server/bf2/mods/$i/ESAI"; \
    done; \
    # Lowercase ESAI mapfiles' content
    for i in $( find /server/bf2/mods/*/esai/mapfiles -type f ); do \
        CONTENT=$( cat "$i" ); \
        echo "$CONTENT" | tr '[:upper:]' '[:lower:]' > "$i"; \
    done;

# Install esai-helper and configs
COPY esai-helper /usr/local/bin/esai-helper
COPY esai-optimized-strategies-bf2.txt /esai-optimized-strategies-bf2.txt
COPY esai-optimized-strategies-bf2all64.txt /esai-optimized-strategies-bf2all64.txt
COPY esai-optimized-strategies-xpack.txt /esai-optimized-strategies-xpack.txt

COPY healthcheck /healthcheck

# EXPOSE 16567/udp
# EXPOSE 29900/udp
# HEALTHCHECK CMD /healthcheck
WORKDIR /server/bf2
CMD [ "./start.sh" ]

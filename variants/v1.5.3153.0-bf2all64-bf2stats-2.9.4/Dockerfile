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
COPY aibehaviours-fixlookatwrapper.ai /aibehaviours-fixlookatwrapper.ai
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
    rm -rf /install; \
    # Apply the LookAtWrapper fix to prevent crashes when playing with bots
    mv -v /server/bf2/mods/bf2/ai/aibehaviours.ai /server/bf2/mods/bf2/ai/aibehaviours.ai.original; \
    cp -v /aibehaviours-fixlookatwrapper.ai /server/bf2/mods/bf2/ai/aibehaviours.ai; \
    mv -v /server/bf2/mods/xpack/ai/aibehaviours.ai /server/bf2/mods/xpack/ai/aibehaviours.ai.original; \
    cp -v /aibehaviours-fixlookatwrapper.ai /server/bf2/mods/xpack/ai/aibehaviours.ai; \
    rm -v /aibehaviours-fixlookatwrapper.ai

# Install bf2all64 mod
WORKDIR /root
COPY aibehaviours-fixlookatwrapper.ai /aibehaviours-fixlookatwrapper.ai
RUN set -eux; \
    curl -sSLO https://files.startersclan.com/ea/bf2/bf2all64_v1.0_setup.zip; \
    sha256sum bf2all64_v1.0_setup.zip | grep '^4ee82d91043c4afbf1bed50787cbf98af124bd7e6c608cdb0f5115c7761024f1 '; \
    unzip bf2all64_v1.0_setup.zip -d extract; \
    rm -rf /server/bf2/mods/bf2all64; \
    mv extract/bf2all64 /server/bf2/mods; \
    rm -fv bf2all64_v1.0_setup.zip; \
    # Apply the LookAtWrapper fix to prevent crashes when playing with bots
    mv -v /server/bf2/mods/bf2all64/ai/aibehaviours.ai /server/bf2/mods/bf2all64/ai/aibehaviours.ai.original; \
    cp -v /aibehaviours-fixlookatwrapper.ai /server/bf2/mods/bf2all64/ai/aibehaviours.ai; \
    rm -v /aibehaviours-fixlookatwrapper.ai

# Install bf2stats 2.9.4
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://github.com/startersclan/bf2stats/archive/refs/tags/2.9.4.tar.gz; \
    echo "3bfc13168b5005aead6247021a3233a6d6037698e12451a545bfa25d1d2d6e69  2.9.4.tar.gz" | sha256sum -c -; \
    mkdir -p extract; \
    tar -C extract -zxvf 2.9.4.tar.gz; \
    rm -rf /server/bf2/python; \
    mv extract/bf2stats-2.9.4/src/python /server/bf2/python; \
    rm -fv 2.9.4.tar.gz; \
    rm -rf extract

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
CMD [ "./start.sh", "+modPath", "mods/bf2all64" ]

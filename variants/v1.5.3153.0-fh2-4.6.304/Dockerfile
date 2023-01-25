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

# Install Forgotten Hope 2 4.6.304
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://files.startersclan.com/ea/bf2/fh2-server-4.6.304.tar; \
    echo "bb933052ad20928b5a4bc6c1eeff647d62b0f3b38de46d063101719a9f0cf488  fh2-server-4.6.304.tar" | sha256sum -c -; \
    tar -xvf fh2-server-4.6.304.tar --no-same-owner -C /server/bf2 ; \
    chmod -R +x /server/bf2/bin; \
    mv /server/bf2/start-fh2.sh /server/bf2/start.sh; \
    # Create a default maplist.con, since it is not included by the installer
    for i in $( ls /server/bf2/mods/fh2/levels/*/info/*cq_64_menumap.png | cut -d '/' -f7 ); do echo "maplist.append \"$i\" \"gpm_cq\" 64" >> /server/bf2/mods/fh2/settings/maplist.con; done; \
    rm -fv fh2-server-4.6.304.tar;

# Install fh2 dependencies
# Fix error: /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version GLIBCXX_3.4.22' not found (required by /server/bf2/bin/amd-64/fh2utils.so)
# See: https://stackoverflow.com/questions/43070900/version-glibcxx-3-4-22-not-found
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && apt-get install -y apt-transport-https software-properties-common; \
    add-apt-repository ppa:ubuntu-toolchain-r/test; \
    apt-get update; \
    apt-get install -y gcc-4.9; \
    apt-get upgrade -y libstdc++6; \
    strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX; \
    add-apt-repository ppa:ubuntu-toolchain-r/test --remove; \
    apt-get purge --auto-remove -y apt-transport-https software-properties-common gcc-4.9; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*;
# Fix flash of error on startup:
#   Could not find platform independent libraries <prefix>.
#   Could not find platform dependent libraries <exec_prefix>
#   Consider setting $PYTHONHOME to <prefix>[:<exec_prefix>]
#   PlayerManager created
#   ObjectManager created
#   GameLogic created
#   Serversettings created
ENV PYTHONHOME=
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
CMD [ "./start.sh", "+modPath", "mods/fh2" ]

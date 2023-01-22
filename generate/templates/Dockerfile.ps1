@"
FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl

# Install Battlefield 2 server
WORKDIR /root
RUN curl -sSLO https://files.startersclan.com/ea/bf2/bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz
RUN sha256sum bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz | grep "^$( $VARIANT['_metadata']['installer_sha256sum'] ) "
RUN tar -zxvf bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz
ENV INSTALLER=bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.sh
RUN sh "`$INSTALLER" --target /install --noexec --info
RUN sh "`$INSTALLER" --target /install --noexec
RUN cd /install
RUN mkdir -p /server
RUN cat /install/license.sh | sed 's/^more/cat/' > /install/license-fixed.sh # Show the licenses without a pager
RUN cd /install && printf '\naccept\n\nyes\n/server\ny\n' | sh /install/license-fixed.sh # Agree to licenses


"@
if ('bf2hub' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2hub
WORKDIR /root
RUN curl -sSLO https://www.bf2hub.com/downloads/BF2Hub-Unranked-Linux-R3.tar.gz
RUN sha256sum BF2Hub-Unranked-Linux-R3.tar.gz | grep '^c4b3d583741c500e930502e96c6a43a40f223868c9ca1111c70d80c7e6d2cd2b '
RUN tar -C /server/bf2 -zxvf BF2Hub-Unranked-Linux-R3.tar.gz -- bin start_bf2hub.sh
RUN ls -al /server/bf2
RUN mv /server/bf2/start_bf2hub.sh /server/bf2/start.sh
RUN chmod +x /server/bf2/bin/ia-32/libbf2hub.so /server/bf2/bin/amd-64/libbf2hub.so


"@
}
if ('bf2hub' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2hub
WORKDIR /root
RUN curl -sSLO https://www.bf2hub.com/downloads/BF2Hub-Unranked-Linux-R3.tar.gz
RUN sha256sum BF2Hub-Unranked-Linux-R3.tar.gz | grep '^c4b3d583741c500e930502e96c6a43a40f223868c9ca1111c70d80c7e6d2cd2b '
RUN tar -C /server/bf2 -zxvf BF2Hub-Unranked-Linux-R3.tar.gz -- bin start_bf2hub.sh
RUN ls -al /server/bf2
RUN mv /server/bf2/start_bf2hub.sh /server/bf2/start.sh
RUN chmod +x /server/bf2/bin/ia-32/libbf2hub.so /server/bf2/bin/amd-64/libbf2hub.so


"@
}
if ('bf2all64' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2all64 mod
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://files.startersclan.com/ea/bf2/bf2all64_v1.0_setup.zip
RUN sha256sum bf2all64_v1.0_setup.zip | grep '^4ee82d91043c4afbf1bed50787cbf98af124bd7e6c608cdb0f5115c7761024f1 '
RUN unzip bf2all64_v1.0_setup.zip -d extract
RUN rm -rf /server/bf2/mods/bf2all64
RUN mv extract/bf2all64 /server/bf2/mods


"@
}
if ('bf2stats-2.2.0' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2stats 2
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/bf2stats/bf2statisitcs_2.2.0.zip # I know, it is mispelled
RUN sha256sum bf2statisitcs_2.2.0.zip | grep '^334b662727d64fb2d244b8958b4f3059dcd213488d2bc22f9bd0870995f74b1c '
RUN unzip bf2statisitcs_2.2.0.zip -d extract
RUN rm -rf /server/bf2/python
RUN mv "extract/bf2statisitcs 2.2.0/Server Files/Linux/python" /server/bf2/python


"@
}
if ('bf2stats-2.3.4' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2stats 2
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://github.com/startersclan/bf2stats/archive/refs/tags/2.3.4.zip
RUN sha256sum 2.3.4.zip | grep '^37b6c6f08d5ac146185db8f3b2eb41add5f3dfb30ec79dda1b3c86ae7cac17e0 '
RUN unzip 2.3.4.zip -d extract
RUN rm -rf /server/bf2/python
RUN mv extract/bf2stats-2.3.4/src/python /server/bf2/python


"@
}
if ('bf2stats-2.4.2' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2stats 2
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://github.com/startersclan/bf2stats/archive/refs/tags/2.4.2.zip
RUN sha256sum 2.4.2.zip | grep '^f7c47b22e30548737b05ddb9f8ef8e33a108b9184b4b2818759a318bd621f374 '
RUN unzip 2.4.2.zip -d extract
RUN rm -rf /server/bf2/python
RUN mv extract/bf2stats-2.4.2/src/python /server/bf2/python


"@
}
if ('bf2stats-3.1.0' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2stats 3
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://github.com/BF2Statistics/StatsPython/archive/2197486.zip
RUN sha256sum 2197486.zip | grep '^881ddc8f77a573be661f68a146883bc5e23b3d1b1a4d4323496d66d405744232 '
RUN unzip 2197486.zip -d 2197486
RUN cp -r 2197486/*/. /server/bf2/python/bf2/


"@
}
if ('bf2stats-3.1.2' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2stats 3
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://github.com/startersclan/StatsPython/archive/refs/tags/3.1.2.zip
RUN sha256sum 3.1.2.zip | grep '^21958c614ce880f63cd4c5a9db366ccacf68674cd89f50bbf95d9aa2d9bca878 '
RUN unzip 3.1.2.zip -d extract
RUN cp -r extract/*/. /server/bf2/python/bf2/


"@
}
if ('fh2' -in $VARIANT['_metadata']['components']) {
    @"
# Install Forgotten Hope 2 mod
WORKDIR /root
RUN curl -sSLO https://files.startersclan.com/ea/bf2/fh2-server-$( $VARIANT['_metadata']['mod_installer_version'] ).tar
RUN sha256sum fh2-server-$( $VARIANT['_metadata']['mod_installer_version'] ).tar | grep "$( $VARIANT['_metadata']['mod_installer_sha256sum'] )"
RUN tar -C /server/bf2 -xvf fh2-server-$( $VARIANT['_metadata']['mod_installer_version'] ).tar
RUN chown -R root:root /server/bf2
RUN chmod +x /server/bf2/start-fh2.sh
RUN chmod -R +x /server/bf2/bin
RUN mv /server/bf2/start-fh2.sh /server/bf2/start.sh
RUN for i in `$( ls /server/bf2/mods/fh2/levels/*/info/*cq_64_menumap.png | cut -d '/' -f7 ); do echo "maplist.append \"`$i\" \"gpm_cq\" 64" >> /server/bf2/mods/fh2/settings/maplist.con; done # Create a default maplist.con, since it is not included by the installer


"@
}

@'
# Install ESAI in all mods
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
COPY ESAI-Standard-v4.2.zip ESAI-Standard-v4.2.zip
RUN sha256sum ESAI-Standard-v4.2.zip | grep ef4e5d0f1446b9a2ddb0b350f1334273681c0f64d9c38c506320db769b24499c
# Lowercase all files in ESAI folder
COPY lowercase-helper /usr/local/bin/lowercase-helper
RUN for i in $( ls /server/bf2/mods ); do \
        unzip ESAI-Standard-v4.2.zip -d /server/bf2/mods/$i; \
        lowercase-helper --dir "/server/bf2/mods/$i/ESAI"; \
    done
# Lowercase ESAI mapfiles' content
RUN for i in $( find /server/bf2/mods/*/esai/mapfiles -type f ); do \
        CONTENT=$( cat "$i" ); \
        echo "$CONTENT" | tr '[:upper:]' '[:lower:]' > "$i"; \
    done


'@

@"
FROM ubuntu:16.04 AS final
COPY --from=install /server /server
COPY esai-helper /usr/local/bin/esai-helper
COPY esai-optimized-strategies-bf2.txt /esai-optimized-strategies-bf2.txt
COPY esai-optimized-strategies-bf2all64.txt /esai-optimized-strategies-bf2all64.txt
COPY esai-optimized-strategies-xpack.txt /esai-optimized-strategies-xpack.txt
COPY healthcheck /healthcheck
COPY lowercase-helper /usr/local/bin/lowercase-helper
# Install network utilities which can be useful for debugging issues
# Install unzip and zip for the sake of applying ESAI strategies in ./mods/*/levels/*/server.zip at './GameModes/[gpm_coop|gpm_cq|sp1|sp2|sp3]/[16|32|64]/AI/Strategies.ai'
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update  \
    && apt-get install --no-install-recommends -y \
        ca-certificates \
        conntrack dnsutils iproute2 netcat net-tools tcpdump \
        unzip zip \
    && rm -rf /var/lib/apt/lists/*

"@
if ('fh2' -in $VARIANT['_metadata']['components']) {
    @"
# Install fh2 dependencies
# Fix error: /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.22' not found (required by /server/bf2/bin/amd-64/fh2utils.so)
# See: https://stackoverflow.com/questions/43070900/version-glibcxx-3-4-22-not-found
RUN apt-get update && apt-get install -y apt-transport-https software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y gcc-4.9 \
    && apt-get upgrade -y libstdc++6 \
    && strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX \
    && add-apt-repository ppa:ubuntu-toolchain-r/test --remove \
    && apt-get purge --auto-remove -y apt-transport-https software-properties-common gcc-4.9
# Fix flash of error on startup:
#   Could not find platform independent libraries <prefix>.
#   Could not find platform dependent libraries <exec_prefix>
#   Consider setting `$PYTHONHOME to <prefix>[:<exec_prefix>]
#   PlayerManager created
#   ObjectManager created
#   GameLogic created
#   Serversettings created
ENV PYTHONHOME=

"@
}
@"
# EXPOSE 16567/udp
# EXPOSE 29900/udp
# HEALTHCHECK CMD /healthcheck
WORKDIR /server/bf2

"@
if ('bf2all64' -in $VARIANT['_metadata']['components']) {
    @"
CMD [ "./start.sh", "+modPath", "mods/bf2all64" ]

"@
}elseif ('fh2' -in $VARIANT['_metadata']['components']) {
    @"
CMD [ "./start.sh", "+modPath", "mods/fh2" ]

"@
}else {
    @"
CMD [ "./start.sh" ]

"@
}


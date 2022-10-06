@"
FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl

# Install Battlefield 2 server
WORKDIR /root
RUN curl -sSLO ftp://ftp.bf-games.net/server-files/bf2/bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz
RUN tar -zxvf bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz
ENV INSTALLER=bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.sh
RUN sha256sum "`$INSTALLER" | grep "^$( $VARIANT['_metadata']['installer_sha256sum'] ) "
RUN sh "`$INSTALLER" --target /install --noexec --info
RUN sh "`$INSTALLER" --target /install --noexec
RUN cd /install
RUN mkdir -p /server
RUN cat /install/license.sh | sed 's/^more/cat/' > /install/license-fixed.sh # Show the licenses without a pager
RUN cd /install && printf '\naccept\n\nyes\n/server\ny\n' | sh /install/license-fixed.sh # Agree to licenses

# Install ESAI
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
COPY ESAI-Standard-v4.2.zip ESAI-Standard-v4.2.zip
RUN sha256sum ESAI-Standard-v4.2.zip | grep ef4e5d0f1446b9a2ddb0b350f1334273681c0f64d9c38c506320db769b24499c
RUN unzip ESAI-Standard-v4.2.zip -d /server/bf2/mods/bf2
COPY lowercase-helper /usr/local/bin/lowercase-helper
RUN lowercase-helper --dir /server/bf2/mods/bf2/ESAI # Lowercase ESAI folder and its descendent folders


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
if ('bf2stats-2.3.0' -in $VARIANT['_metadata']['components']) {
    @"
# Install bf2stats 2.3.0
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://github.com/startersclan/bf2stats/archive/refs/tags/2.3.0.zip
RUN sha256sum 2.3.0.zip | grep '^4e91c5cdda63aaff1e2ccc20f40befcb603000eac25221be4cefbdebfdee6aec '
RUN unzip 2.3.0.zip -d extract
RUN rm -rf /server/bf2/python
RUN mv extract/bf2stats-2.3.0/src/python /server/bf2/python


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
if ('fh2' -in $VARIANT['_metadata']['components']) {
    @"
# Install Forgotten Hope 2 mod
WORKDIR /root
RUN curl -sSLO http://fhbeta.warumdarum.de/~spitfire/fh2pub/2.63/fh2-server-$( $VARIANT['_metadata']['mod_installer_version'] ).tar
RUN sha256sum fh2-server-$( $VARIANT['_metadata']['mod_installer_version'] ).tar | grep "$( $VARIANT['_metadata']['mod_installer_sha256sum'] )"
RUN tar -C /server/bf2 -xvf fh2-server-$( $VARIANT['_metadata']['mod_installer_version'] ).tar
RUN chown -R root:root /server/bf2
RUN chmod +x /server/bf2/start-fh2.sh
RUN chmod -R +x /server/bf2/bin
RUN mv /server/bf2/start-fh2.sh /server/bf2/start.sh
RUN for i in `$( ls /server/bf2/mods/fh2/levels/*/info/*cq_64_menumap.png | cut -d '/' -f7 ); do echo "maplist.append \"`$i\" \"gpm_cq\" 64" >> /server/bf2/mods/fh2/settings/maplist.con; done # Create a default maplist.con, since it is not included by the installer

# Install ESAI for fh2
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
COPY ESAI-Standard-v4.2.zip ESAI-Standard-v4.2.zip
RUN sha256sum ESAI-Standard-v4.2.zip | grep ef4e5d0f1446b9a2ddb0b350f1334273681c0f64d9c38c506320db769b24499c
RUN unzip ESAI-Standard-v4.2.zip -d /server/bf2/mods/fh2


"@
}


@"
FROM ubuntu:16.04 AS final
COPY --from=install /server /server
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
# Install unzip and zip for the sake of applying ESAI in mods/*/levels/server.zip at GameModes/[gpm_coop|gpm_cq|sp1|sp2|sp3]/[16|32|64]/AI/Strategies.ai
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip zip
COPY esai-helper /usr/local/bin/esai-helper
COPY esai-optimized-strategies-bf2.txt /esai-optimized-strategies-bf2.txt
COPY esai-optimized-strategies-xpack.txt /esai-optimized-strategies-xpack.txt
COPY lowercase-helper /usr/local/bin/lowercase-helper

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
EXPOSE 16567/udp
EXPOSE 29900/udp
WORKDIR /server/bf2
CMD [ "./start.sh" ]
"@





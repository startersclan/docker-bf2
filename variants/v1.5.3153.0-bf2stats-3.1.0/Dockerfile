FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl

# Install Battlefield 2 server
WORKDIR /root
RUN curl -sSLO ftp://ftp.bf-games.net/server-files/bf2/bf2-linuxded-1.5.3153.0-installer.tgz
RUN tar -zxvf bf2-linuxded-1.5.3153.0-installer.tgz
ENV INSTALLER=bf2-linuxded-1.5.3153.0-installer.sh
RUN sha256sum "$INSTALLER" | grep "^b5afe6602280b99797b46389f3cd582bbfe212e7402c8b009b72e6ae41e8d435 "
RUN sh "$INSTALLER" --target /install --noexec --info
RUN sh "$INSTALLER" --target /install --noexec
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

# Install bf2stats 3
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://github.com/BF2Statistics/StatsPython/archive/2197486.zip
RUN sha256sum 2197486.zip | grep '^881ddc8f77a573be661f68a146883bc5e23b3d1b1a4d4323496d66d405744232 '
RUN unzip 2197486.zip -d 2197486
RUN cp -r 2197486/*/. /server/bf2/python/bf2/

FROM ubuntu:16.04 AS final
COPY --from=install /server /server
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
# Install unzip and zip for the sake of applying ESAI in mods/*/levels/server.zip at GameModes/[gpm_coop|gpm_cq|sp1|sp2|sp3]/[16|32|64]/AI/Strategies.ai
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip zip
COPY esai-helper /usr/local/bin/esai-helper
COPY esai-optimized-strategies-bf2.txt /esai-optimized-strategies-bf2.txt
COPY esai-optimized-strategies-xpack.txt /esai-optimized-strategies-xpack.txt
COPY lowercase-helper /usr/local/bin/lowercase-helper
EXPOSE 16567/udp
EXPOSE 29900/udp
WORKDIR /server/bf2
CMD [ "./start.sh" ]
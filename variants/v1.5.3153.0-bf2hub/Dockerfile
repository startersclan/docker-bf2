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

# Install bf2hub
WORKDIR /root
RUN curl -sSLO https://www.bf2hub.com/downloads/BF2Hub-Unranked-Linux-R3.tar.gz
RUN sha256sum BF2Hub-Unranked-Linux-R3.tar.gz | grep '^c4b3d583741c500e930502e96c6a43a40f223868c9ca1111c70d80c7e6d2cd2b '
RUN tar -C /server/bf2 -zxvf BF2Hub-Unranked-Linux-R3.tar.gz -- bin start_bf2hub.sh
RUN ls -al /server/bf2
RUN mv /server/bf2/start_bf2hub.sh /server/bf2/start.sh
RUN chmod +x /server/bf2/bin/ia-32/libbf2hub.so /server/bf2/bin/amd-64/libbf2hub.so

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

FROM ubuntu:16.04 AS final
COPY --from=install /server /server
COPY esai-helper /usr/local/bin/esai-helper
COPY esai-optimized-strategies-bf2.txt /esai-optimized-strategies-bf2.txt
COPY esai-optimized-strategies-xpack.txt /esai-optimized-strategies-xpack.txt
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
EXPOSE 16567/udp
EXPOSE 29900/udp
# HEALTHCHECK CMD nc -w 1 -vzu 127.0.0.1 16567 && nc -w 1 -vzu 127.0.0.1 29900
WORKDIR /server/bf2
CMD [ "./start.sh" ]

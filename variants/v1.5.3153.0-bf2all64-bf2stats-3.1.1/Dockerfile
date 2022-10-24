FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl

# Install Battlefield 2 server
WORKDIR /root
RUN curl -sSLO https://files.startersclan.com/ea/bf2/bf2-linuxded-1.5.3153.0-installer.tgz
RUN sha256sum bf2-linuxded-1.5.3153.0-installer.tgz | grep "^4d849218c1725e7bd6a7e7f164e27b036248f8ded2e30340dd0722c1dfffbab6 "
RUN tar -zxvf bf2-linuxded-1.5.3153.0-installer.tgz
ENV INSTALLER=bf2-linuxded-1.5.3153.0-installer.sh
RUN sh "$INSTALLER" --target /install --noexec --info
RUN sh "$INSTALLER" --target /install --noexec
RUN cd /install
RUN mkdir -p /server
RUN cat /install/license.sh | sed 's/^more/cat/' > /install/license-fixed.sh # Show the licenses without a pager
RUN cd /install && printf '\naccept\n\nyes\n/server\ny\n' | sh /install/license-fixed.sh # Agree to licenses

# Install bf2all64 mod
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://files.startersclan.com/ea/bf2/bf2all64_v1.0_setup.zip
RUN sha256sum bf2all64_v1.0_setup.zip | grep '^4ee82d91043c4afbf1bed50787cbf98af124bd7e6c608cdb0f5115c7761024f1 '
RUN unzip bf2all64_v1.0_setup.zip -d extract
RUN rm -rf /server/bf2/mods/bf2all64
RUN mv extract/bf2all64 /server/bf2/mods

# Install bf2stats 3
WORKDIR /root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y unzip
RUN curl -sSLO https://github.com/startersclan/StatsPython/archive/refs/tags/3.1.1.zip
RUN sha256sum 3.1.1.zip | grep '^fb739d900ea59e82147a6da9d7e72b329425b315bd8a08749a90fefc15365798 '
RUN unzip 3.1.1.zip -d extract
RUN cp -r extract/*/. /server/bf2/python/bf2/

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
COPY esai-optimized-strategies-bf2all64.txt /esai-optimized-strategies-bf2all64.txt
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

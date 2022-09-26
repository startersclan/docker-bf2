@"
FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl

RUN curl -sSLO ftp://ftp.bf-games.net/server-files/bf2/bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz
RUN tar -zxvf bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.tgz
ENV INSTALLER=bf2-linuxded-$( $VARIANT['_metadata']['installer_version'] )-installer.sh
RUN sha1sum "`$INSTALLER" | grep "^$( $VARIANT['_metadata']['installer_sha1sum'] ) "
RUN sh "`$INSTALLER" --target /install --noexec --info
RUN sh "`$INSTALLER" --target /install --noexec
RUN cd /install
RUN mkdir -p /server
RUN cat /install/license.sh | sed 's/^more/cat/' > /install/license-fixed.sh # Show the licenses without a pager
RUN cd /install && printf '\naccept\n\nyes\n/server\ny\n' | sh /install/license-fixed.sh # Agree to licenses

FROM ubuntu:16.04 AS final
COPY --from=install /server /server
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /server/bf2
CMD [ "./start.sh" ]
"@

$VARIANT['_metadata']['components'] | % {
    $component = $_

    switch( $component ) {
        default {
            throw "No such component: $component"
        }
    }
}

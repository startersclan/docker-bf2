FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl

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

WORKDIR /root
RUN curl -ssLO http://fhbeta.warumdarum.de/~spitfire/fh2pub/2.63/fh2-server-4.6.304.tar
RUN sha256sum fh2-server-4.6.304.tar | grep "bb933052ad20928b5a4bc6c1eeff647d62b0f3b38de46d063101719a9f0cf488"
RUN tar -C /server/bf2 -xvf fh2-server-4.6.304.tar
RUN chown -R root:root /server/bf2
RUN chmod +x /server/bf2/start-fh2.sh
RUN chmod -R +x /server/bf2/bin
RUN mv /server/bf2/start-fh2.sh /server/bf2/start.sh
RUN for i in $( ls /server/bf2/mods/fh2/levels/*/info/*cq_64_menumap.png | cut -d '/' -f7 ); do echo "maplist.append \"$i\" \"gpm_cq\" 64" >> /server/bf2/mods/fh2/settings/maplist.con; done # Create a default maplist.con, since it is not included by the installer

FROM ubuntu:16.04 AS final
COPY --from=install /server /server
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
# Install fh2 dependencies
# Fix error: /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version GLIBCXX_3.4.22' not found (required by /server/bf2/bin/amd-64/fh2utils.so)
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
#   Consider setting $PYTHONHOME to <prefix>[:<exec_prefix>]
#   PlayerManager created
#   ObjectManager created
#   GameLogic created
#   Serversettings created
ENV PYTHONHOME=
WORKDIR /server/bf2
CMD [ "./start.sh" ]
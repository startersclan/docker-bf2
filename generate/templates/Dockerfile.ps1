@"
FROM ubuntu:16.04 as install
ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM=linux/amd64
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

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
    curl -sSLO https://files.startersclan.com/ea/bf2/bf2-linuxded-$( $VARIANT['_metadata']['package_version'] )-installer.tgz; \
    sha256sum bf2-linuxded-$( $VARIANT['_metadata']['package_version'] )-installer.tgz | grep "^$( $VARIANT['_metadata']['package_sha256sum'] ) "; \
    tar -zxvf bf2-linuxded-$( $VARIANT['_metadata']['package_version'] )-installer.tgz; \
    sh bf2-linuxded-$( $VARIANT['_metadata']['package_version'] )-installer.sh --target /install --noexec --info; \
    sh bf2-linuxded-$( $VARIANT['_metadata']['package_version'] )-installer.sh --target /install --noexec; \
    rm -v bf2-linuxded-$( $VARIANT['_metadata']['package_version'] )-installer.sh; \
    rm -v bf2-linuxded-$( $VARIANT['_metadata']['package_version'] )-installer.tgz; \
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


"@
foreach ($c in $VARIANT['_metadata']['components']) {
    if ($c -eq 'aix2') {
@"
# Install AIX 2.0
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://files.startersclan.com/ea/bf2/AIX2.0_Server_Files.zip; \
    sha256sum AIX2.0_Server_Files.zip | grep '^8bd635ab6db23e237e77a58f269e0929afac719fabdf9e7979ce1cf3f836b11a '; \
    unzip AIX2.0_Server_Files.zip -d extract; \
    rm -rf /server/bf2/mods/aix2; \
    mv extract/mods/aix2 /server/bf2/mods; \
    rm -fv AIX2.0_Server_Files.zip; \
    # Fix serversettings.con for server to start properly
    sed -i 's/^sv.internet 1/sv.internet 0/' /server/bf2/mods/aix2/settings/serversettings.con;


"@
    }
    if ($c -eq 'bf2hub') {
@"
# Install bf2hub
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://www.bf2hub.com/downloads/BF2Hub-Unranked-Linux-R3.tar.gz; \
    sha256sum BF2Hub-Unranked-Linux-R3.tar.gz | grep '^c4b3d583741c500e930502e96c6a43a40f223868c9ca1111c70d80c7e6d2cd2b '; \
    tar -zxvf BF2Hub-Unranked-Linux-R3.tar.gz -C /server/bf2 -- bin start_bf2hub.sh; \
    ls -al /server/bf2; \
    mv /server/bf2/start_bf2hub.sh /server/bf2/start.sh; \
    chmod +x /server/bf2/bin/ia-32/libbf2hub.so /server/bf2/bin/amd-64/libbf2hub.so; \
    rm -fv BF2Hub-Unranked-Linux-R3.tar.gz;


"@
    }
    if ($c -eq 'bf2all64') {
@"
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


"@
    }
    if ($c -match 'bf2stats-(2\.\d+\.\d+)') {
        $v = $matches[1]
        if ($v -eq '2.2.0') {
@"
# Install bf2stats $v
WORKDIR /root
RUN set -eux; \
    # I know, it is mispelled
    curl -sSLO https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/bf2stats/bf2statisitcs_2.2.0.zip; \
    sha256sum bf2statisitcs_2.2.0.zip | grep '^334b662727d64fb2d244b8958b4f3059dcd213488d2bc22f9bd0870995f74b1c '; \
    unzip bf2statisitcs_2.2.0.zip -d extract; \
    rm -rf /server/bf2/python; \
    mv "extract/bf2statisitcs 2.2.0/Server Files/Linux/python" /server/bf2/python; \
    rm -fv bf2statisitcs_2.2.0.zip;


"@
        } else {
@"
# Install bf2stats $v
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://github.com/startersclan/bf2stats/archive/refs/tags/$v.zip; \
    echo "$( $PASS_VARIABLES['bf2stats_2_sha256sum'] -split "`n" | % { $_.Trim() } | Select-String -SimpleMatch "$v.zip" )" | sha256sum -c -; \
    unzip $v.zip -d extract; \
    rm -rf /server/bf2/python; \
    mv extract/bf2stats-$v/src/python /server/bf2/python; \
    rm -fv $v.zip;


"@
        }
    }

    if ($c -match 'bf2stats-(3\.\d+\.\d+)') {
        $v = $matches[1]
        if ([version]$v -le [version]'3.2.0') {
@"
# Install bf2stats $v
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://github.com/startersclan/StatsPython/archive/refs/tags/$v.zip; \
    echo "$( $PASS_VARIABLES['bf2stats_3_statspython_sha256sum'] -split "`n" | % { $_.Trim() } | Select-String -SimpleMatch "$v.zip" )" | sha256sum -c -; \
    unzip $v.zip -d extract; \
    cp -r extract/*/. /server/bf2/python/bf2/; \
    rm -fv $v.zip;


"@
        }else {
@"
# Install bf2stats $v
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://github.com/startersclan/asp/archive/refs/tags/$v.zip; \
    echo "$( $PASS_VARIABLES['bf2stats_3_sha256sum'] -split "`n" | % { $_.Trim() } | Select-String -SimpleMatch "$v.zip" )" | sha256sum -c -; \
    unzip $v.zip -d extract; \
    rm -rf /server/bf2/python; \
    mv extract/asp-$v/src/python /server/bf2/python; \
    rm -fv $v.zip;
"@
        }
    }

    if ($c -match 'fh2-(\d+\.\d+\.\d+)') {
        $v = $matches[1]
@"
# Install Forgotten Hope 2 $v
WORKDIR /root
RUN set -eux; \
    curl -sSLO https://files.startersclan.com/ea/bf2/fh2-server-$v.tar; \
    echo "$( $PASS_VARIABLES['fh2_sha256sum'] -split "`n" | % { $_.Trim() } | Select-String -SimpleMatch "$v.tar" )" | sha256sum -c -; \
    tar -xvf fh2-server-$v.tar --no-same-owner -C /server/bf2 ; \
    chmod -R +x /server/bf2/bin; \
    mv /server/bf2/start-fh2.sh /server/bf2/start.sh; \
    chmod +x /server/bf2/start.sh; \
    # Create a default maplist.con, since it is not included by the installer
    for i in `$( ls /server/bf2/mods/fh2/levels/*/info/*cq_64_menumap.png | cut -d '/' -f7 ); do echo "maplist.append \"`$i\" \"gpm_cq\" 64" >> /server/bf2/mods/fh2/settings/maplist.con; done; \
    rm -fv fh2-server-$v.tar;

# Install fh2 dependencies
# Fix error: /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.22' not found (required by /server/bf2/bin/amd-64/fh2utils.so)
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
#   Consider setting `$PYTHONHOME to <prefix>[:<exec_prefix>]
#   PlayerManager created
#   ObjectManager created
#   GameLogic created
#   Serversettings created
ENV PYTHONHOME=

"@
    }
}

@'
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

'@
if ($VARIANT['_metadata']['components'] -contains 'bf2all64') {
@'
COPY esai-optimized-strategies-bf2all64.txt /esai-optimized-strategies-bf2all64.txt

'@
}
@'
COPY esai-optimized-strategies-xpack.txt /esai-optimized-strategies-xpack.txt

COPY healthcheck /healthcheck

# EXPOSE 16567/udp
# EXPOSE 29900/udp
# HEALTHCHECK CMD /healthcheck
WORKDIR /server/bf2

'@
if ($VARIANT['_metadata']['components'] -contains 'aix2') {
@"
CMD [ "./start.sh", "+modPath", "mods/aix2" ]

"@
}elseif ($VARIANT['_metadata']['components'] -contains 'bf2all64') {
@"
CMD [ "./start.sh", "+modPath", "mods/bf2all64" ]

"@
}elseif ($VARIANT['_metadata']['components'] -match 'fh2') {
@"
CMD [ "./start.sh", "+modPath", "mods/fh2" ]

"@
}else {
@"
CMD [ "./start.sh" ]

"@
}


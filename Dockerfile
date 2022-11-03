FROM ubuntu:jammy AS charmcraft
RUN set -eux; \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        jq curl ca-certificates squashfs-tools && \
    curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/charmcraft' | jq '.download_url' -r) --output charmcraft.snap && \
    mkdir -p /snap && unsquashfs -d /snap/charmcraft charmcraft.snap

FROM ubuntu:jammy AS juju
RUN set -eux; \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        jq curl ca-certificates squashfs-tools && \
    curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/juju' | jq '.download_url' -r) --output juju.snap && \
    mkdir -p /snap && unsquashfs -d /snap/juju juju.snap

FROM ubuntu:jammy AS lxd
RUN set -eux; \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        jq curl ca-certificates squashfs-tools && \
    curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/lxd' | jq '.download_url' -r) --output lxd.snap && \
    mkdir -p /snap && unsquashfs -d /snap/lxd lxd.snap

FROM ubuntu:jammy AS microk8s
RUN set -eux; \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        jq curl ca-certificates squashfs-tools && \
    curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/microk8s' | jq '.download_url' -r) --output microk8s.snap && \
    mkdir -p /snap && unsquashfs -d /snap/microk8s microk8s.snap

FROM ubuntu:jammy

LABEL maintainer="Ubuntu Server team <ubuntu-server@lists.ubuntu.com>"

ENV TZ=UTC PATH=/opt/charmcraft/bin:/opt/juju/bin:/opt/lxd/bin:/opt/microk8s:$PATH

RUN apt-get update && apt-get install python3 -y

COPY --from=charmcraft /snap/charmcraft /opt/charmcraft
COPY --from=juju /snap/juju /opt/juju
COPY --from=lxd /snap/lxd /opt/lxd
COPY --from=microk8s /snap/microk8s /opt/microk8s

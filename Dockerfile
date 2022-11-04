FROM ubuntu:jammy AS snaps
RUN set -eux; \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        jq curl ca-certificates squashfs-tools && \
    curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/charmcraft' | jq '.download_url' -r) --output charmcraft.snap && \
    mkdir -p /snap && unsquashfs -d /snap/charmcraft charmcraft.snap && \
    curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/juju' | jq '.download_url' -r) --output juju.snap && \
    unsquashfs -d /snap/juju juju.snap && \
    curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/lxd' | jq '.download_url' -r) --output lxd.snap && \
    unsquashfs -d /snap/lxd lxd.snap && \
    curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/microk8s' | jq '.download_url' -r) --output microk8s.snap && \
    unsquashfs -d /snap/microk8s microk8s.snap

FROM ubuntu:focal

LABEL maintainer="Data team <data-platform@canonical.com>"

ENV TZ=UTC PATH=$PATH:/opt/charmcraft/bin:/opt/juju/bin:/opt/lxd/bin:/opt/microk8s
ENV PYTHONPATH "${PYTHONPATH}:/opt/charmcraft/lib"

RUN apt-get update && apt-get install python3 python3-distutils sudo -y

COPY --from=snaps /snap/charmcraft /opt/charmcraft
COPY --from=snaps /snap/juju /opt/juju
COPY --from=snaps /snap/lxd /opt/lxd
COPY --from=snaps /snap/microk8s /opt/microk8s
RUN sed "s/#!\/bin\/bash/#!\/bin\/bash\nSNAP=\/opt\/microk8s/" /opt/microk8s/*.wrapper -i
RUN echo 'alias microk8s="microk8s.wrapper"' >> ~/.bashrc

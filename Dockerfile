FROM ubuntu:jammy
ENV container docker
ENV PATH /snap/bin:$PATH
COPY snap /usr/local/bin/snap
COPY custom.service /etc/systemd/system/custom.service
RUN apt-get update
RUN apt-get install -y snapd=2.57.5+22.04 =0.1.103-3 fuse=2.9.9-5ubuntu3 sudo=1.9.9-1ubuntu2.1
RUN systemctl enable snapd
RUN systemctl enable custom
STOPSIGNAL SIGRTMIN+3
CMD [ "/sbin/init" ]

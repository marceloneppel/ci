FROM ubuntu:jammy
ENV container docker
ENV PATH /snap/bin:$PATH
ADD snap /usr/local/bin/snap
ADD custom.service /etc/systemd/system/custom.service
RUN apt-get update
RUN apt-get install -y snapd squashfuse fuse
RUN systemctl enable snapd
RUN systemctl enable custom
STOPSIGNAL SIGRTMIN+3
CMD [ "/sbin/init" ]

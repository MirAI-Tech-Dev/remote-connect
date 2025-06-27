#------------------------
# Dockerfile:
# ssh-proxy_server
#------------------------

# FROM ubuntu:24.04
# RUN apt-get update && apt-get upgrade -y && \
#     apt-get install -y \
#     sudo \
#     nano \
#     wget \
#     locales \
#     cron \
#     curl

# # network
# RUN apt-get install -y dnsutils iputils-ping iproute2

# # mail + mount config from host
# # -v /etc/dma:/etc/dma:ro -v /etc/aliases:/etc/aliases:ro
# RUN apt-get install -y dma

# use pre-built base image with above installed packages
FROM stage-0-24.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
    openssh-server \
    netcat-openbsd rsyslog sshguard

# health check
COPY health-check.sh /
RUN chmod 555 /health-check.sh
HEALTHCHECK --interval=30s --timeout=3s \
  CMD /health-check.sh || exit 1

RUN mkdir -p /srv/ssh

# for jump host
# trampolin:x:10050:10050:,,,:/home/trampolin:/bin/bash
RUN export uid=10050 gid=10050 && \
    groupadd -g ${gid} trampolin && \
    useradd -u ${uid} -g ${gid} -d /home/trampolin -m -s /bin/bash trampolin

RUN mkdir -p /home/trampolin/.ssh
COPY trampolin/ssh_config /home/trampolin/.ssh/config
COPY trampolin/authorized_keys /home/trampolin/.ssh/

# for reverse proxy
# backflip:x:10060:10060:,,,:/home/backflip:/bin/bash
RUN export uid=10060 gid=10060 && \
    groupadd -g ${gid} backflip && \
    useradd -u ${uid} -g ${gid} -d /home/backflip -m -s /bin/bash backflip

RUN mkdir -p /home/backflip/.ssh
COPY backflip/ssh_config /home/backflip/.ssh/config
COPY backflip/authorized_keys /home/backflip/.ssh/

# sshguard
COPY sshguard_config /etc/sshguard/sshguard.conf
COPY sshguard_whitelist /etc/sshguard/whitelist

COPY init.sh /
RUN chmod 555 /init.sh
ENTRYPOINT ["/init.sh"]

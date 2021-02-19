FROM debian:buster

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

ENV GITLAB_URL "https://gitlab.com/"
ENV GITLAB_TOKEN "TOKEN"
ENV GITLAB_TAGS "tags"


RUN apt-get update && apt-get install -y nano curl git

RUN curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | bash
RUN apt-get install -y gitlab-runner

RUN apt-get update \
    && apt-get install -y systemd systemd-sysv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

VOLUME [ "/sys/fs/cgroup" ]

COPY ./docker-entrypoint.sh /root/docker-entrypoint.sh
RUN ["chmod", "+x", "/root/docker-entrypoint.sh"]
ENTRYPOINT ["sh", "/root/docker-entrypoint.sh"]

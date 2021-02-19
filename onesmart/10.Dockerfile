FROM debian:buster

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

ENV GITLAB_URL "https://gitlab.com/"
ENV GITLAB_TOKEN "PROJECT_REGISTRATION_TOKEN"
ENV GITLAB_TAGS "tags"


RUN apt-get update && apt-get install -y nano curl git
RUN curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb"
RUN dpkg -i gitlab-runner_amd64.deb


RUN gitlab-runner register \
  --non-interactive \
  --url $GITLAB_URL \
  --registration-token $GITLAB_TOKEN \
  --executor "shell" \
  --tag-list $GITLAB_TAGS


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

CMD ["/lib/systemd/systemd"]


FROM phusion/baseimage:0.9.19

# baseimage-docker fix, see https://github.com/phusion/baseimage-docker/issues/338#issuecomment-262201813
RUN sed -i 's/^su root syslog/su root adm/' /etc/logrotate.conf

RUN apt-get update && apt-get install -y \
		curl \
		ca-certificates \
		git \
	--no-install-recommends && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Git LFS from PackageCloud
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
	&& apt-get update \
	&& apt-get install -y git-lfs --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Deploy local files to target system
COPY ./docker-assets /
RUN chmod -R +x /etc/service/*
RUN chmod +x /etc/my_init.d/*

VOLUME ["/opt/gitlab-remote-mirror"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

#!/bin/bash

if [ ! -f "/opt/gitlab-remote-mirror/crontab" ]; then
	echo "Error! Can not find local crontab file. Did you forgot to create one from the crontab.dist file?" 1>&2
	exit 1
fi

\cp -rf "/opt/gitlab-remote-mirror/crontab" "/etc/cron.d/gitlab-remote-mirror"
chmod 0644 "/etc/cron.d/gitlab-remote-mirror"

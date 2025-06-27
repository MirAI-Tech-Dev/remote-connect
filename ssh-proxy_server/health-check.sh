#!/bin/bash

touch /health-check.failed

pgrep sshd || exit 1
pgrep rsyslogd || /usr/sbin/rsyslogd
pgrep rsyslogd || exit 1
pgrep sshguard || exit 1

# all passed

rm /health-check.failed

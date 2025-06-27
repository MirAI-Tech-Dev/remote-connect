#!/bin/bash

LOGF=/etc/ssh/logs/container.log

[ -e /etc/resolv.conf.override ] && cp /etc/resolv.conf.override /etc/resolv.conf

chmod 700 /home/trampolin/.ssh
chmod 600 /home/trampolin/.ssh/authorized_keys
chown -R trampolin: /home/trampolin

chmod 700 /home/backflip/.ssh
chmod 600 /home/backflip/.ssh/authorized_keys
chown -R backflip: /home/backflip

[ -e /etc/ssh/ssh_host_keys_deleted ] && \
    dpkg-reconfigure openssh-server && \
    rm /etc/ssh/ssh_host_keys_deleted


# disable password login
if $(grep -q -e '^PasswordAuthentication' /etc/ssh/sshd_config);then
    echo "PasswordAuthentication disabled";
else
    echo "PasswordAuthentication not set";
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
fi

# disable root login
if $(grep -q -e '^PermitRootLogin' /etc/ssh/sshd_config);then
    echo "PermitRootLogin disabled";
else
    echo "PermitRootLogin not set";
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
fi

# rsyslog disable kernel log
sed -i 's/^module(load="imklog"/#module(load="imklog"/g' /etc/rsyslog.conf
mkdir -p /etc/ssh/logs
chown syslog:adm /etc/ssh/logs
echo 'auth,authpriv.*   /etc/ssh/logs/auth.log' > /etc/rsyslog.d/50-default.conf
echo '*.*;auth,authpriv.none  -/var/log/syslog' >> /etc/rsyslog.d/50-default.conf
sed -i 's/\/var\/log\/auth.log/\/etc\/ssh\/logs\/auth.log/g' /etc/logrotate.d/rsyslog
# auth.log keep 12 weeks
sed -i 's/rotate 4/rotate 12/g' /etc/logrotate.d/rsyslog
# link latest to /var/log
ln -sf /etc/ssh/logs/auth.log /var/log/auth.log

# delete systemd from pam
sed -i '/.*systemd.*/d' /etc/pam.d/*

#Define cleanup procedure
cleanup() {
    echo "########################################" >> ${LOGF}
    echo "Container stopped, performing cleanup..." >> ${LOGF}
    echo "stop ssh-server: $(date)" >> ${LOGF}
    /etc/init.d/ssh stop
    echo "stop ssh-guard: $(date)" >> ${LOGF}
    pkill sshguard
    echo "stop rsyslog-server: $(date)" >> ${LOGF}
    #/etc/init.d/rsyslog stop
    kill -HUP $(cat /var/run/rsyslogd.pid)
    echo "Done: $(date) -> rotating log..." >> ${LOGF}
    logrotate -v /etc/logrotate.conf 2>&1 | \
        grep 'considering.*auth.log' -A4 >> ${LOGF}
    echo "########################################" >> ${LOGF}
    mv ${LOGF} ${LOGF}.1
    # cat for docker logs
    cat ${LOGF}.1
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

echo "start rsyslog-server: $(date)" >> ${LOGF}
#/etc/init.d/rsyslog start
/usr/sbin/rsyslogd

echo "start ssh-server: $(date)" >> ${LOGF}
/etc/init.d/ssh start

echo "start sshguard: $(date)" >> ${LOGF}
/usr/sbin/sshguard -l /etc/ssh/logs/auth.log & >> ${LOGF}

# syslog and auth lod
sleep 5 && tail -f /etc/ssh/logs/auth.log&
sleep 5 && tail -f /var/log/syslog&

# keep container alive
tail -f /dev/null &

#Wait
wait $!

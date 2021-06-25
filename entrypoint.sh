#!/bin/bash
mkdir -p /data/etc
mkdir -p /data/var
mkdir -p /data/log
echo "127.0.0.5 ldap.localdomain" >> /etc/hosts
if [ -z "$ADMINUSER" ]; then
    echo "ADMINUSER variable not defined"
    exit 1
fi
if [ -z $ADMINPASS ]; then
    echo "ADMINPASS variable not defined"
    exit 2
fi
if [ -z $SUFFIX ]; then
    echo "SUFFIX variable not defined"
    exit 3
fi
if [ -z $DMUSER ]; then
    echo "DMUSER variable not defined"
    exit 4
fi
if [ -z $DMPASS ]; then
    echo "DMPASS variable not defined"
    exit 5
fi

sed -e "s/__ADMINUSER__/$ADMINUSER/g" -e "s/__ADMINPASS__/$ADMINPASS/g" -e "s/__SUFFIX__/$SUFFIX/g" -e "s/__DMUSER__/$DMUSER/g" -e "s/__DMPASS__/$DMPASS/g" -i /install.inf

if [ ! -d /data/etc/slapd-ldap ]; then
    echo "installing 389-ds"
    cp -r /etc/dirsrv_orig/* /etc/dirsrv/
    /usr/sbin/setup-ds.pl -s -f /install.inf
else
    echo "running existing server"
    /start.sh
fi
tail -F /data/log/slapd-ldap/access /data/log/slapd-ldap/errors

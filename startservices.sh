#!/bin/bash
cp /main.cf /etc/postfix/main.cf
/bin/echo "Adding the domain ${1} to postfix main.cf config.";
#echo "myhostname = $myhostname" >> /etc/postfix/main.cf
postconf -e "myhostname = $myhostname"
service rsyslog start;
service postfix start;
sleep 20;
tail -F /var/log/mail.log

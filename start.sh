#!/bin/bash
/etc/rc.d/init.d/nagios start
/usr/sbin/httpd -k start
/nagios-api/nagios-api -p 8080 \
 -c /var/lib/nagios3/rw/nagios.cmd \
 -s /var/cache/nagios3/status.dat \
 -l /var/log/nagios3/nagios.log
tail -f /var/log/httpd/access_log /var/log/httpd/error_log

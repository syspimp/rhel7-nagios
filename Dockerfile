# ref https://access.redhat.com/solutions/1294053
FROM registry.redhat.io/ubi7:latest
WORKDIR /nagios/
COPY start.sh /nagios/
RUN yum -y install   httpd php  gd gd-devel gcc glibc glibc-common openssl perl perl-devel make
RUN curl -L -O http://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.0.8/nagios-4.0.8.tar.gz && \
    tar zxf ./nagios-4.0.8.tar.gz && \
    cd nagios-4.0.8 && \
    ./configure --with-command-group=nagcmd && \
    make all && \
    make install && \
    make install-init && \
    make install-config && \
    make install-commandmode && \
    make install-webconf
RUN useradd nagios && groupadd nagcmd && usermod -a -G nagcmd nagios && \
    htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin redhat123 && \
    cp -rvf contrib/eventhandlers/ /usr/local/nagios/libexec/ && \
    chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
EXPOSE 80
CMD ["/bin/bash", "/nagios/start.sh"]

#RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#
# Install Nagios plugins dependencies
#RUN yum install -y which gettext automake autoconf openssl-devel net-snmp net-snmp-utils
#RUN yum install -y perl-Net-SNMP
#
# Set working directory
#WORKDIR /nagios/
#
# Downlaod Nagios Plugins
#RUN wget --no-check-certificate -O /nagios/nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
#RUN tar zxf nagios-plugins.tar.gz
#
# Set working directory
#WORKDIR /nagios/nagios-plugins-release-2.2.1/
#
# Install Nagios plugins
#RUN ./tools/setup
#RUN ./configure
#RUN make
#RUN make install


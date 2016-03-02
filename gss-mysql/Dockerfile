FROM registry.access.redhat.com/rhscl/mysql-56-rhel7

ADD gss_db.sql /tmp/gss_db.sql

RUN /opt/rh/rh-mysql56/root/usr/bin/mysql --user=root --password=redhat < /tmp/gss_db.sql

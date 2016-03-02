FROM registry.access.redhat.com/rhel7

RUN  yum install -y yum-utils gettext && \
yum-config-manager --enable rhel-7-server-extras-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum -y install docker-registry 

EXPOSE 5000
VOLUME ["/registry"]

ENV DOCKER_REGISTRY_CONFIG /etc/docker-registry.yml

WORKDIR /usr/lib/python2.7/site-packages/docker-registry
CMD /usr/bin/gunicorn --preload --access-logfile - --max-requests 100 --graceful-timeout 3600 -t 3600 -k gevent -b 0.0.0.0:5000 -w 8 docker_registry.wsgi:application

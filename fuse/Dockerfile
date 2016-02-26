FROM rhel7

MAINTAINER Ravi Srinivasan ravis@redhat.com

# Install required software to run JBoss JWS
USER root

RUN  yum install -y yum-utils gettext && \
    yum-config-manager --enable rhel-7-server-extras-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms


#RUN  yum install -y yum-utils gettext 
#RUN yum-config-manager --enable rhel-7-server-extras-rpms
#RUN yum-config-manager --enable rhel-7-server-optional-rpms


# Let's get the JDK and a few more useful bits
RUN yum -y install apr-util openssl mailcap hostname unzip java-1.8.0-openjdk java-1.8.0-openjdk-devel maven

# Set the FUSE_VERSION env variable
ENV FUSE_VERSION 6.2.0.redhat-133

# If the container is launched with re-mapped ports, these ENV vars should
# be set to the remapped values.
ENV FUSE_PUBLIC_OPENWIRE_PORT 61616
ENV FUSE_PUBLIC_MQTT_PORT 1883
ENV FUSE_PUBLIC_AMQP_PORT 5672
ENV FUSE_PUBLIC_STOMP_PORT 61613
ENV FUSE_PUBLIC_OPENWIRE_SSL_PORT 61617
ENV FUSE_PUBLIC_MQTT_SSL_PORT 8883
ENV FUSE_PUBLIC_AMQP_SSL_PORT 5671
ENV FUSE_PUBLIC_STOMP_SSL_PORT 61614

# Install fuse in the image.
RUN mkdir -p /opt/jboss
COPY jboss-fuse-full-6.2.0.redhat-133.zip /opt/jboss/jboss-fuse-full-6.2.0.redhat-133.zip

COPY install.sh /opt/jboss/install.sh
RUN chmod a+x /opt/jboss/install.sh

RUN unzip /opt/jboss/jboss-fuse-full-6.2.0.redhat-133.zip -d /opt/jboss/
RUN /opt/jboss/install.sh

COPY launch.sh /opt/jboss/jboss-fuse/bin/launch.sh
RUN chmod a+x /opt/jboss/jboss-fuse/bin/launch.sh

COPY init.cli /opt/jboss/jboss-fuse/bin/init.cli

COPY users.properties /opt/jboss/jboss-fuse/etc/users.properties

RUN rm -f /opt/jboss/jboss-fuse-full-6.2.0.redhat-133.zip

EXPOSE 8181 8101 1099 44444 61616 1883 5672 61613 61617 8883 5671 61614


#these directories can hold config/data, so lets suggest the user
# mount them as volumes.
#VOLUME /opt/jboss/jboss-fuse/bin
#VOLUME /opt/jboss/jboss-fuse/etc
#VOLUME /opt/jboss/jboss-fuse/data
#VOLUME /opt/jboss/jboss-fuse/deploy

# The Fuse container needs a Maven repo for bundle resolution
VOLUME /root/.m2

# lets default to the jboss-fuse dir so folks can more easily navigate to around the server install
WORKDIR /opt/jboss/jboss-fuse
CMD ["/opt/jboss/jboss-fuse/bin/launch.sh"]
#CMD /opt/jboss/jboss-fuse/bin/fuse server

FROM rhel7

MAINTAINER Ravi Srinivasan ravis@redhat.com

# Install required software to run JBoss JWS
USER root
RUN yum -y install apr-util iproute openssl mailcap hostname unzip java-1.8.0-openjdk java-1.8.0-openjdk-devel net-tools wget tar

# Expose the ports
EXPOSE 8080 9990 9999 11222 11211 4447 55200 54200 45688 23364 8009

COPY slave-node.tar.gz /opt/

# Download the EWS distribution and unpack it
RUN tar -xvzf /opt/slave-node.tar.gz -C /opt/ && rm -f /opt/slave-node.tar.gz

# Add the launch script which configures the container
ADD launch.sh /opt/slave-node/jboss-eap-6.4/
RUN chmod a+x /opt/slave-node/jboss-eap-6.4/launch.sh

# The JAVA_HOME is set in jboss-base-jdk image.
CMD ["/opt/slave-node/jboss-eap-6.4/launch.sh"]



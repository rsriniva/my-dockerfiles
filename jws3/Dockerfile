FROM rhel7

MAINTAINER Ravi Srinivasan ravis@redhat.com

# Install required software to run JBoss JWS
USER root
RUN yum -y install apr-util openssl mailcap hostname unzip yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel

# Expose the ports
EXPOSE 8080
EXPOSE 8009

# Version of the EWS distribution
ENV JBOSS_EWS_VERSION_MAJOR 3
ENV JBOSS_EWS_VERSION_MINOR 0
ENV JBOSS_EWS_VERSION_MICRO 2
ENV JBOSS_EWS_VERSION $JBOSS_EWS_VERSION_MAJOR.$JBOSS_EWS_VERSION_MINOR.$JBOSS_EWS_VERSION_MICRO

ADD jws-application-servers-$JBOSS_EWS_VERSION-RHEL7-x86_64.zip /opt/

# Download the EWS distribution and unpack it
RUN unzip /opt/jws-application-servers-$JBOSS_EWS_VERSION-RHEL7-x86_64.zip -d /opt/ && rm -f /opt/jws-application-servers-$JBOSS_EWS_VERSION-RHEL7-x86_64.zip

ADD node-info.war /opt/jws-3.0/tomcat8/webapps/

# Specify the workdir
WORKDIR /opt/jws-3.0/tomcat8

# Add the launch script which configures the container
ADD launch.sh /opt/jws-3.0/tomcat8/
RUN chmod a+x /opt/jws-3.0/tomcat8/launch.sh

# The JAVA_HOME is set in jboss-base-jdk image.
CMD ["/opt/jws-3.0/tomcat8/launch.sh"]



FROM rhel7

MAINTAINER Ravi Srinivasan ravis@redhat.com

# Install required software to run JBoss JWS
USER root
RUN yum -y install apr-util openssl mailcap hostname unzip yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel

# Expose the ports
EXPOSE 8080
EXPOSE 8009

ADD apache-tomcat-8.0.30.tar.gz /opt/

# Download the EWS distribution and unpack it
RUN tar -xvzf /opt/apache-tomcat-8.0.30.tar.gz -C /opt/ && rm -f /opt/apache-tomcat-8.0.30.tar.gz

ADD node-info.war /opt/apache-tomcat-8.0.30/webapps/

# Specify the workdir
WORKDIR /opt/apache-tomcat-8.0.30

# Add the launch script which configures the container
ADD launch.sh /opt/apache-tomcat-8.0.30/
RUN chmod a+x /opt/apache-tomcat-8.0.30/launch.sh

# The JAVA_HOME is set in jboss-base-jdk image.
CMD ["/opt/apache-tomcat-8.0.30/launch.sh"]



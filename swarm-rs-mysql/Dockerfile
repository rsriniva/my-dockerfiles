FROM rhel7

MAINTAINER Ravi Srinivasan ravis@redhat.com

USER root
RUN yum -y install apr-util openssl mailcap hostname unzip yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel

# Expose the ports
EXPOSE 8080

ADD launch.sh /opt/
RUN chmod a+x /opt/launch.sh

ADD reports-swarm.jar /opt/

# Specify the workdir
WORKDIR /opt/

CMD ["/opt/launch.sh"]



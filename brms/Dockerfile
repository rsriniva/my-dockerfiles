FROM rhel7
MAINTAINER Ravi Srinivasan <rsriniva@redhat.com>

# EAP and BRMS versions add to the current directory
ENV BRMS_DISTRIBUTION jboss-brms-6.1.0.GA-deployable-eap6.x.zip
ENV EAP_DISTRIBUTION jboss-eap-6.4.0.zip
ENV EAP_MAJOR_VERSION jboss-eap-6.4

RUN  yum install -y yum-utils gettext && \
    yum-config-manager --enable rhel-7-server-extras-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms

# Let's get the JDK and a few more useful bits
RUN yum -y install apr-util openssl mailcap hostname unzip java-1.8.0-openjdk java-1.8.0-openjdk-devel maven


# Create a user and group used to launch processes
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss

USER jboss

ENV JAVA_HOME /usr/lib/jvm/java


# Add the EAP and BRMS distribution to image
ADD . /opt/jboss

RUN unzip -q -d $HOME/ $HOME/$EAP_DISTRIBUTION \
    && rm $HOME/$EAP_DISTRIBUTION \
    && unzip -q -o -d $HOME/ $HOME/$BRMS_DISTRIBUTION \
    && rm $HOME/$BRMS_DISTRIBUTION \
    && mv $HOME/$EAP_MAJOR_VERSION $HOME/eap

ENV EAP_HOME /opt/jboss/eap
ENV JAVA_OPTS -XX:MaxPermSize=256m -Xms256m -Xmx1024m

# Add admin to management realm and brmsAdmin to application realm
RUN $EAP_HOME/bin/add-user.sh -u 'admin' -p 'pa$word1' -ro 'admin'
RUN $EAP_HOME/bin/add-user.sh -a -u 'brmsAdmin' -p 'pa$word1' -ro 'admin,analyst'

# Uses this property as ssh git port number.
EXPOSE 8001

# The default port for deployed web applications.
EXPOSE 8080

# Uses this property as git port number
EXPOSE 9418

# The Web Management Console port
EXPOSE 9990

# The port used by the Management Console and Management API
EXPOSE 9999

# Run Business Central
WORKDIR $EAP_HOME/bin/
CMD ["./standalone.sh", "-b=0.0.0.0", "--server-config=standalone-full.xml", "-bmanagement=0.0.0.0", "-Dorg.uberfire.nio.git.ssh.host=0.0.0.0", "-Dorg.uberfire.nio.git.daemon.host=0.0.0.0"]

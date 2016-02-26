#!/bin/bash
#
# We configure the distro, here before it gets imported into docker
# to reduce the number of UFS layers that are needed for the Docker container.
#

# Adjust the following env vars if needed.
FUSE_ARTIFACT_ID=jboss-fuse-full
#FUSE_DISTRO_URL=http://origin-repository.jboss.org/nexus/content/groups/ea/org/jboss/fuse/${FUSE_ARTIFACT_ID}/${FUSE_VERSION}/${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip

# Lets fail fast if any command in this script does succeed.
set -e

cd /opt/jboss

#unzip /opt/jboss/${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip 

#sleep 10

mv /opt/jboss/jboss-fuse-${FUSE_VERSION} /opt/jboss/jboss-fuse

sleep 5

chmod a+x /opt/jboss/jboss-fuse/bin/*

# Lets remove some bits of the distro which just add extra weight in a docker image.
rm -rf /opt/jboss/jboss-fuse/extras
rm -rf /opt/jboss/jboss-fuse/quickstarts

#
# Let the karaf container name/id come from setting the FUSE_KARAF_NAME && FUSE_RUNTIME_ID env vars
# default to using the container hostname.
sed -i -e 's/environment.prefix=FABRIC8_/environment.prefix=FUSE_/' /opt/jboss/jboss-fuse/etc/system.properties
sed -i -e '/karaf.name = root/d' /opt/jboss/jboss-fuse/etc/system.properties
sed -i -e '/runtime.id=/d' /opt/jboss/jboss-fuse/etc/system.properties
echo '
if [ -z "$FUSE_KARAF_NAME" ]; then 
  export FUSE_KARAF_NAME="$HOSTNAME"
fi
if [ -z "$FUSE_RUNTIME_ID" ]; then 
  export FUSE_RUNTIME_ID="$FUSE_KARAF_NAME"
fi

export KARAF_OPTS="-Dkaraf.name=${FUSE_KARAF_NAME} -Druntime.id=${FUSE_RUNTIME_ID}"
'>> /opt/jboss/jboss-fuse/bin/setenv

#
# Move the bundle cache and tmp directories outside of the data dir so it's not persisted between container runs
#
mv /opt/jboss/jboss-fuse/data/tmp /opt/jboss/jboss-fuse/tmp
echo '
org.osgi.framework.storage=${karaf.base}/tmp/cache
'>> /opt/jboss/jboss-fuse/etc/config.properties
sed -i -e 's/-Djava.io.tmpdir="$KARAF_DATA\/tmp"/-Djava.io.tmpdir="$KARAF_BASE\/tmp"/' /opt/jboss/jboss-fuse/bin/karaf
sed -i -e 's/-Djava.io.tmpdir="$KARAF_DATA\/tmp"/-Djava.io.tmpdir="$KARAF_BASE\/tmp"/' /opt/jboss/jboss-fuse/bin/fuse
sed -i -e 's/-Djava.io.tmpdir="$KARAF_DATA\/tmp"/-Djava.io.tmpdir="$KARAF_BASE\/tmp"/' /opt/jboss/jboss-fuse/bin/client
sed -i -e 's/-Djava.io.tmpdir="$KARAF_DATA\/tmp"/-Djava.io.tmpdir="$KARAF_BASE\/tmp"/' /opt/jboss/jboss-fuse/bin/admin
sed -i -e 's/${karaf.data}\/generated-bundles/${karaf.base}\/tmp\/generated-bundles/' /opt/jboss/jboss-fuse/etc/org.apache.felix.fileinstall-deploy.cfg

# lets remove the karaf.delay.console=true to disable the progress bar
sed -i -e 's/karaf.delay.console=true/karaf.delay.console=false/' /opt/jboss/jboss-fuse/etc/config.properties 

echo '
bind.address=0.0.0.0
'>> /opt/jboss/jboss-fuse/etc/system.properties
echo '' >> /opt/jboss/jboss-fuse/etc/users.properties

#rm /opt/jboss/install.sh

#!/bin/bash

# Let's start the fuse karaf runtime in the background
/opt/jboss/jboss-fuse/bin/start
sleep 45

# Run the Karaf init script - add your own karaf commands to init.cli
/opt/jboss/jboss-fuse/bin/client -u admin -p password shell:source /opt/jboss/jboss-fuse/bin/init.cli

sleep 10
 
# tail the log file to make docker CMD happy
tail -f /opt/jboss/jboss-fuse/data/log/fuse.log

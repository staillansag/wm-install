#!/bin/sh
#
# startup script
#


# Define SIGTERM-handler for graceful shutdown

#term_handler() {
#  if [ $childPID -ne 0 ]; then
#    /bin/sh ./docker-stop.sh
#  fi
#  exit 143; # 128 + 15 -- SIGTERM
#}
# setup SIGTERM Handler
#trap 'kill ${!}; term_handler' SIGTERM

# start up components

# start up components

echo "Starting webMethods components......"


echo "SPM......"
#su wm -c '/opt/softwareag/profiles/SPM/bin/startup.sh'
./opt/softwareag/profiles/SPM/bin/startup.sh
sleep 5

echo "Universal Messaging......"
#su wm -c '/opt/softwareag/UniversalMessaging/server/umserver/bin/nserverdaemon start'
./opt/softwareag/UniversalMessaging/server/umserver/bin/nserverdaemon start
sleep 5

echo "Integration Server......"
#su wm -c '/opt/softwareag/profiles/IS_default/bin/startup.sh'
./opt/softwareag/profiles/IS_default/bin/startup.sh
sleep 5

echo "my webMethods server......"
#su wm -c '/opt/softwareag/MWS/server/default/bin/startup.sh'
cd /opt/softwareag/MWS/server/default/bin
./startup.sh
sleep 5

echo "Optimize for process......"
#su wm -c '/opt/softwareag/optimize/analysis/bin/startup.sh'
cd /
./opt/softwareag/optimize/analysis/bin/startup.sh
sleep 5

echo "Optimize for infra......"
cd /
./opt/softwareag/InfrastructureDC/bin/startup.sh
sleep 5


# end

#!/bin/sh

echo "Stopping webMethods components......"

#/opt/sag/profiles/IS_default/bin/shutdown.sh

echo "SPM......"
#su wm -c '/opt/softwareag/profiles/SPM/bin/shutdown.sh'
./opt/softwareag/profiles/SPM/bin/shutdown.sh
sleep 5

echo "Integration Server......"
#su wm -c '/opt/softwareag/profiles/IS_default/bin/shutdown.sh'
./opt/softwareag/profiles/IS_default/bin/shutdown.sh
sleep 5

echo "my webMethods server......"
#su wm -c '/opt/softwareag/MWS/server/default/bin/shutdown.sh'
cd /opt/softwareag/MWS/server/default/bin
./shutdown.sh
sleep 5

echo "Optimize for process......"
#su wm -c '/opt/softwareag/optimize/analysis/bin/shutdown.sh'
cd /
./opt/softwareag/optimize/analysis/bin/shutdown.sh
sleep 5

echo "Optimize for infra......"
cd /
./opt/softwareag/InfrastructureDC/bin/shutdown.sh
sleep 5


echo "Universal Messaging......"
#su wm -c '/opt/softwareag/UniversalMessaging/server/umserver/bin/nserverdaemon stop'
./opt/softwareag/UniversalMessaging/server/umserver/bin/nserverdaemon stop
sleep 5

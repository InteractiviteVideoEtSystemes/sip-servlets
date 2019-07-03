#!/bin/sh
var_catalina=/opt/tomcat/$1/restcommserver

echo 'Checking that the Environment Variable is correct'
if [ $CATALINA_HOME = $var_catalina ]
then
        echo 'CATANILA_HOME is correct '
	echo -e "\n"
else
        echo 'CATALINA_HOME isn t correct, it must be'
        echo "$var_catalina"
fi

echo "Configuration of server.xml with your IP Address "
ipaddress=`hostname -i`
xmlstarlet ed --inplace -P \
        -u '//Connector[@port="5080"]/@ipAddress' -v $ipaddress \
        -u '//Connector[@port="5081"]/@ipAddress' -v $ipaddress \
        -u '//Connector[@port="5082"]/@ipAddress' -v $ipaddress \
        -u '//Connector[@port="5083"]/@ipAddress' -v $ipaddress \
       $var_catalina/conf/server.xml
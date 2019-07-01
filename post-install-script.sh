var_catalina=/opt/tomcat/$version/restcommserver
version=3.2.0-116
if [ -z $1 ]
	then 
		$version=$1
	fi
echo 'Checking that the Environment Variable is correct'
if [ $CATALINA_HOME = $var_catalina ]
then
        echo 'CATANILA_HOME is correct '
	echo -e "\n"
else
        echo 'CATALINA_HOME isn t correct, it must be'
        echo "$var_catalina"
	return
fi

#echo 'What is your IP Address ?'
#read ipaddress
#xmlstarlet ed --inplace -P \
#        -u '//Connector[@port="5080"]/@ipAddress' -v $ipaddress \
#        -u '//Connector[@port="5081"]/@ipAddress' -v $ipaddress \
#        -u '//Connector[@port="5082"]/@ipAddress' -v $ipaddress \
#        -u '//Connector[@port="5083"]/@ipAddress' -v $ipaddress \
#       $dir_extrac/restcommserver/conf/server.xml
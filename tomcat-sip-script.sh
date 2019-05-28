sipserversrc=restcomm-sip-servlets-4.0.128-src
sipserver=restcomm-sip-servlets-4.0.128-apache-tomcat-8.0.30
version=4.0.128
dir_extrac=/opt/tomcat
dir_sip_servlets=restcomm/servers/sip-servlets/
var_catalina=/opt/tomcat/tomcat-sip-4.0.128

echo 'Unzipping Tomcat server sip on /opt/tomcat '
unzip $sipserver.zip -d $dir_extrac
echo -e "\n"

echo 'Renaming server sip '
mv $dir_extrac/$sipserver $dir_extrac/tomcat-sip-$version
echo -e "\n"

rm -r $dir_extrac/$sipserver
echo 'Unzipping Tomcat sip scr on /opt/tomcat'
unzip $sipserversrc.zip -d $dir_extrac
echo -e "\n"

echo 'Deleting .zip '
rm $sipserver.zip
rm $sipserversrc.zip
echo -e "\n"

echo 'Copying jar in lib '
cp  $dir_extrac/$dir_sip_servlets/sip-servlets-*/tomcat8home/lib/*.jar $dir_extrac/tomcat-sip-$version/lib

cp  $dir_extrac/$dir_sip_servlets/containers/*/tomcat8home/lib/*.jar $dir_extrac/tomcat-sip-$version/lib
echo -e "\n"

echo 'Charging user tomcat'
echo '<?xml version="1.0" encoding="utf-8"?>

<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
<role rolename="manager-script"/>
 <role rolename="manager-gui"/>
 <role rolename="admin-gui"/>
 <user username="admin" password="123" roles="manager-gui,admin-gui,manager-script"/>

</tomcat-users>' > $dir_extrac/tomcat-sip-$version/conf/tomcat-users.xml
echo -e "\n"

echo 'Killing other Tomcat process '
kill $(ps -eaf | pgrep java) 
echo -e "\n"

echo 'Checking that the Environment Variable is correct'
if [ $CATALINA_HOME = $var_catalina ]
then
        echo 'CATANILA_HOME is correct '
	echo -e "\n"
        echo 'Starting Tomcat'
        $CATALINA_HOME/bin/startup.sh
else
        echo 'CATALINA_HOME isn t correct, it must be'
        echo "$var_catalina"
fi

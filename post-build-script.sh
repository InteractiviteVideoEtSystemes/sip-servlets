sipserver=restcomm-sip-servlets-3.2.0-116-apache-tomcat-8.0.26
version=3.2.0-116
dir_extrac=~/rpmbuild/SOURCES

if [ -z $1 ]
	then 
		$version=$1
	fi

echo 'Unzip Tomcat server sip on /opt/tomcat '
unzip $sipserver.zip -d $dir_extrac
echo -e "\n"

echo 'Rename server sip '
mv $dir_extrac/$sipserver $dir_extrac/$version/restcommserver
echo -e "\n"

rm -r $dir_extrac/$sipserver

echo 'Delete .zip '
rm $sipserver.zip
echo -e "\n"

echo 'Charge user tomcat'
echo '<?xml version="1.0" encoding="utf-8"?>

<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
 <role rolename="manager-script"/>
 <role rolename="manager-gui"/>
 <role rolename="admin-gui"/>
 <user username="admin" password="123" roles="manager-gui,admin-gui,manager-script"/>

</tomcat-users>' > $dir_extrac/$version/restcommserver/conf/tomcat-users.xml




	   

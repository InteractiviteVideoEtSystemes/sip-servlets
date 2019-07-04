#!/bin/sh
sipserver=restcomm-sip-servlets-3.2.0-116-apache-tomcat-8.0.26
version=3.2.0
dir_extrac=.
DESTDIR=/opt/tomcat/$version
projet=restcommserver
echo 'Unzip Tomcat server sip'


unzip $dir_extrac/build/release/$sipserver.zip -d ../BUILD
echo -e "\n"

echo 'Rename server sip '
mv ../BUILD/$sipserver ../BUILD/$projet
echo -e "\n"
mkdir -p $2$DESTDIR/  
mkdir -p $2$DESTDIR/$projet/conf
mkdir -p $2$DESTDIR/$projet/bin
mkdir -p $2$DESTDIR/$projet/lib
mkdir -p $2$DESTDIR/$projet/logs
mkdir -p $2$DESTDIR/$projet/webapps
mkdir -p $2$DESTDIR/$projet/work
mkdir -p $2$DESTDIR/$projet/docs

cp -rp $dir_extrac/post-install-script.sh $2$DESTDIR/$projet
cp -rp ../BUILD/$projet/conf/* $2$DESTDIR/$projet/conf
cp -rp ../BUILD/$projet/bin/* $2$DESTDIR/$projet/bin
cp -rp ../BUILD/$projet/lib/* $2$DESTDIR/$projet/lib
cp -rp ../BUILD/$projet/webapps/* $2$DESTDIR/$projet/webapps
cp -rp ../BUILD/$projet/docs/* $2$DESTDIR/$projet/docs


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

</tomcat-users>' > $2$DESTDIR/$projet/conf/tomcat-users.xml
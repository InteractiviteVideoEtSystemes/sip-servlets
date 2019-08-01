%define name restcommserver
%define version 3.2.0
Name: %{name}		
Version:%{version}	
Release:	1.ives
Summary:	[IVeS] RestComm Server Sip

Group: ServerSip/RestComm		
License:	IVeS (c) 2006-2019 All right reserved
URL:		http://www.ives.fr
Source0: https://github.com/InteractiviteVideoEtSystemes/sip-servlets/tree/ives/fix/compilation-3.2.0-116
	
BuildArch: noarch
BuildRequires: java-1.8.0-openjdk-devel 		
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


%description
Ce service compile et installe le serveur RestComm Sip Servlets avec Tomcat 8


%clean
echo Clean du repertoire $RPM_BUILD_ROOT
[ "$RPM_BUILD_ROOT" != "/"] && rm -rf "$RPM_BUILD_ROOT"


%prep
echo "Build"
if [ ! -f /opt/apache-maven-3.6.1/bin/mvn ]
then
	echo "Il est necessaire d avoir maven" 
fi
echo $RPM_BUILD_ROOT

%build 
echo "Build" 
cd ../SOURCES/build/release
ant release

%install
echo "Install"
chmod 777 ../SOURCES/install-script.sh
cd ../SOURCES
[ "$RPM_BUILD_ROOT" != "/"] && rm -rf "$RPM_BUILD_ROOT"
mkdir -p $RPM_BUILD_ROOT
sed -i -e 's/\r$//' install-script.sh
./install-script.sh %version $RPM_BUILD_ROOT


%post
cd /opt/tomcat/%version/restcommserver
chmod 777 post-install-script.sh 
sed -i -e 's/\r$//' post-install-script.sh
./post-install-script.sh %version

%files
%defattr(-,root,root,-)
/opt/tomcat/%version/restcommserver/post-install-script.sh
/opt/tomcat/%version/restcommserver/bin/*
/opt/tomcat/%version/restcommserver/webapps/*
/opt/tomcat/%version/restcommserver/lib/*
/opt/tomcat/%version/restcommserver/logs/
/opt/tomcat/%version/restcommserver/work/
/opt/tomcat/%version/restcommserver/conf
/opt/tomcat/%version/restcommserver/docs/*
/opt/tomcat/%version/restcommserver/temp/
%docdir /opt/tomcat/%version/restcommserver/docs/* 
%config(noreplace) /opt/tomcat/%version/restcommserver/conf/server.xml
%config(noreplace) /opt/tomcat/%version/restcommserver/conf/dars/mobicents-dar.properties


%changelog


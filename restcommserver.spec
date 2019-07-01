Name: %{name}		
Version:%{version}	
Release:	1.ives
Summary:	[IVeS] RestComm Server Sip

#Group:	je sais pas	
License:	IVeS (c) 2006-2019 All right reserved
URL:		http://www.ives.fr
Source0: https://github.com/InteractiviteVideoEtSystemes/sip-servlets	
#BuildArch: noarch
BuildRequires: java-1.8.0-openjdk-devel 	
#Requires:	
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


%description
Ce service compile et installe le serveur RestComm Sip Servlets avec Tomcat 8


%clean
echo Clean du repertoire $RPM_BUILD_ROOT
[ "$RPM_BUILD_ROOT" != "/"] && rm -rf "$RPM_BUILD_ROOT"


%prep
wget  https://github.com/InteractiviteVideoEtSystemes/sip-servlets ~/rpmbuild/SOURCES
git checkout ives/fix/compilation-3.2.0-116
if [ ! -f /opt/apache-maven-3.6.1/bin/mvn ]
then
	wget http://mirrors.sonic.net/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
	tar -xzf apache-maven-3.6.1-bin.tar.gz
	sudo mv apache-maven-3.6.1 /opt/
	sudo ln -s /opt/apache-maven-3.6.1/bin/mvn /usr/bin/mvn 
fi
export M2_HOME=/opt/apache-maven-3.6.1


%build 
echo "Build"
cd build/release
ant release
./post-build-script.sh ${version}


%install
echo "Install"
[ "$RPM_BUILD_ROOT" != "/"] && rm -rf "$RPM_BUILD_ROOT"
mkdir -p $RPM_BUILD_ROOT
cd ../../
./install.ksh rpmInstall $RPM_BUILD_ROOT %version


%post
./post-install-script.sh %{version}
%files
bin/
webapps/
lib/
logs/
work/
%docdir docs/* 
%config(noreplace) conf/*


%changelog


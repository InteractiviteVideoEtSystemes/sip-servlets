#!/bin/ksh
VERSION="3.2.0-116"
PROJET=restcommserver
DESTDIR=/opt/tomcat/${VERSION}/${PROJET}
TEMPDIR=/tmp

#Creation de l'environnement de packaging rpm
function create_rpm
{
	if [ -z "$3" ]
	 then
		source="origine/master"
	 else
		source=$3
	fi

	if [[ $source = "origin/"* ]]; then
        	toarchive=${source/origin\//}
        else
        	toarchive=$3
    	fi
	
 
#Cree l'environnement de creation de package
#Creation des macros rpmbuild
    rm -f ~/.rpmmacros
    touch ~/.rpmmacros
    echo "%_topdir ./rpmbuild" >> ~/.rpmmacros
    echo "%debug_package %{nil}" >> ~/.rpmmacros
    echo "%_tmppath %{_topdir}/TMP" >> ~/.rpmmacros
    echo "%_signature gpg" >> ~/.rpmmacros
    echo "%_gpg_name IVeSkey" >> ~/.rpmmacros
    echo "%_gpg_path ./rpmbuild/gnupg" >> ~/.rpmmacros
    echo "%vendor IVeS" >> ~/.rpmmacros
    echo "%gitsource "$toarchive >> ~/.rpmmacros
	
#Import de la clef gpg IVeS
    mkdir -p ./rpmbuild
    cd ./rpmbuild
    svn export http://svn.ives.fr/svn-libs-dev/gnupg
    mkdir -p SOURCES
    mkdir -p SPECS
    mkdir -p BUILD
    mkdir -p SRPMS
    mkdir -p TMP
    mkdir -p RPMS
    mkdir -p RPMS/noarch
    mkdir -p RPMS/x86_64
    mkdir -p RPMS/i386
    mkdir -p RPMS/i686
    mkdir -p RPMS/i586
 
    cd -
    cp ${PROJET}.spec ./rpmbuild/SPECS 
    cp -r . ./rpmbuild/SOURCES
    cd ./rpmbuild/
	
    #Cree le package
    if [[ -z $2 || $2 -ne nosign ]] 
	then
		 
		rpmbuild -bb --sign ./rpmbuild/SPECS/${PROJET}.spec
    else  	
		rpmbuild -bb  ./rpmbuild/SPECS/${PROJET}.spec
		
    fi

   	
    #Recuperation du rpm
    cd -
    mv ./rpmbuild/RPMS/noarch/*.rpm $PWD/.
  clean
}

#Copie des fichiers composants le rpm dans un repertoire temporaire
# Le premier parametre donne le repertoire destination, le deuxieme de numero de version
function copy_rpmInstall
{
    if [ ! -d $1 ]
	then 
		echo "[ERROR] Veuillez passer en parametre a install.ksh le repertoire temporaire de destination"
		return
	fi
	if [ -z $2 ]
	then 
		echo "[ERROR] Veuillez passer en parametre a install.ksh le numero de version"
		return
	fi
 

  echo $DESTDIR
  mkdir -p $DESTDIR
  mkdir -p $DESTDIR/conf
  mkdir -p $DESTDIR/bin
  mkdir -p $DESTDIR/lib
  mkdir -p $DESTDIR/logs
  mkdir -p $DESTDIR/webapps
  mkdir -p $DESTDIR/work
  mkdir -p $DESTDIR/temp
  #cd $PROJET

  cp -rp ./rpmbuild/SOURCES/${VERSION}/restcommserver/conf/* $DESTDIR/conf
  cp -rp ./rpmbuild/SOURCES/${VERSION}/restcommserver/bin/* $DESTDIR/bin
  cp -rp ./rpmbuild/SOURCES/${VERSION}/restcommserver/lib/* $DESTDIR/lib
  cp -rp ./rpmbuild/SOURCES/${VERSION}/restcommserver/webapps/* $DESTDIR/webapps
    

}


function clean
{
  	# On efface les liens ainsi que le package precedemment créé
  	echo Effacement des fichiers et liens gnupg rpmbuild ${PROJET}.rpm ${TEMPDIR}/${PROJET}
  	rm -rf ./rpmbuild/SPECS/${PROJET}.spec ./rpmbuild/gnupg ./rpmbuild/BUILD/${PROJET}
}

case $1 in
	"clean")
		echo "Nettoyage des liens et du package crees par la cible dev"
		clean ;;
	"rpmInstall")
		#rpmInstall est appele automatiquement par le script de creation de rpm
		echo "Copie des fichiers du rpm dans la localisation temporaire"
		copy_rpmInstall $2 $3;;
	"rpm")
		echo "Creation du rpm"
		create_rpm "$@";;
	"export")
        echo "{" >> build.properties
        echo "'VERSION': '$VERSION'," >> build.properties
        echo "'PROJET':'$PROJET'," >> build.properties
        echo "'DESTDIR':'$DESTDIR'" >> build.properties
        echo "}" >> build.properties
       ;;
	*)
		echo "usage: install.ksh [options]" 
		echo "options :"
		echo "  rpm		Generation d'un package rpm"
		echo "  clean		Nettoie tous les fichiers cree par le present script, liens, tar.gz et rpm";;
esac


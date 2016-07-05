#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

if ! check_package_installed oracle-java8-installer; then
# app/config/parameters.yml

	echo "oracle-java8-installer  shared/accepted-oracle-license-v1-1 boolean true"| debconf-set-selections
#	echo "shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
	
	apt_add_repository ppa:webupd8team/java
	apt_update_package_list
	apt_install_package oracle-java8-installer
	apt_install_package oracle-java8-set-default
fi


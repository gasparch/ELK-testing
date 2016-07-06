#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

add_filebeat_ppa () {
	echo "deb https://packages.elastic.co/beats/apt stable main" > /etc/apt/sources.list.d/beats.list
}

if ! check_package_installed filebeat; then
	add_filebeat_ppa &&
	apt_update_package_list &&
	apt_install_packages filebeat
fi


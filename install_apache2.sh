#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

apt_install_packages apache2

#case $TARGET_ENVIRONMENT in
#	wallabag)
#		apt_install_packages \
#			php${PHP_VERSION}-curl \
#			php${PHP_VERSION}-gd \
#			php${PHP_VERSION}-xml \
#			php${PHP_VERSION}-mbstring
#		;;
#esac

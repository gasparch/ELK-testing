#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

if ! check_package_installed php${PHP_VERSION}; then
	apt_add_repository ppa:ondrej/php
	apt_update_package_list
	apt_install_packages php${PHP_VERSION}
fi

case $TARGET_ENVIRONMENT in
	wallabag)
		apt_install_packages \
			php${PHP_VERSION}-curl \
			php${PHP_VERSION}-mysql \
			php${PHP_VERSION}-gd \
			php${PHP_VERSION}-xml \
			php${PHP_VERSION}-mbstring
		;;
esac

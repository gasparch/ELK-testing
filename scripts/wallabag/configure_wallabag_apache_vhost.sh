#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

generate_vhost_config() {
	cat $CWD/files/wallabag/apache.vhost.tmpl | sed \
		-e "s#%%VHOSTDIR%%#${WALLABAG_DIR}#g" \
		-e "s#%%DOMAIN%%#${WALLABAG_DOMAIN}#g" > /etc/apache2/sites-available/010-wallabag.conf
}

enable_vhost_in_apache2() {
	a2ensite 010-wallabag
	a2dissite 000-default
}

generate_vhost_config &&
enable_vhost_in_apache2 &&
service_restart apache2

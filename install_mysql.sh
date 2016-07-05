#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

# avoid provisioning if already provisioned
if ! check_package_installed mysql-server-${MYSQL_VERSION}; then
	MYSQL_PASSWORD=`openssl rand -base64 32`

	echo "mysql-server mysql-server/root_password password ${MYSQL_PASSWORD}" | debconf-set-selections
	echo "mysql-server mysql-server/root_password_again password ${MYSQL_PASSWORD}" | debconf-set-selections

	echo "$MYSQL_PASSWORD" > $MYSQL_PASS_FILE
	chmod 400 $MYSQL_PASS_FILE

	cat >/root/.my.cnf <<EOF
[client]
user=root
password=$MYSQL_PASSWORD
EOF

	apt_install_packages mysql-server-${MYSQL_VERSION} mysql-client-${MYSQL_VERSION}
fi

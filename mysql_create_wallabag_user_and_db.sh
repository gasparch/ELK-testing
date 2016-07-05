#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh


if [ ! -f $WALLABAG_PASS_FILE ]; then
	WALLABAG_PASSWORD=`openssl rand -base64 32`
	echo "$WALLABAG_PASSWORD" > $WALLABAG_PASS_FILE

	SQL=`cat <<EOF
CREATE DATABASE ${WALLABAG_DB_NAME};
GRANT USAGE ON *.* TO ${WALLABAG_DB_USER}@localhost IDENTIFIED BY '${WALLABAG_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WALLABAG_DB_NAME}.* TO ${WALLABAG_DB_USER}@localhost;
FLUSH PRIVILEGES;
EOF`

	echo "$SQL" | mysql
fi

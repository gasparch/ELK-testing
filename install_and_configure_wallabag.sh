#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

DEST_DIR=/opt/wallabag-install

mkdir -p $DEST_DIR 
cd $DEST_DIR

WALLABAG_DB_PASS=`cat $WALLABAG_PASS_FILE`

generate_wallabag_config () {
	cat $CWD/files/parameters.yml | sed -e "s/%%DB%%/${WALLABAG_DB_NAME}/g" -e "s/%%USER%%/${WALLABAG_DB_USER}/g" -e "s#%%PASS%%#${WALLABAG_DB_PASS}#g" -e "s/%%DOMAIN%%/${WALLABAG_DOMAIN}/g" > $DEST_DIR/app/config/parameters.yml
}

# speedup checkout by shallow clone
git clone --depth 1 https://github.com/wallabag/wallabag.git -b ${WALLABAG_VERSION} $DEST_DIR &&
cd $DEST_DIR &&
generate_wallabag_config &&
SYMFONY_ENV=prod composer install --no-dev -o --prefer-dist

expect -c "
set timeout 10
spawn php bin/console wallabag:install --env=prod
expect \"It appears that your database already exists. Would you like to reset it? (y/N)\"
send \"n\r\"
expect \"Would you like to create a new admin user (recommended) ? (Y/n)\"
send \"y\r\"
expect \"Username (default: wallabag) :\"
send \"${WALLABAG_ADMIN_USER}\r\"
expect \"Password (default: wallabag) :\"
send \"${WALLABAG_ADMIN_PASS}\r\"
expect \"Email:\"
send \"${WALLABAG_ADMIN_EMAIL}\r\"
expect eof
"

#php bin/console server:run --env=prod

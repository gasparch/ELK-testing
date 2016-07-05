#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

TMP=/opt/wallabag-install

mkdir -p $TMP 
cd $TMP

WALLABAG_DB_PASS=`cat $WALLABAG_PASS_FILE`

generate_wallabag_config () {
	cat $CWD/files/parameters.yml | sed -e "s/%%DB%%/${WALLABAG_DB_NAME}/g" -e "s/%%USER%%/${WALLABAG_DB_USER}/g" -e "s/%%PASS%%/${WALLABAG_DB_PASS}/g" -e "s/%%DOMAIN%%/${WALLABAG_DOMAIN}/g" > $TMP/app/config/parameters.yml
}

# speedup checkout by shallow clone
git clone --depth 1 https://github.com/wallabag/wallabag.git -b ${WALLABAG_VERSION} $TMP &&
cd $TMP &&
generate_wallabag_config &&
SYMFONY_ENV=prod composer install --no-dev -o --prefer-dist


#SECURE_MYSQL=`expect -c "
#set timeout 10
#spawn php bin/console wallabag:install --env=prod
#expect \"Enter current password for root (enter for none):\"
#send \"$MYSQL_PASSWORD\r\"
#expect \"Change the root password?\"
#send \"n\r\"
#expect \"Remove anonymous users?\"
#send \"y\r\"
#expect \"Disallow root login remotely?\"
#send \"y\r\"
#expect \"Remove test database and access to it?\"
#send \"y\r\"
#expect \"Reload privilege tables now?\"
#send \"y\r\"
#expect eof
#"`

#php bin/console server:run --env=prod

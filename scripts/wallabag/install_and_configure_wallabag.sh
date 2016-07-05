#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh


mkdir -p $WALLABAG_DIR 
cd $WALLABAG_DIR

checkout_wallabag_from_git () {# {{{
	# speedup checkout by shallow clone
	git clone --depth 1 https://github.com/wallabag/wallabag.git -b ${WALLABAG_VERSION} $WALLABAG_DIR
	return $?
} # }}}

generate_wallabag_config () {# {{{
	WALLABAG_DB_PASS=`cat $WALLABAG_PASS_FILE`
	cat $CWD/files/parameters.yml | sed -e "s/%%DB%%/${WALLABAG_DB_NAME}/g" -e "s/%%USER%%/${WALLABAG_DB_USER}/g" -e "s#%%PASS%%#${WALLABAG_DB_PASS}#g" -e "s/%%DOMAIN%%/${WALLABAG_DOMAIN}/g" > $WALLABAG_DIR/app/config/parameters.yml
	return $?
} #}}}

install_wallabag_dependencies () { # {{{
	SYMFONY_ENV=prod composer install --no-dev -o --prefer-dist
	return $?
} # }}}

configure_wallabag_installation () { # {{{
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
} # }}}

fix_wallabag_permissions () { # {{{
	# configuring permissions 
	chown -R nobody:nogroup $WALLABAG_DIR
	chmod -R ugo+rX $WALLABAG_DIR
	# make some dirs writable by web server
	for DIR in $WALLABAG_DIR/var; do
		chown -R www-data:www-data $DIR
		chmod -R u+w $DIR
	done
} # }}}

checkout_wallabag_from_git &&
cd $WALLABAG_DIR &&
generate_wallabag_config &&
install_wallabag_dependencies &&
configure_wallabag_installation &&
fix_wallabag_permissions

#php bin/console server:run --env=prod

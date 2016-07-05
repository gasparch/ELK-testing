
################################################################################
# CONFIG

# list of extra packages to be installed on each host
EXTRA_UTILS="mc vim git expect"

WALLABAG_VERSION="2.0.5"
PHP_VERSION="5.6"
MYSQL_VERSION="5.6"

WALLABAG_DB_NAME="wallabag"
WALLABAG_DB_USER="wallabag"
WALLABAG_DOMAIN="example.com"



################################################################################
# CONFIGURE ENVIRONMENT

case $1 in 
	wallabag|kibana|grafana) 
		TARGET_ENVIRONMENT=$1;;
	*) 
		echo "ERROR: unknown environment $1"
		echo "specify wallabag|kibana|grafana as a first argument to script"
		exit 5
esac

MYSQL_PASS_FILE=/root/.mypassword
WALLABAG_PASS_FILE=/root/.wallabag_password

################################################################################
# UTILITY FUNCTIONS

apt_add_repository () {
	REPO=$1
	add-apt-repository -y ${REPO}
}

apt_update_package_list () {
	apt-get update
}

apt_install_package () {
	apt_install_packages $1
}

apt_install_packages () {
	apt-get install -y $@
}

check_package_installed () {
	PACKAGE_NAME=$1

	dpkg -s $PACKAGE_NAME >/dev/null 2>&1

	return $?
}

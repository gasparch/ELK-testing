
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

WALLABAG_ADMIN_USER="test1"
WALLABAG_ADMIN_PASS="test1"
WALLABAG_ADMIN_EMAIL="test1@test.com"


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

if [ -z $CWD ]; then
cat <<EOF
CWD is not defined in script, start each script with this snippet

#!/bin/sh
CWD=\$(dirname \$(readlink -f \$0))
CWD=\${CWD%scripts/*}
cd \$CWD

. \$CWD/common.inc.sh
EOF
exit 5
fi

case $TARGET_ENVIRONMENT in
	wallabag)
		SERVICE_LIST_TO_ENABLE="apache2 mysql filebeat"
	;;
	kibana)
		SERVICE_LIST_TO_ENABLE="elasticsearch kibana logstash"
	;;
esac

MYSQL_PASS_FILE=/root/.mypassword
WALLABAG_PASS_FILE=/root/.wallabag_password
WALLABAG_DIR=/opt/wallabag-install

SSLCA_ROOT=$CWD/files/SSLCA/
LOGSTASH_KEY=$SSLCA_ROOT/private/logstash-forwarder.key
LOGSTASH_CRT=$SSLCA_ROOT/certs/logstash-forwarder.crt

# $ELK_SERVER_NAME should be same as in files/hosts_config
ELK_SERVER_NAME=kibana

################################################################################
# UTILITY FUNCTIONS

# use to add ppa:// urls 
# apt_add_repository REPO_NAME
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

# installs one or more packages
# apt_install_packages PKG1 [PKG2 ...]
apt_install_packages () {
	apt-get install -y $@
}

# checks if package is installed
# check_package_installed PACKAGE_NAME
check_package_installed () {
	PACKAGE_NAME=$1

	dpkg -s $PACKAGE_NAME >/dev/null 2>&1

	return $?
}

# service_restart SERVICE_NAME
service_restart () {
	SERVICE=$1
	service $SERVICE restart
}

# service_start SERVICE_NAME
service_start () {
	SERVICE=$1
	service $SERVICE start
}

# retry to connect to REST service several times until positive response is
# received or reached max retry count
# wait_for_REST_service URL SECONDS_TO_WAIT
wait_for_REST_service () {
	local URL TRIES I
	URL=$1
	TRIES=$2 || 10

	I=0
	while [ $I -lt $TRIES ]; do
		I=$(($I+1))
		if curl -XGET $URL > /dev/null 2>&1; then
			# got positive response
			return 0
		else
			sleep 1
		fi
	done

	# failed to connect
	return 1
}


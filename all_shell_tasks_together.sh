#!/bin/sh

TARGET=$1
TEST=$2

case $TARGET in
	wallabag) TASKS="install_apache2 install_mysql mysql_secure_installation \
		install_php_5_6 install_php_composer \
		mysql_create_wallabag_user_and_db \
		install_and_configure_wallabag \
		configure_wallabag_apache_vhost\
		install_elastic_co_key \
		install_filebeat \
		configure_filebeat_on_wallabag"
		;;
	kibana) TASKS="install_java8 \
		install_elastic_co_key \
		install_ELK_stack \
		configure_and_start_elasticsearch \
		configure_and_start_kibana \
		configure_and_start_logstash"
		;;
	grafana) TASKS="";;
esac

#TASKS="install_mysql"
TASKS="update_apt_index install_utils add_hosts configure_tz generate_ssl_keys $TASKS enable_services"

LOG_BASE=/vagrant/logs/$TARGET/
mkdir -p $LOG_BASE

for TASK in $TASKS; do
	echo "doing task ${TASK}"

	SCRIPT_FILE=$(readlink -f /vagrant/scripts/*/${TASK}.sh)

	if [ -z $SCRIPT_FILE ]; then
		SCRIPT_FILE="/vagrant/${TASK}.sh"
	fi

	if [ ! -f $SCRIPT_FILE ]; then
		echo "cannot find script $SCRIPT_FILE for $TASK"
		exit 10
	fi

	if [ "$TEST" = "y" ]; then
		# allow checking if all files are in place (after renaming :)
		echo "FILE $SCRIPT_FILE"
		continue
	fi

	LOG_FILE="$LOG_BASE/`echo $TASK | sed -e 's#/#_#g'`.log"

	sudo -i sh ${SCRIPT_FILE} ${TARGET} 2>$LOG_FILE 1>&2 

	LAST_STATUS=$?
	if [ $LAST_STATUS -ne 0 ]; then
		echo "task $TASK failed"
		cat $LOG_FILE
		exit 5
	fi
done

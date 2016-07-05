#!/bin/sh

TARGET=$1

case $TARGET in
	wallabag) TASKS="install_apache2 install_mysql mysql_secure_installation install_php_5_6 install_php_composer mysql_create_wallabag_user_and_db" # install_and_configure_wallabag"
		;;
	kibana) TASKS="install_java8"
		;;
	grafana) TASKS="";;
esac

TASKS=""
TASKS="update_apt_index install_utils configure_tz $TASKS"

LOG_BASE=/vagrant/logs/$TARGET/
mkdir -p $LOG_BASE

for TASK in $TASKS; do
	echo "doing task $TASK"
	sudo -i sh /vagrant/${TASK}.sh ${TARGET} 2>$LOG_BASE/${TASK}.log 1>&2 
	LAST_STATUS=$?
	if [ $LAST_STATUS -ne 0 ]; then
		echo "task $TASK failed"
		cat $LOG_BASE/${TASK}.log
		exit 5
	fi
done

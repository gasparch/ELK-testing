#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

copy_kibana_config () {
	mv /opt/kibana/config/kibana.yml /opt/kibana/config/kibana.yml.orig
	cp $CWD/files/kibana/kibana-config.yml /opt/kibana/config/kibana.yml
}

copy_kibana_config &&
service_restart kibana

#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

copy_filebeat_config () {
	mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
	cp $CWD/files/wallabag/wallabag-filebeat.yml /etc/filebeat/filebeat.yml
}

copy_logstash_ssl_cert () { # {{{
	# make sure that keys are always on local machine
	mkdir -p /etc/pki/tls/certs /etc/pki/tls/private
	cp $LOGSTASH_CRT /etc/pki/tls/certs/logstash-forwarder.crt
} # }}}

copy_filebeat_config &&
copy_logstash_ssl_cert &&
service_restart filebeat

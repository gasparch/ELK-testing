#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

copy_logstash_ssl_keys () { # {{{
	# make sure that keys are always on local machine
	mkdir -p /etc/pki/tls/certs /etc/pki/tls/private
	cp $LOGSTASH_KEY /etc/pki/tls/private/logstash-forwarder.key
	cp $LOGSTASH_CRT /etc/pki/tls/certs/logstash-forwarder.crt
} # }}}

copy_logstash_processing_pipeline_configs () { # {{{
	cp $CWD/files/logstash_02_beats_input.conf.json /etc/logstash/conf.d/02-beats-input.conf
	cp $CWD/files/logstash_10_syslog_filter.conf /etc/logstash/conf.d/10-syslog-filter.conf
	cp $CWD/files/logstash_30_elasticsearch_output.conf.json /etc/logstash/conf.d/30-elasticsearch-output.conf
} # }}}

test_logstash_config() { # {{{
	service logstash configtest
} # }}}

copy_logstash_ssl_keys &&
copy_logstash_processing_pipeline_configs &&
test_logstash_config &&
service_restart logstash

#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

copy_elasticsearch_configs () { # {{{
	mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig
	cp $CWD/files/kibana/elasticsearch-config.yml /etc/elasticsearch/elasticsearch.yml
} # }}}

wait_for_elasticsearch_restart() { # {{{
	# it takes around 
	wait_for_REST_service "http://localhost:9200/" 50
	return $?
} # }}}

upload_filebeat_index_template () { # {{{
	curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@$CWD/files/kibana/elasticsearch-filebeat-index-template.json
} # }}}

copy_elasticsearch_configs &&
service_restart elasticsearch &&
wait_for_elasticsearch_restart &&
upload_filebeat_index_template

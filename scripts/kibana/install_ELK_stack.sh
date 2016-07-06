#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

add_elasticsearch_ppa () {
	echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" > /etc/apt/sources.list.d/elasticsearch-2.x.list
}

add_kibana_ppa () {
	echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" > /etc/apt/sources.list.d/kibana-4.4.x.list
}

add_logstash_ppa () {
	echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' > /etc/apt/sources.list.d/logstash-2.2.x.list
}

if ! check_package_installed elasticsearch || ! check_package_installed kibana || ! check_package_installed logstash; then
	add_elasticsearch_ppa &&
	add_logstash_ppa &&
	add_kibana_ppa &&
	apt_update_package_list &&
	apt_install_packages elasticsearch kibana logstash
fi


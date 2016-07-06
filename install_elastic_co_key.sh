#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

add_elastic_co_key() {
	wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
}

add_elastic_co_key


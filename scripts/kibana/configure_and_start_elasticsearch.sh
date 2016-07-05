#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

exit 

#sed /etc/elasticsearch/elasticsearch.yml network.host: localhost


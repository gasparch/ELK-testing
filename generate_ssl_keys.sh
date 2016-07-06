#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

# avoid regenerating key after we created it
if [ ! -f $LOGSTASH_KEY ]; then
	mkdir -p $SSLCA_ROOT/certs $SSLCA_ROOT/private
#	cd $SSLCA_ROOT
	openssl req -subj "/CN=${ELK_SERVER_NAME}/" -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout $LOGSTASH_KEY -out $LOGSTASH_CRT
fi

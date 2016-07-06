#!/bin/sh

CWD=$(dirname $(readlink -f $0))
CWD=${CWD%scripts/*}
cd $CWD

. $CWD/common.inc.sh

if ! grep -q '192.168.34' /etc/hosts; then
	cat $CWD/files/hosts_config >> /etc/hosts
fi


#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

for SVC in $SERVICE_LIST_TO_ENABLE; do
	update-rc.d $SVC defaults
	update-rc.d $SVC enable
done

#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

# Set the Server Timezone to CST
echo "Asia/Yerevan" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

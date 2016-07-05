#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

MYSQL_PASSWORD=`cat $MYSQL_PASS_FILE`

# secure MYSQL installation

SECURE_MYSQL=`expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL_PASSWORD\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
"`

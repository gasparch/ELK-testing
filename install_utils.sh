#!/bin/sh

CWD=$(dirname $(readlink -f $0))
cd $CWD

. $CWD/common.inc.sh

apt_install_packages $EXTRA_UTILS

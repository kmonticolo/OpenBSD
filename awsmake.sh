#!/bin/ksh

#
# get mirror list script
ftp -o testmirrors.sh https://raw.githubusercontent.com/kmonticolo/OpenBSD/master/testmirrors.sh
test -f testmirrors.sh && chmod +x testmirrors.sh
./testmirrors.sh
# install puppet git

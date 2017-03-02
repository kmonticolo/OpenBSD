#!/bin/ksh

#
# get mirror list script
#ftp -o testmirrors.sh https://raw.githubusercontent.com/kmonticolo/OpenBSD/master/testmirrors.sh
#test -f testmirrors.sh && chmod +x testmirrors.sh
#./testmirrors.sh
# install puppet git

# Ireland
export MIRROR=https://ftp.heanet.ie/pub/OpenBSD/
export TMPDIR=/home
ftp -o create-ami.sh https://raw.githubusercontent.com/ajacoutot/aws-openbsd/master/create-ami.sh                                        
test -f create-ami.sh && chmod +x create-ami.sh
create-ami.sh -n

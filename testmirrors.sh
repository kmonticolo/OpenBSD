#!/bin/sh
# 25.02.16, 07.09.16 kmonti
# script for test speed of OpenBSD mirrors

>/tmp/pingidoserwerow
ftp -o - http://www.openbsd.org/ftp.html >/tmp/ftp.html
grep "OpenBSD\/" /tmp/ftp.html | grep "/</a>"| grep http|sed -e 's/^........//g' -e 's/\/.*$//' >/tmp/serwery
grep "/</a>" /tmp/ftp.html |sed -e 's/^.*:\/\///g' -e 's/\/.*$//' |sort|uniq > /tmp/serwery
# zrobic http i ftp
wait=`cat /tmp/serwery | wc -l`
echo -n "wait" `echo "( $wait * 3 )"| bc` "seconds."
for i in `cat /tmp/serwery`;
  do j=`ping -q -c3 $i 2>/dev/null |grep round| cut -d \/ -f 5|cut -f1 -d .`
  echo -n $i " " $j >>/tmp/pingidoserwerow
  echo -n .
  echo >>/tmp/pingidoserwerow
done
grep round /tmp/pingidoserwerow |sed -e s'/\//\;/g' -e 's/\./,/g'
echo
#grep [0-9]$ /tmp/pingidoserwerow | sort -nk 2 |sed 's/$/\ ms/g'
fastest=`grep [0-9]$ /tmp/pingidoserwerow | sort -nk 2 |head -1 |cut -f 1 -d" "`
export FASTEST="http://${fastest}/pub/OpenBSD"
echo; echo -n "The fastest mirror is: $FASTEST"
echo
echo "export PKG_PATH=$FASTEST/`uname -r`/packages/`uname -p`/"
sed -i '/export\ PKG/s/^/#/' /root/.profile
echo "$FASTEST" >/root/.testmirrors
echo "export PKG_PATH=$FASTEST/`uname -r`/packages/`uname -p`/" >> /root/.profile
export PKG_PATH=$FASTEST/`uname -r`/packages/`uname -p`/
export MIRROR=$FASTEST
\rm -f /tmp/{pingidoserwerow,serwery,ftp.html}
#EOF

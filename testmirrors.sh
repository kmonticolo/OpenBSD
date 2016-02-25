#!/bin/sh
# 25.02.16 kmonti
# script for test speed of OpenBSD mirrors

>pingidoserwerow
ftp -o - http://www.openbsd.org/ftp.html >ftp.html
grep "OpenBSD\/" ftp.html | grep "/</a>"| grep http|sed -e 's/^........//g' -e 's/\/.*$//' >serwery
# zrobic http i ftp
wait=`cat serwery|wc -l`
echo -n "wait" `echo "( $wait * 3 )"| bc` "seconds."
for i in `cat serwery`;do j=`ping -q -c3 $i 2>/dev/null |grep round| cut -d \/ -f 5|cut -f1 -d .`; echo -n $i " " $j >>pingidoserwerow; echo -n .; echo >>pingidoserwerow; done
grep round pingidoserwerow |sed -e s'/\//\;/g' -e 's/\./,/g'
echo
cat pingidoserwerow |grep [0-9]$ | sort -nk 2 |sed 's/$/\ ms/g'
echo; echo -n "The fastest mirror is: "
echo `cat pingidoserwerow |grep [0-9]$ | sort -nk 2 |head -1 |cut -f 1 -d" "`
\rm -f pingidoserwerow serwery

#EOF

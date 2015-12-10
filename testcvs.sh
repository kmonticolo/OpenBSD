#!/bin/sh
# 10.12.15 kmonti
# script for test speed of ANONCVS servers response for OpenBSD

>pingidoserwerow
ftp -o - http://www.openbsd.org/anoncvs.html >anoncvs.html
grep CVSROOT= anoncvs.html |sed -e 's/^.*@//g' -e 's/:.*$//g' >serwery 2>/dev/null
#curl http://www.openbsd.org/anoncvs.html |grep CVSROOT= |sed -e 's/^.*@//g' -e 's/:.*$//g' >serwery
wait=`cat serwery|wc -l`
echo -n "wait " `echo "( $wait * 3 )"| bc` "seconds."
for i in `cat serwery`;do j=`ping -q -c3 $i|grep round| cut -d \/ -f 5|cut -f1 -d .`; echo -n $i " " $j >>pingidoserwerow; echo -n .; echo >>pingidoserwerow; done
#grep round pingidoserwerow |sed -e s'/\//\;/g' -e 's/\./,/g'
echo
cat pingidoserwerow |grep [0-9]$ | sort -nk 2 |sed 's/$/\ ms/g'
echo The fastest mirror is:
grep `cat pingidoserwerow |grep [0-9]$ | sort -nk 2 |head -1 |cut -f 1 -d" "` anoncvs.html |sed -e 's/^.*CVSROOT\>/CVSROOT/' -e 's/:\/cvs.*$/:\/cvs/g'

#EOF

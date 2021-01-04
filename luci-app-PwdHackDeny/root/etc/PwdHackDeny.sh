#!/bin/bash
# wulishui 20200120
# Author: wulishui <wulishui@gmail.com>

while :
do

mkdir /tmp/PwdHackDeny

logread|grep dropbear|grep "Bad password attempt"|tee /tmp/PwdHackDeny/badip.dropbear.log.tmp1|gawk '{match($0,"(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])",a)}{print a[0]}'| sort | uniq -c | sort -k 1 -n -r|awk '{if($1>='"5"') print $2}' >> /etc/badip.dropbear

cat /tmp/PwdHackDeny/badip.dropbear.log.tmp1|sed '/^ *$/d'|tail -1 >> /tmp/badip.dropbear.log.tmp2
cat /tmp/badip.dropbear.log.tmp2|sort -n|uniq -i > /tmp/badip.dropbear.log

cat /etc/badip.dropbear|sort -n|uniq -i|sed '/^ *$/d'|sed 's/^/add '"dropbearbadip"' &/g' > /tmp/PwdHackDeny/addbadip
if [ -s /tmp/PwdHackDeny/addbadip ]; then
ipset flush dropbearbadip
ipset restore -f /tmp/PwdHackDeny/addbadip 2>/dev/null
fi

cat /etc/badip.dropbear|sort -n|uniq -i > /tmp/PwdHackDeny/badip.dropbear
if [ -s /tmp/PwdHackDeny/badip.dropbear ]; then
cp /tmp/PwdHackDeny/badip.dropbear /etc/badip.dropbear
fi

#-------------------router-----------------

logread|grep uhttpd|grep "failed login on"|tee /tmp/PwdHackDeny/badip.router.log.tmp1|gawk '{match($0,"(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])",a)}{print a[0]}'| sort | uniq -c | sort -k 1 -n -r|awk '{if($1>='"5"') print $2}' >> /etc/badip.router

cat /tmp/PwdHackDeny/badip.router.log.tmp1|sed '/^ *$/d'|tail -1 >> /tmp/badip.router.log.tmp2
cat /tmp/badip.router.log.tmp2|sort -n|uniq -i > /tmp/badip.router.log

cat /etc/badip.router|sort -n|uniq -i|sed '/^ *$/d'|sed 's/^/add '"routerbadip"' &/g' > /tmp/PwdHackDeny/addbadip
if [ -s /tmp/PwdHackDeny/addbadip ]; then
ipset flush routerbadip
ipset restore -f /tmp/PwdHackDeny/addbadip 2>/dev/null
fi

cat /etc/badip.router|sort -n|uniq -i > /tmp/PwdHackDeny/badip.router
if [ -s /tmp/PwdHackDeny/badip.router ]; then
cp /tmp/PwdHackDeny/badip.router /etc/badip.router
fi

rm -r /tmp/PwdHackDeny

sleep 600

done


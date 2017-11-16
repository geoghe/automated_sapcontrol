#!/bin/bash
while read _SID
do

echo -e "$(tput setaf 1) $_SID $(tput sgr0)"

ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << EOF | grep -E 'hostname|vhene'
echo "$_SID" > /tmp/automation
ps -ef | grep -i dw | grep -i "$_SID" | cut -d= -f2 | uniq | rev | cut -d/ -f1 | rev | cut -d_ -f2 | cut -c 8- >> /tmp/automation
exit
EOF

ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << 'XOF' | grep -E 'hostname|vhene'
_SID2="$(head -n1 /tmp/automation)"
_INSTANCE2="$(tail -n1 /tmp/automation)"
sudo su -l "$_SID2"adm -c "sapcontrol -nr "$_INSTANCE2" -function GetSystemInstanceList" > /tmp/ariel
exit
XOF

echo -e "\n"

done < ENE_SID_LIST

Working!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
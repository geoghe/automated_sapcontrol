#!/bin/bash
while read _SID
do
	if [[ -n "$_SID" ]]; then
		echo "$_SID" | grep -o -E '[[:alpha:]]{3}' > /dev/null
		if [[ "$?" -eq '0' ]]; then
			ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << EOA | grep -E 'hostname|vhene'
echo $_SID > /tmp/automation
_SID="head -1 /tmp/automation
_INSTANCE="$(ps -ef | grep -i dw | grep -i "$_SID" | cut -d= -f2 | uniq | rev | cut -d/ -f1 | rev | cut -d_ -f2 | cut -c 8-)"
sudo su -l "$_SID"adm -c "sapcontrol -nr "$_INSTANCE" -function GetSystemInstanceList"
exit
EOA
		fi
	fi
done < ENE_SID_LIST
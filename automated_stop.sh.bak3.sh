#!/bin/bash
while read _SID
do
	if [[ -n "$_SID" ]]; then
		echo "$_SID" | grep -o -E '[[:alpha:]]{3}' > /dev/null
		if [[ "$?" -eq '0' ]]; then
			ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << EOF | grep -E 'hostname|vhene'
			echo $_SID > /tmp/automation
			exit
EOF
			ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << 'EOX' | grep -E 'hostname|vhene'
			_PROD="$(/usr/sbin/tic_info "Virtual Machine" "$(hostname)" | grep PRIORITY | cut -d\' -f2 | xargs)"
			if [ "$_PROD" == "prod" ]; then
				printf "Script is not valid for PROD servers\n"
				exit
			else
				_SID="$(head -1 /tmp/automation)"
				_INSTANCE="$(ps -ef | grep -i dw | grep -i "$_SID" | cut -d= -f2 | uniq | rev | cut -d/ -f1 | rev | cut -d_ -f2 | cut -c 8-)"
				sudo su -l "$_SID"adm -c "sapcontrol -nr "$_INSTANCE" -function GetSystemInstanceList"
				exit
			fi
EOX
		else
			echo "$_SID doesnt meet the convention of an SID"
		fi
	else
		echo "NULL - No SID declared"
	fi

done < ENE_SID_LIST
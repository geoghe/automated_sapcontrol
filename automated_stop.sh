#!/bin/bash

#prod(){
#ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << 'TOF' | grep dummy
#_VM=$(echo $HOSTNAME)
#/usr/sbin/tic_info 'Virtual Machine' $_VM | grep PRIORITY | cut -d\' -f2 | xargs > /tmp/automation_check
#exit
#TOF
#}

status(){
ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << EOF | grep dummy
echo "$_SID" > /tmp/automation
ps -ef | grep -i dw | grep -i "$_SID" | cut -d= -f2 | uniq | rev | cut -d/ -f1 | rev | cut -d_ -f2 | cut -c 8- >> /tmp/automation
exit
EOF

ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << 'XOF' | grep -E 'hostname|vhene'
_SID2="$(head -n1 /tmp/automation)"
_INSTANCE2="$(tail -n1 /tmp/automation)"
sudo su -l "$_SID2"adm -c "sapcontrol -nr "$_INSTANCE2" -function GetSystemInstanceList"
exit
XOF
}

stop(){
ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << EOF | grep dummy
echo "$_SID" > /tmp/automation
ps -ef | grep -i dw | grep -i "$_SID" | cut -d= -f2 | uniq | rev | cut -d/ -f1 | rev | cut -d_ -f2 | cut -c 8- >> /tmp/automation
exit
EOF

ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << 'XOF' | grep -E 'hostname|vhene'
_SID2="$(head -n1 /tmp/automation)"
_INSTANCE2="$(tail -n1 /tmp/automation)"
sudo su -l "$_SID2"adm -c "sapcontrol -nr "$_INSTANCE2" -function GetSystemInstanceList"
exit
XOF
echo -e "$(tput setaf 1)STOP signal was sent for this system $(tput sgr0)"
}

start(){
ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << EOF | grep dummy
echo "$_SID" > /tmp/automation
ps -ef | grep -i dw | grep -i "$_SID" | cut -d= -f2 | uniq | rev | cut -d/ -f1 | rev | cut -d_ -f2 | cut -c 8- >> /tmp/automation
exit
EOF

ssh -oStrictHostKeyChecking=no -q -tt vhene"$_SID"ci.rot.hec.enelint.global << 'XOF' | grep -E 'hostname|vhene'
_SID2="$(head -n1 /tmp/automation)"
_INSTANCE2="$(tail -n1 /tmp/automation)"
sudo su -l "$_SID2"adm -c "sapcontrol -nr "$_INSTANCE2" -function GetSystemInstanceList"
exit
XOF
echo -e "$(tput setaf 2)START signal was sent for this system $(tput sgr0)"
}

exit_msg(){
        echo -e "$(tput setaf 1)cbb_project.sh: Missing arguments.\nPlease specify the action\nUsage:\n\tcbb_project.sh [status|start|stop]\n$(tput sgr0)"
        exit 1
}

_function="${1:-"status"}"

echo "$_function" | grep -E 'start|status|stop' >/dev/null || exit_msg

echo "As per the ENE_SID_LIST, you want to $(tput setaf 3)"$_function"$(tput sgr0) the following systems:\n"
cat ENE_SID_LIST
echo "Type complete [yes|no] if you want to proceed:\n"
read _yesno

if [[ "$_yesno" == 'yes' ]]; then
        while read _SID
        do
                if [[ -n "$_SID" ]]; then
                        echo "$_SID" | grep -o -E '[[:alnum:]]{3}' > /dev/null 2>&1
                        _SID_check="$?"
                        nc -vz vhene"$_SID"ci.rot.hec.enelint.global 22 > /dev/null 2>&1
                        _SSH_check="$?"

                        if [[ "$_SID_check" -eq '0' && "$_SSH_check" -eq '0' ]]; then
                                echo -e "$(tput setaf 1) $_SID $(tput sgr0)"
                                case "$_function" in
                                        status) status ;;
                                        start)  start  ;;
                                        stop)   stop   ;;
                                esac
                        else
                                echo -e "$(tput setaf 1)"
                                [[ "$_SID_check" -eq '0' ]] || echo "$_SID doesnt meet the convention of an SID"
                                [[ "$_SSH_check" -eq '0' ]] || echo "$_SID server is not reachable, check is a valid SID"
                                echo -e "$(tput sgr0)"
                        fi
                else
                        echo -e "$(tput setaf 1)"
                        echo "NULL - No SID declared"
                        echo -e "$(tput sgr0)"
                fi
        done < ENE_SID_LIST
else
        echo "$_yesno was typed, exit."
fi
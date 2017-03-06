#!/bin/bash
declare -a ANSIBLE_OPTS
while [[ $# > 1 ]]
do
key="$1"

case $key in
    --ansible_target)
    TARGET="$2"
    shift # past argument
    ;;
    --galaxy_role)
    ROLE="$2"
    shift # past argument
    ;;
    --ansible_ssh_user)
    USERID="$2"
    shift # past argument
    ;;
    --ansible_ssh_pass)
    PASSWORD="$2"
    shift # past argument
    ;;
    --ansible_sudo_pass)
    SUDO_PW="$2"
    shift # past argument
    ;;
    --ansible_variable_file)
    VAR_FILE="$2"
    shift # past argument
    ;;
    *)
    ANSIBLE_OPTS+=($key)  # ansible role specific option
    ANSIBLE_OPTS+=($2)
    shift
    ;;
esac
shift # past argument or value
done

USERID=`echo $USERID | sed -e "s/^'//" | sed -e "s/'\$//"`
TARGET=`echo $TARGET | sed -e "s/^'//" | sed -e "s/'\$//"`
PASSWORD=`echo $PASSWORD | sed -e "s/^'//" | sed -e "s/'\$//"`
SUDO_PW=`echo $SUDO_PW | sed -e "s/^'//" | sed -e "s/'\$//"`

HOME=$(getent passwd `whoami` | cut -d: -f6)

echo "Executing Ansible role '$ROLE' against server '$TARGET' ... "

if grep -q "$TARGET" "$HOME/.ssh/known_hosts"; then
 echo "SSH Key is already configured"
else	
 ssh-keyscan -t rsa,dsa $TARGET >> $HOME/.ssh/known_hosts
 sort -u $HOME/.ssh/known_hosts > $HOME/.ssh/known_hosts.unique
 cat $HOME/.ssh/known_hosts.unique > $HOME/.ssh/known_hosts
fi
	
$TRILOGYHOME/trilogycli ANSIBLE install $ROLE

echo "- hosts: all" > /tmp/$$.yml
if [[ "$SUDO_PW" != "none" && "$SUDO_PW" != "" ]]; then
 echo "  sudo: yes" >> /tmp/$$.yml
fi

echo "  vars:" >> /tmp/$$.yml
if [ "$USERID" != "" ]; then
 echo "    ansible_ssh_user: $USERID" >> /tmp/$$.yml
fi

if [ "$PASSWORD" != "" ]; then
 echo "    ansible_ssh_pass: $PASSWORD" >> /tmp/$$.yml
fi

if [[ "$SUDO_PW" != "none" && "$SUDO_PW" != "" ]]; then
 echo "    ansible_sudo_pass: $SUDO_PW" >> /tmp/$$.yml
fi

ELEMENTS=${#ANSIBLE_OPTS[@]}

for ((i=0; i<$ELEMENTS; i++));
do
  tmp_var=${ANSIBLE_OPTS[${i}]}
  var=`echo $tmp_var | sed -e 's/^-\+//'`
  i=$((i+1))
  val=${ANSIBLE_OPTS[${i}]}
  echo "    $var: $val"  >> /tmp/$$.yml
done  

echo "   " >> /tmp/$$.yml
echo "  roles:" >> /tmp/$$.yml
echo "     - { role: $ROLE }" >> /tmp/$$.yml

cat /tmp/$$.yml | sed "s/pass: .*/pass: XXXXXXX/"

$TRILOGYHOME/trilogycli KNOWN_HOSTS $TARGET
echo ansible /tmp/$$.yml -i "$TARGET,"
$TRILOGYHOME/trilogycli ANSIBLE2 /tmp/$$.yml -i "$TARGET,"
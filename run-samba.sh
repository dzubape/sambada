#!/bin/bash

function print_help() {
  echo "Script usage:"
  echo -e "\t-h\tfor this help"
  echo -e "\t-u\tfor samba username"
  echo -e "\t-p\tfor samba user password"
  echo -e "\t-d\tlocal_path=label (multiple)"
}

if [ $# -eq 0 ]
then
  print_help
  exit -1
fi

volumes=""
volume_counter=1
sharades=""

while getopts "hu:p:d:" "opt"
do
case $opt in
'h') print_help && exit ;;
'u') username=$OPTARG ;;
'p') password=$OPTARG ;;
'd')
  dirs="${OPTARG}"
  echo $dirs
  IFS_bak=$IFS
  IFS='='
  read -ra DIRS <<< "$dirs"
  IFS=$IFS_bak
  volumes="$volumes -v ${DIRS[0]}:/bob${volume_counter}"
  sharades="$sharades -s ${DIRS[1]};/bob${volume_counter};yes;no;no;${username}"
  (( volume_counter += 1 ))
;;
esac
done

echo "sharades: ${sharades}"
echo "volumes: ${volumes}"
echo "logopas: ${username};${password}"

#exit

if [ -z "$username" ]
then
  echo "No username specified (option -u)"
  print_help
  exit -1
fi

if [ -z "$password" ]
then
  echo "No password specified (option -p)"
  print_help
  exit -1
fi

if [ -z "$volumes" ]
then
  echo "No volumes specified (option -d)"
  print_help
  exit -1
fi

docker run \
--name samba \
--restart=always \
-ti \
-d \
-e USERID=$(id -u) \
-e GROUPID=$(id -g) \
-p 139:139 \
-p 445:445 \
$volumes \
dperson/samba \
-r \
-p \
-u "${username};${password}" \
$sharades

#<name;/path>[;browse;readonly;guest;users;admins;writelist;comment]

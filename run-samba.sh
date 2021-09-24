#!/bin/bash

function print_help() {
  echo "Script usage:"
  echo -e "\t-h\tfor this help"
  echo -e "\t-u\tfor samba username;password"
#  echo -e "\t-p\tfor samba user password"
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
users=

while getopts "hu:d:" "opt"
do
case $opt in
'h') print_help && exit ;;
'u')
  read -r username password <<< $(echo "$OPTARG" | tr ";" " ")
  echo "username: $username"
  echo "password: $password"
  users="$users -u $username;$password"
;;
'd')
  volume="${OPTARG}"
  echo "volume option: $volume"
  read -r volume volume_user <<< $(echo "$volume" | tr ";" " ")
  [[ -z volume_user ]] && volume_user=$username
  read -r volume_dir volume_name <<< $(echo "$volume" | tr "=" " ")
  echo "volume_dir: ${volume_dir}"
  echo "volume_name: ${volume_name}"
  echo "volume_user: ${volume_user}"
  [[ -z "$volume_user" ]] && echo "No user defined" && exit -1
  volumes="$volumes -v ${volume_dir}:/bob${volume_counter}"
  sharades="$sharades -s ${volume_name};/bob${volume_counter};yes;no;no;${volume_user}"
  (( volume_counter += 1 ))
  unset volume_user
;;
esac
done

echo "sharades: ${sharades}"
echo "volumes: ${volumes}"
echo "logopas: ${username};${password}"

#exit

if [ -z "$users" ]
then
  echo "No users specified (option -u)"
  print_help
  exit -1
fi

if [ -z "$volumes" ]
then
  echo "No volumes specified (option -d)"
  print_help
  exit -1
fi 

[[ -z $SAMBA_USERID ]] && SAMBA_USERID=$(id -u)
[[ -z $SAMBA_GROUPID ]] && SAMBA_GROUPID=$(id -g)

docker run \
--name samba \
--restart=always \
-d \
-e USERID=$SAMBA_USERID \
-e GROUPID=$SAMBA_GROUPID \
-p 139:139 \
-p 445:445 \
$volumes \
dperson/samba \
-r \
-p \
-g "map archive = no" \
-g "map system = no" \
-g "map hidden = no" \
$users \
$sharades

#<name;/path>[;browse;readonly;guest;users;admins;writelist;comment]

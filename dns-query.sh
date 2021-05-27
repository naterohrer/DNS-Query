#!/bin/bash
clear
version="DNS Reponse Time: v1.0"

if [ $# -eq 0 ] #if arguements are empty set default domain
  then
                domain="google.com"
else

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in #cycle through parameters
  -v | --version )
    echo $version
    exit
    ;;
  -d | --domain )
    shift; domain=$1
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi



fi
#Build an array List of DNS Servers:
declare -A full_list
#Google
full_list["google\t"]=8.8.8.8
        full_list+=(
        #cloudflare
        ["cloudflare"]=1.1.1.1

        #OpenDNS
        ["opendns"]=208.67.222.222

        #Comodo Secure DNS
        ["comodo\t"]=8.26.56.26

        #Verisign DNS
        ["verisign"]=64.6.65.6

        #Yandex
        ["yandex\t"]=77.88.8.7

        #Quad9
        ["quad9\t"]=9.9.9.9

        #Neustar
        ["neustar"]=64.6.64.6

        #OpenNIC
        #["opennic"]=198.206.14.241
        )
echo "Domain: ${domain}"
echo "DNS Server:               Response 1              Response 2             Response 3               Response 4"
echo "-----------------------------------------------------------------------------------------------------------"
for key in ${!full_list[@]}; do
#       echo ${key}
        arr=("${key}")
        for ((c=0; c<4; c++)); do
                arr+=("\t\t\t" $(dig @${full_list[${key}]} $domain +noall +answer +stats | grep -oEe '[0-9]+ msec' | tr -d 'msec'))
        done
        echo -e ${arr[@]}
done

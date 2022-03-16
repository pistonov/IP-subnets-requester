#!/bin/bash

# Help ##########################################################################

if [[ $# -eq 0 ]] ; then
   echo "Get Country IP subnets by code"
   echo
   echo "Syntax: ./get_subnets.sh <Country code> <path to output>"
   echo    
   echo "Example: ./get_subnets.sh RU /tmp/net.txt"
   echo
   exit 0
fi

# Main ##########################################################################

HE_db=$(curl -s -A --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" https://bgp.he.net/country/$1)
AS_db=$(echo "$HE_db" | grep "/AS" | grep -o -P '(?<=title=").*(?=</a>)' | cut -d' ' -f1)

while read -r AS
do
    AS_route_req=$(whois -h whois.ripe.net -- -T route $AS -i origin | grep "route:" | cut -d' ' -f11)
    if [ "$AS_route_req" != "" ]; then
        AS_route+="\n"$AS_route_req
    fi
    echo -e "$AS_route_req"
done <<< "$AS_db"

echo -e "$AS_route" > $2

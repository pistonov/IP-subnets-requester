#!/bin/bash

# Help ##########################################################################

if [[ $# -eq 0 ]] ; then
   echo "Get Country IP subnets by code"
   echo
   echo "Syntax: ./get_subnets.sh <Country Code> <Whois Server> <path to output>"
   echo  
   echo "RIPE (Europe)"
   echo "whois.ripe.net"
   echo  
   echo "AFRINIC (Africa)"
   echo "whois.afrinic.net"
   echo 
   echo "APNIC (Asia Pacific)"
   echo "whois.apnic.net"
   echo 
   echo "ARIN (Northern America)"
   echo "whois.arin.net"
   echo 
   echo "LACNIC (Latin America and the Carribean)"
   echo "whois.lacnic.net"
   echo 
   echo "--------------------------------------------------------"
   echo "Example: ./get_subnets.sh RU whois.ripe.net /tmp/net.txt"
   echo
   exit 0
fi

# Main ##########################################################################

HE_db=$(curl -s -A --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" https://bgp.he.net/country/$1)
AS_db=$(echo "$HE_db" | grep "/AS" | grep -o -P '(?<=title=").*(?=</a>)' | cut -d' ' -f1)

echo $AS_db

while read -r AS
do
    AS_route_req=$(whois -h $2 -- -T route $AS -i origin | grep "route:" | cut -d' ' -f11)
    if [ "$AS_route_req" != "" ]; then
        AS_route+="\n"$AS_route_req
    fi
    echo -e "$AS_route_req"
done <<< "$AS_db"

echo -e "$AS_route" > $3

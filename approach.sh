#!/bin/bash

# Target subdomain
echo ""
echo ""
echo ""
echo " █████╗ ██████╗ ██████╗ ██████╗  ██████╗  █████╗  ██████╗██╗  ██╗"
echo "██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔════╝██║  ██║"
echo "███████║██████╔╝██████╔╝██████╔╝██║   ██║███████║██║     ███████║"
echo "██╔══██║██╔═══╝ ██╔═══╝ ██╔══██╗██║   ██║██╔══██║██║     ██╔══██║"
echo "██║  ██║██║     ██║     ██║  ██║╚██████╔╝██║  ██║╚██████╗██║  ██║"
echo "╚═╝  ╚═╝╚═╝     ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
echo ""
echo "                                         By ~ Prakhar_Porwal"
echo ""


#Make Target Directory
echo ""
echo "-----------------------------------------------------------------------------------------------"
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[34m[INFO] \e[36m Making Directory for $1 \e[0m"
echo "-----------------------------------------------------------------------------------------------"
echo ""
mkdir $1
cd $1
touch subdomains.txt

echo "-----------------------------------------------------------------------------------------------"
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[31m[WARNING] \e[33m Make sure you added IP ranges and domains from shodan in subdomains.txt \e[0m"
echo "-----------------------------------------------------------------------------------------------"
echo ""
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[35m[PROMPT] \e[36m Click to proceed further..!! \e[0m"
read

# Subdomain Discovery using Amass
echo ""
echo "-----------------------------------------------------------------------------------------------"
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[33m[OK] \e[36m Started Subdomain Discovery from Amass \e[0m"
echo "-----------------------------------------------------------------------------------------------"
echo ""
amass enum -active -passive -d $1 -o subdomains.txt

# Add words to the Domain
echo ""
echo "-----------------------------------------------------------------------------------------------"
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[33m[OK] \e[36m Adding more Possible Subdomains \e[0m"
echo "-----------------------------------------------------------------------------------------------"
echo ""
while read -r word; do
  echo "$word.$1" >> subdomains.txt
done < /path/to/subdomains.txt

# Combine and filter uniques
echo ""
echo "-----------------------------------------------------------------------------------------------"
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[33m[OK] \e[36m Combined and filter unique & live hosts \e[0m"
echo "-----------------------------------------------------------------------------------------------"
echo ""
cat subdomains.txt | sort -u | httpx -silent -sc -title | tee -a livehosts.txt


# Permutations Bruteforce
echo ""
echo "-----------------------------------------------------------------------------------------------"
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[33m[OK] \e[36m Started Permutation Bruteforce \e[0m"
echo "-----------------------------------------------------------------------------------------------"
echo ""


### FOR PERMUTATION ###
while read -r subdomain; do
        subdomain="$subdomain"
        prefix_suffix="${subdomain%.*}"
        prefix="${prefix_suffix%.*}"
        echo "$prefix" | cut -d'/' -f3 | sort -u | tee -a prefix.txt
done < livehosts.txt

cat /path/to/permutations.txt >> prefix.txt

for word in $(cat prefix.txt | sort -u); do
    for nest in $(cat prefix.txt | sort -u); do
         echo "$word.$nest.$1" >> permuted.txt
         echo "$word-$nest.$1" >> permuted.txt
    done
done

#if [ $(cat permuted.txt | wc -l) -lt 25000 ]; then 
echo ""
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[35m[PROMPT] \e[33m There are $(cat permuted.txt | wc -l) subdomains to resolve.It will take longer..!!  \e[0m"
echo ""
python3 - <<END
import socket
import time

        # Resolving DNS
def resolve_dns(hostname):
    try:
        ip_address = socket.gethostbyname(hostname)
        return ip_address
    except socket.gaierror as e:
        return None


filename = "permuted.txt"
output_filename = "resolvers.txt"

with open(filename, 'r') as file,open(output_filename, 'w') as output:
    print("\n\n\033[1;32m[STATUS] [INFO] Started Resolving at :: \033[0m",time.strftime("%Y-%m-%d %H:%M:%S"))
    iteration = 0

    for subdomain in file:
        iteration = iteration+1
        subdomain = subdomain.strip()
        ip_address = resolve_dns(subdomain)

        if(ip_address != None):
            print(f"\033[1;31m {subdomain} \033[0m :: \033[1;32m {ip_address} \033[0m")
            output.write(f"{subdomain} : {ip_address}\n")

        if(iteration % 500 == 0):
            print(f"\033[1;34m\n[STATUS] [INFO] TOTAL {iteration} subdomains Resolved\033[0m")


print("\n\033[1;32m[STATUS] [INFO] Successfully Resolved at :: \033[0m",time.strftime("%Y-%m-%d %H:%M:%S"))
print("\n\033[1;32m[STATUS] [INFO] Resolved hosts saved into : \033[1;31mresolvers.txt\033[0m\n\n")
END
fi

# Port Scanning using Naabu
echo ""
echo "-----------------------------------------------------------------------------------------------"
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[33m[OK] \e[36m Port Scanning \e[0m"
echo "-----------------------------------------------------------------------------------------------"
echo ""
cat livehosts.txt | cut -d'[' -f1 | cut -d'/' -f3 | naabu -l livehosts.txt -p 21,139,443,445,1099,2082,2083,3000,4243,5000,8443,8000,8080,8081,8089,8084,8088,8888,9090,9443,10000 -o naabu.txt

# Filtering IP ranges for 403,401 and running nuclei scan
echo ""
echo "-----------------------------------------------------------------------------------------------"
echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[33m[INFO] \e[36m Filter 403,401 IP ranges and going for Nuclei Scan \e[0m"
echo "-----------------------------------------------------------------------------------------------"
echo ""
cat livehosts.txt | grep -E -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | httpx -sc | grep -E '403|401' | cut -d'[' -f1 | cut -d'/' -f3 | tee -a forbidden_ips.txt
echo ""
if [ $(cat forbidden_ips.txt | wc -l) -lt 30 ]; then
    echo -e "\e[31m[+]\e[36m $(date +["%T"]) \e[35m[PROMPT] \e[33m There are $(cat forbidden_ips.txt | wc -l) IPs to Scan. It will take time..!!\e[0m"
    echo ""
    echo "==============================================================================================="
    echo -e "\e[31m[+]\e[32m $(date +["%T"]) \e[33m[OK] \e[36m Starting Nuclei on $(cat forbidden_ips.txt | wc -l) Forbidden/Unauthorize Hosts \e[0m"
    echo "==============================================================================================="
    echo ""
   nuclei -l forbidden_ips.txt
fi

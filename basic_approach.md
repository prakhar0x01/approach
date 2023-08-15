# Take a subdomain , what you can do ...

### 1 - Directory brute-forcing 

    dirsearch -u abc.target.com -w /path/to/wordlist.txt -x 400,404 -o directories.txt

### 2 - Crawl that subdomain 
       
    waybackurls abc.target.com | gau abc.target.com | sort -u | httpx -mc 200,301,302 -o all_urls.txt  

### 3 - Filter js files & analyse manually (Personally recommend..!!)

    grep -E "\.(js)$" all_urls.txt > all_js.txt

### 4 - Look for other juicy files

    grep -E "\.(exe|txt|log|cache|secret|db|backup|yml|json|gz|rar|zip|config|py|sql|bak|old|bkp|ini|sh|rb|cgi|jar|key|ovpn|htpasswd|htaccess|dockerfile)$" all_urls.txt > juicy_files.txt 


### 5 - Filter the Endpoints 

    cat all_urls.txt | sed "s/=[^&]*/=/" > all_endpoints.txt

### 6 - Check for parameters by gf(by @tomnomnom)

     cat all_endpoints.txt | gf xss > xss_endpoints.txt
     cat all_endpoints.txt | gf ssrf > ssrf_endpoints.txt
     cat all_endpoints.txt | gf sqli > sqli_endpoints.txt
     cat all_endpoints.txt | gf idors > idors_endpoints.txt
     cat all_endpoints.txt | gf lfi > lfi_endpoints.txt

### 7 - You can also audit that subdomain using burp active scan

    Target --> Scope --> add [abc.target.com] --> sitemap --> Right click on [abc.target.com] --> Actively Scan this host
 
### 8 - Do network scan , it might be possible that they run some hidden services (also use nmap script scan).

    nmap -Pn -vv <abc.target.com>            // you can also use naabu and other tools
    nmap -T5 -Pn -vv -A -p port1,port2,port3 --script vuln <abc.target.com> -oN network.txt

### 9 - Run nuclei , may be you get low hanging bugs or any CVE

    nuclei -u abc.target.com
### 10 - Try google dorks and github dorks.

    Quick Google Dorks : https://twitter.com/TakSec/status/1640072219777978375
    Quick Github Dorks : https://github.com/techgaun/github-dorks/blob/master/github-dorks.txt

### 11 - If you found some `/path` that show 403,401 then spend some time with it & try to bypass it.

    1) Bypass by adding headers: X-Originating-IP, X-Forwarded-For, X-Client-IP..etc
    you can also use this automated tool : 
   `https://github.com/Dheerajmadhukar/4-ZERO-3`
   
    2) Bypass with payload : 1 - /login/..;/admin
                           2 - /..;/admin
                           3 - /admin/~
                           4 - /./admin/./
                           5 - /admin?parameter
                           6 - /%2e/admin
                           7 - /admin# 
 
    3) Bypass by changing HTTP methods : Change `GET` to `POST`, observe application behaviour

    4) Bypass via IP : Access the target forbidden content by it's IP. 

    5) Check urls in WebArchive for that particular subdomain, may be you get any hidden endpoint. 
      
### 12 - Do not leave 401,403 subdomains..!!
    1) Check urls in WebArchive for that particular subdomain, may be you get any hidden endpoint. 
   `https://web.archive.org/cdx/search/cdx?url=*.target.com&fl=original&collapse=urlkey`
    
    2) Visit that subdomain by IP, may be you will able to bypass WAF(Web-appliction-firewall)
    
    3) Try Content discovery according to technology.
    
    4) Try to fuzz hidden API endpoints.
    
    5) Port Scan for : 
   `21,139,443,445,1099,2082,2083,3000,4243,5000,8443,8000,8080,8081,8089,8084,8088,8888,9090,9443,10000`

    6) Do subdomain discovery for that subdomain : 
   `subfinder -d abc.target.com -silent | httpx -silent`

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### NOTE : 
  #### This approach is useful for beginners and those who are having difficulty approaching a subdomain. If you're already on track this might not be necessary for you..!!

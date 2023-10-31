
# APPROACH

#### If you're facing problems with how to approach a subdomain for testing, here is your simple approach to elevate your security game ..!!

## 1 - Overview 📝
This document outlines a simple approach to test a subdomain for beginners. It also includes recommended tools for automation and resources.

## 2 - Prerequisites
Before you begin testing, ensure that you have the following:

- OS - Any Linux distribution.
- Programming Languages - Familiar with bash and python.
 
### 3 - Tools 🔍
Some opensource tools are recommended for script `approach` :
 - Dirsearch : https://github.com/maurosoria/dirsearch
 - httpx : https://github.com/projectdiscovery/httpx
 - Subfinder : https://github.com/projectdiscovery/subfinder
 - Amass : https://github.com/owasp-amass/amass
 - Nmap : https://nmap.org/download
- You can add some other open-source tools to your script.

## 4 - Basicapproach.md 🔍 [LINK](https://github.com/prakhar0x01/approach/blob/main/basic_approach.md)
 - If you've any problem on **_How to approach a subdomain for testing_** or **_what can i do with a subdomain ?_**, then you should read this.
 - This note provides tips and one-liners to help you save time and clear up confusion.

### 5 - Approach.sh 🤖 [LINK](https://github.com/prakhar0x01/approach/blob/main/approach)
 - An Automated Script written in (python & bash)
#### Usage
##### Clone this repo and move approach to your **_`/usr/local/bin/`_**
```sh
git clone https://github.com/prakhar0x01/approach.git
mv approach /usr/local/bin/ 
approach -h
```
<img src=images/approach.png>

 - You can configure it according to your needs.
##### NOTE: You should not use this script to resolve permuted subdomains blindly (with the given 'permutations.txt'). It will take days to resolve all the permuted hosts.
##### NOTE: You have to configure some parts in `approach.sh` such as **_`path`_** to your wordlists and **_`filenames`_**, This Script is just a reference of Automation.

## 6 - Permutations.txt 📃 [LINK](https://github.com/prakhar0x01/approach/blob/main/permutations.txt)
 - Wordlists for Permutations Bruteforcing.

## 7 - Conclusion
This basic approach provides a guide for beginners to approach a subdomain for security vulnerabilities. However, you should continue to expand your knowledge and experience with different testing techniques and tools.

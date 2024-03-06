#!/bin/bash

# Enter the target domain
target="example.com"

# Perform subdomain enumeration using amass
amass enum -d $target -o adomains.txt

# Perform subdomain enumeration using sublist3r
sublist3r -d $target -o sdomains.txt

# Perform port scanning using nmap
nmap -p- -T4 -oN scan_results.txt $target

# Extract the discovered subdomains from the domains file
cat domains.txt | grep -Eo '[a-zA-Z0-9.-]+\.'$target | sed 's/\.$//' > subdomains.txt

# Probe the discovered subdomains for HTTP availability using httprobe
cat subdomains.txt | httprobe -p 80,443 > http_urls.txt

# Perform directory enumeration using dirsearch
dirsearch -L http_urls.txt -e php,asp,aspx,jsp -x 403,404 -w /path/to/wordlist.txt -t 50 -r -o dirsearch_results.txt

# Print the results
echo "Discovered subdomains:"
cat subdomains.txt
echo "Port scanning results:"
cat scan_results.txt
echo "HTTP URLs:"
cat http_urls.txt
echo "Directory enumeration results:"
cat dirsearch_results.txt

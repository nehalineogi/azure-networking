# Session 4: DNS Options in Azure : The Art of The Possible

Agenda
1. Introduction (David O'Keefe) (5 min)

2. DNS Options in Azure: The Art of The Possible (Nehali Neogi) (30 min)

3. Networking Expert Presentation (Daniel Mauser) (25 min)

# [Feedback Form](https://forms.microsoft.com/r/9HSZnXTPSQ)

Your feedback in important to us. Please take a few minutes survery [here](https://forms.microsoft.com/r/9HSZnXTPSQ)




# FAQs

Sign up for future sessions:
https://www.linkedin.com/feed/update/urn:li:activity:7024859847699365888/


Nehali's Youtube Channel:

https://www.youtube.com/channel/UC5x8jb_AMMAqMuFcMfX8RcA


Previous Session Recording links:

https://github.com/nehalineogi/azure-networking#join-us-for-live-sessions


Link to Daniel's DNS Integration Scenarios lab

https://github.com/dmauser/PrivateLink/tree/master/DNS-Integration-Scenarios

Daniel's Private DNS Resolver lab

https://github.com/dmauser/azure-dns-private-resolver/tree/main/adr-lab


Private EP Subnet Restrictions:


https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview#subnet-restrictions


# Test drive Using Dig commands

dig red.nehalineogi.org

dig red.nehalineogi.org  +noall +answer

dig +trace red.nehalineogi.org

dig nnstorage101.blob.core.windows.net +noall +answer


Capture DNS traffic
 tcpdump -ni eth0 not port 22 and port 53


## Troubleshooting


Clear DNS Cache

Linux 

sudo systemd-resolve --flush-caches

Windows

ipconfig /flushdns
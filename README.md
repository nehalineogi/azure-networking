# Azure Networking: The Art of The Possible and the *why*

The purpose of this repo is to deliver **layered, reusable and github friendly** network architecture diagrams for Cloud Solutions Architects to run effective Azure design and skilling sessions. The repository will include tips and tools for effective story telling that explain the **why behind the design options based on requirements** and the art of the possible.  The design areas include - Azure Networking, Hybrid connectivity architectures, routing, firewalling, load balancing, multi-region, secure design, cross functional networking areas and AKS networking. The content is based on **real customer and partner design sessions** with collaboration from cross-functional architects.  The networking complexity is broken down into **layers** with **one diagram** per design area using [draw.io](https://app.diagrams.net/) now [diagrams.net](https://www.diagrams.net/). This repo will include configuration snippets to reduce the lab prep time and the need to leave the labs running for demos.

# [Youtube Channel](https://www.youtube.com/channel/UC5x8jb_AMMAqMuFcMfX8RcA)

### Playlist - Azure Networking Series(The Art of The Possible)

1. Part-1: Creating Network Diagrams Using draw.io
2. Part-2: Hub-spoke-design (Single Region)
3. Part-3: Hub-spoke-design (Multi Region)
4. Part-4: Azure Virtual WAN (vWAN)
5. Part-5: Load Balancing in Azure (to be uploaded...stay tuned)
6. Part-6: Load Balancing demos



# Scope: Reusable and Layered Network Diagrams

**Target Audience**:  Cloud Solution Architects, Network Architects, Cloud Infrastructure Architects, Solution Engineers

**Scope**
- Build Reusable and github friendly network architecture diagram templates
- Layered diagrams to run effective Azure Design and skilling sessions 
- Real world use cases dervied from working with Microsoft customers
- Level 100 to level 500 scenarios in one diagram
- Understand the why behind the design decision
- Minimize lab time
- Growth mindset

**Scheduled Sessions**

  **[Part 1](#join-us-for-live-sessions)** (Hub-Spoke with ARS(Azure Route Server), Azure Virtual WAN, Load Balancing, DNS in Azure, NVA HA and Private Endpoint)



```python
Future sessions coming soon, stay tuned....
```


**Part 2** (Networking in Cross Functional Solution Areas) (AKS, Azure Data Factory, APIM, App Services)

**Part 3** (Advanced Networking and Security) (IPv6, AzFW, DDoS, ExpressRoute Designs, AVS, AVD)

--
# Join us for live sessions


We have limited spots available so if you are interested to join live sesssion please fillout [a form](https://forms.office.com/r/MM5MgmN1iA) with your role, email ID and session of interest. We will serve the request on the first come first serve basis. This will be a virtual teams meeting. Join us to learn, **connect with your peers in the industry** and share your use cases and design variations.  If you are a partner and would like to be a guest speaker to present a story do let me know.  Note: We are also looking to do in-person session at the Microsoft Technology Center (MTC) in Burlington,MA in the future so stay tuned...


**Part 1: Upcoming sessions:**

Note: **Invites will go out two weeks before the session**

| Sesssion Name                                         | Date  /Previous Recordings                      | Guest Speaker(s)  | Notes
|-------------------------------------------------------|------------------------------|------------------------------------------------|---------------------|
| [Session-1: Azure Hub-Spoke Design](#azure-hub-spoke-design)     | Thu, Feb 23rd 2023 12-1pm ET [Session-1 Recording](https://teams.microsoft.com/l/meetup-join/19%3ameeting_ZTI3MzMxNjAtZTg1Zi00NzhmLTg5ZTAtODExMjI5NmIyNjhi%40thread.v2/0?context=%7B%22Tid%22%3A%2272f988bf-86f1-41af-91ab-2d7cd011db47%22%2C%22Oid%22%3A%22a1a1b5e6-a149-4bcb-ba81-9fbea3a44230%22%2C%22IsBroadcastMeeting%22%3Atrue%2C%22role%22%3A%22a%22%7D&btype=a&role=a)| Tommy Falgout (Sr. Cloud Solution Architect), Jose Moreno (Principal Customer Engineer), Heather Sze (Global Black Belt, Networking)   |  [Agenda and FAQ](Agenda/session1.md) [Feedback form](https://forms.office.com/r/mZ418DCScx) |
| [Session-2:  vWAN - Azure Virtual WAN](#vwan-azure-virtual-wan)  | Thu, Mar 2nd 2023 12-1pm ET [Session-2 Recording](https://teams.microsoft.com/l/meetup-join/19%3ameeting_ZTJlNmJlNzYtZDU1NC00OGU1LTllODEtYjE4NjhmZGY5MTAz%40thread.v2/0?context=%7B%22Tid%22%3A%2272f988bf-86f1-41af-91ab-2d7cd011db47%22%2C%22Oid%22%3A%22a1a1b5e6-a149-4bcb-ba81-9fbea3a44230%22%2C%22IsBroadcastMeeting%22%3Atrue%2C%22role%22%3A%22a%22%7D&btype=a&role=a) | Mays Algebary (Global Black Belt, Networking), John Guo (Cloud Solution Architect, Check Point) |  [Agenda and FAQ](Agenda/session2.md) [Feedback Form](https://forms.microsoft.com/r/htdTjn6QT1) |
| [Session-3:  Load balancing in Azure](#load-balancing-in-azure)   | Thu, Mar 9th 2023 12-1pm ET [Session-3 Recording](https://teams.microsoft.com/l/meetup-join/19%3ameeting_M2U0ZDMzMjUtMjdmMS00MzViLTk4ZjMtYjU2Y2ExZDgzZDE4%40thread.v2/0?context=%7B%22Tid%22%3A%2272f988bf-86f1-41af-91ab-2d7cd011db47%22%2C%22Oid%22%3A%22a1a1b5e6-a149-4bcb-ba81-9fbea3a44230%22%2C%22IsBroadcastMeeting%22%3Atrue%2C%22role%22%3A%22a%22%7D&btype=a&role=a)  | Marc De Droog (Global Black Belt, Networking), John Guo(Cloud Solution Architect, Check Point) |  [Agenda and FAQ](Agenda/session3.md) [Feedback Form](https://forms.microsoft.com/r/HNhm2a7ghu)|
| [Session-4: DNS Options in Azure](#dns-in-azure)                 | Thu, Mar 16th 2023 12-1pm ET [Session-4 Recording](https://teams.microsoft.com/l/meetup-join/19%3ameeting_ZjdiNzA1YzItMjY3Mi00NmNkLTg2OWMtZDVmZmNlNWYwMDgz%40thread.v2/0?context=%7B%22Tid%22%3A%2272f988bf-86f1-41af-91ab-2d7cd011db47%22%2C%22Oid%22%3A%22a1a1b5e6-a149-4bcb-ba81-9fbea3a44230%22%2C%22IsBroadcastMeeting%22%3Atrue%2C%22role%22%3A%22a%22%7D&btype=a&role=a) | Daniel Mauser (Global Black Belt, Networking)  |  [Agenda and FAQ](Agenda/session4.md) [Feedback Form](https://forms.microsoft.com/r/9HSZnXTPSQ) |
| [Session-5: NVA high availabilty options](#nva-high-availability)| Thu, Mar 23rd 2023 12-1pm ET | Jose Moreno (Principal Customer Engineer)      |  [Agenda and FAQ](Agenda/session5.md) [Feedback Form](https://forms.microsoft.com/r/cJ55nC20KM)|
| [Session-6: Private Endpoints](#private-endpoints)               | Thu, Mar 30th,2023 12-1pm ET | Shruthi Vijaya Nair (Global Black Belt, Networking)|  [Agenda and FAQ](Agenda/session6.md) |




# Design Areas (Core Networking Part 1)
## Azure Hub-Spoke Design

Download [draw.io diagram](diagrams/hub-spoke.drawio). More information on how to open .drawio files [here](#installation).

![Hub-spoke-design](design-gifs/hub-spoke-design.GIF)

In this session we walk through the Hub-spoke architecure design. This design includes the following layers.

- Hybrid Connectivity Architecture with hub-spoke design
- Site-to-site, Point-to-Site and ExR connected Branches
- Default traffic Flows
- Variation of the default design based on requirements
- Use case for AzFw  
- Use case for ARS (Azure Route server)
- Use case for NVA (Pros and Cons)
- VPN Gateway Active Active design challange
- Multi-region design
- Configuration snippets
- Concepts
- Limitations

## vWAN (Azure Virtual WAN)

Download [draw.io diagram](diagrams/vwan.drawio). More information on how to open .drawio files [here](#installation).

![azure-vwan](design-gifs/vwan-design.GIF)

In this session we walk through the vWAN architectures. This design includes the following layers:
 - Hybrid Connectivity Architecture
 - Single region default flows with Azure vWAN
 - Multi region default flows with Azure vWAN
 - Secured vWAN
 - BGP Endpoint feature use case
 - Use case for routing intent
 - Use case for NVA in indirect spokes
 - Use case for Custom Routing
 - Multiregion with ExR Boe-tie design


## Load balancing in Azure

Download [draw.io diagram](diagrams/load-balancing.drawio). More information on how to open .drawio files [here](#installation).

![lb-design](design-gifs/lb-design.GIF)
In this session we walk through the load balancing architectures. This design includes the following layers
 - Azure load balancer (layer 4)
 - Azure application Gateway (layer 7)
 - Cross Region Load Balancer
 - Azure Traffic Manager (Global)
 - Azure Front door (AFD)
 - Azure Gateway Load Balancer
 - Multi-region design
 - Use case for Private endpoint with AFD

## DNS in Azure

Download [draw.io diagram](diagrams/dns-in-azure.drawio). More information on how to open .drawio files [here](#installation).

![DNS Design](design-gifs/dns-design.GIF)

In this session we walk through the DNS options in Azure.his design includes the following layers

- DNS Options in Azure
- Default DNS configuration 
- Custom DNS
- Hybrid DNS
- Private DNS Zones
- Azure Private DNS Resolver

## NVA High availability


Download [draw.io diagram](diagrams/NVA-ha.drawio). More information on how to open .drawio files [here](#installation).

![nva-ha-design](design-gifs/nva-ha-design.GIF)

This design includes the following layers:
- NVA LB Sandwich design
- Challenge: Preserving flow symettry
- North South flows
- East West Flows
- Packet Captures
- Use case Floating IP
- Use case for HA Ports
- Configuration Snippets

## Private Endpoints

Download [draw.io diagram](diagrams/private-EP.drawio). More information on how to open .drawio files [here](#installation).

![private-ep-design](design-gifs/private-ep-design.GIF)

This design includes the following layers:
- Consumer provider model
- Use case with AFD
- Use case with AKS

# Upcoming designs (Work In Progress...)

# Design Areas (Cross Functional - Part 2)


## Networking in Azure Kubernetes Service (AKS)
![aks-design](design-gifs/aks-design.gif)

This design includes the following layers

- Azure CNI
- Azure Kubenet
- Azure CNI Overlay
- IPv6 in AKS
- Azure Data platform integration (Example: SQL MI integration, SQL DB, Cosmos DB, OSS DB (mysql, postgreSQL), blob storage)
- Multi-region with Relational DB(SQLMI, SQL DB, OSS DB) (Single Master) (Shopping cart)
- Multi-region with Non-relational or NoSQL (Cosmos DB, MongoDB) (Multi Master) (catalog db)


## Networking with Azure Data Factory
This design includes the following layers
- Azure ADF  (Data movement and orchestration)
- Azure Synapse
- Azure Datalake or blob storage
- SQL MI (source and destination)
- Third Party Cloud (GCP)
- Hybrid SQL Server On-premise
- Cosmos DB, SQL DB (source and destination)
- OSS Databases (postgreSQL, mysql, mariadb)



## Azure API Management (APIM)
## Azure App Service Networking

# Design Areas (Part 3 - Upcoming)

## Azure VMWare Solutions - Network design
- AVS with NVA in Azure VNET (with ARS)
- Multi-region design with NVA in Azure NVET (with ARS)
- AVS with NVA behind NSX
- Azure Site Recovery (From AVS to Azure)
- HCX Scenarios
## Azure Virtual Desktop - Network design
## IPv6 in Azure
## AzFW deep dive
## ExpressRoute designs




# Tooling - Draw.io (now diagrams.net)
## Features

Draw.io is [feature rich](https://www.diagrams.net/blog). I've listed my top 10 favorite features that are useful for drawing network architecture diagrams


1. [Add Shapes](https://www.diagrams.net/blog/azure-diagrams): View -> Shapes -> Add Shapes -> Azure. 
2. [Add Layers](https://www.diagrams.net/blog/interactive-diagram-layers): View -> Layers. Create layers and show hide layers.
3. [Add Scratchpad](https://www.diagrams.net/blog/azure-diagrams): View -> Scratchpad
4. View Outline: View -> Outline
5. Flow animation: Select Flow -> Flow animation
6. [Sketch Style](https://www.diagrams.net/blog/rough-style) (hand drawn style)
7. [Whiteboard](https://www.diagrams.net/blog/change-editor-mode):  Extras-> Theme-> Sketch
8. [Curved lines](https://drawio-app.com/curved-connectors-in-draw-io-diagrams/) for flows
9. [vscode integration](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)
10. [Group shapes](https://drawio-app.com/more-draw-io-shortcuts-to-streamline-your-diagramming/) using CTRL-G

## Installation

There are three options to open the draw.io diagrams.

1. Use the desktop app
    Download the desktop app from the microsoft store. 
    ![desktop-app](extras/drawio-app.png)

    Dowload drawio file from github and open in the desktop app. File -> Raw -> Save link as.
    ![save-drawio](extras/save-drawio.png)
    
2. Use the web browser to open the file online using the link [here](https://app.diagrams.net/)

3. Integrate with vscode using the ![vscode extension](extras/vscode-extension.png)


## Acknowledgement

Special thank you to my colleagues


- [David O'Keefe](https://www.linkedin.com/in/david-o-keefe/)
- [Shaun Croucher](https://github.com/shcrouch)
- [Xavier Elizondo](https://github.com/xelizondo)
- [Heather Tze](https://github.com/hsze)
- [Mays Algebary](https://github.com/malgebary)
- [Daniel Mauser](https://github.com/dmauser)
- [Jose Moreno](https://github.com/erjosito)
- [Sowmyan Soman Chullikkattil](https://github.com/sowsan)
- [Mike Richter](https://github.com/michaelsrichter)
- [Mike Shelton](https://www.linkedin.com/in/mshelt)
- [Tommy Falgout](https://github.com/lastcoolnameleft)

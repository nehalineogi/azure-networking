# About this repo: The art of the possible and the *why* behind the various design options

The purpose of this repo is to deliver **layered, reusable and github friendly** network architecture diagrams for Cloud Solutions Architects to run effective Azure design and skilling sessions. The repository will include tips and tools for effective story telling that explain the **why behind the design options based on requirements** and the art of the possible.  The design areas include - Azure Networking, Hybrid connectivity architectures, routing, firewalling, load balancing, multi-region, secure design, cross functional networking areas and AKS networking. The content is based on **real customer and partner design sessions** with collaboration from cross-functional architects.  The networking complexity is broken down into **layers** with **one diagram** per design area using [draw.io](https://app.diagrams.net/) now [diagrams.net](https://www.diagrams.net/). This repo will include configuration snippets to reduce the lab prep time and the need to leave the labs running for demos.


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


We have limited spots available so if you are interested to join live sesssion please fillout [a form](https://forms.office.com/r/MM5MgmN1iA) with your role, email ID and session of interest. We will serve the request on the first come first serve basis. This will be a virtual teams meeting. Join us to learn, **connect with your peers in the industry** and share your use cases and design variations.  If you are a partner and would like to be a guest speaker to present a 5 min story do let me know.  Note: We are also looking to do in-person session at the Microsoft Technology Center (MTC) in Burlington,MA in the future so stay tuned...


**Part 1: Upcoming sessions:**

Note: **Invites will go out the week of Feb 13th**

| Sesssion Name                                         | Date                        | Guest Speaker(s) | Presenter(s) | Agenda
|-------------------------------------------------------|------------------------------|------------------------------------------------|---------------------|---------------------|
| [Azure Hub-Spoke Design](#azure-hub-spoke-design)     | Thu, Feb 23rd 2023 12-1pm ET | Tommy Falgout (Sr. Cloud Solution Architect), Jose Moreno (Principal Customer Engineer), Heather Sze (Global Black Belt, Networking)   | David O'Keefe(Partner Technology Strategist),Nehali Neogi (Cloud Solution Architect)| TBD |
| [ vWAN - Azure Virtual WAN](#vwan-azure-virtual-wan)  | Thu, Mar 2nd 2023 12-1pm ET  | Mays Algebary (Global Black Belt, Networking), Shruthi Vijaya Nair (Global Black Belt, Networking)  | Nehali Neogi | TBD |
| [Load balancing in Azure](#load-balancing-in-azure)   | Thu, Mar 9th 2023 12-1pm ET  | Marc De Droog (Global Black Belt, Networking)                                       | Nehali Neogi | TBD |
| [DNS Options in Azure](#dns-in-azure)                 | Thu, Mar 16th 2023 12-1pm ET | Daniel Mauser (Global Black Belt, Networking)  | Nehali Neogi | TBD |
| [NVA high availabilty options](#nva-high-availability)| Thu, Mar 23rd 2023 12-1pm ET | Jose Moreno (Principal Customer Engineer)      | Nehali Neogi | TBD |
| [Private Endpoints](#private-endpoints)               | Thu, Mar 30th,2023 12-1pm ET | Shruthi Vijaya Nair (Global Black Belt, Networking)                                            | Nehali Neogi | TBD |




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
 - Secured vWAN
 - Use case for routing intent
 - Use case for NVA in indirect spokes
 - Use case for Custom Routing
 - Multiregin design
 - Configuratin snippets
 - Concepts
 - Limitations


## Load balancing in Azure

Download [draw.io diagram](diagrams/load-balancing.drawio). More information on how to open .drawio files [here](#installation).

![lb-design](design-gifs/lb-design.GIF)
In this session we walk through the load balancing architectures. This design includes the following layers
 - Azure load balancer (layer 4)
 - Azure applicatin Gateway (layer 7)
 - Azure Traffic Manager
 - Azure Front door (AFD)
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
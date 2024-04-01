# Azure Networking: The Art of The Possible and the *why*

The purpose of this repo is to deliver **layered, reusable and github friendly** network architecture diagrams for Cloud Solutions Architects to run effective Azure design and skilling sessions. The content is based on **real customer and partner design sessions** with collaboration from cross-functional architects. The repository will include tips and tools for effective story telling that explain the **why behind the design options based on requirements** and the art of the possible.  The design areas include - Azure Networking, Hybrid connectivity architectures, routing, firewalling, load balancing, multi-region, secure design, cross functional networking areas and AKS networking.   The networking complexity is broken down into **layers** with **one diagram** per design area using [draw.io](https://app.diagrams.net/) now [diagrams.net](https://www.diagrams.net/). This repo will include configuration snippets to reduce the lab prep time and the need to leave the labs running for demos.

# Youtube Channel (The Art of the Possible Series)
### [Drawio basics and layered network diagrams playlist](https://www.youtube.com/channel/UC5x8jb_AMMAqMuFcMfX8RcA)


# Scope: Reusable and Layered Network Diagrams

### Target Audience:  
Cloud Solution Architects, Network Architects, Cloud Infrastructure Architects, Solution Engineers

### Scope
- Build Reusable and github friendly network architecture diagram templates
- Layered diagrams to run effective Azure Design and skilling sessions 
- Real world use cases dervied from working with Microsoft customers
- Level 100 to level 400 scenarios in one diagram
- Understand the why behind the design decision
- Minimize lab time
- Growth mindset

# Part 1 (FY 2023 - Completed)

### Download all drawio diagrams [here](/diagrams)
### Recording links available

0. [How to create layered drawio diagrams](https://www.youtube.com/watch?v=-5tKnS03I5Y&t=998s)
2. [Azure Hub and Spoke Designs](https://nnstorage99.blob.core.windows.net/public-recordings/Session-1-Azure-Hub-spoke-architecture.mp4)
3. [Azure Virtual WAN (vWAN) designs](https://nnstorage99.blob.core.windows.net/public-recordings/session-2-Azure-vWAN-designs.mp4)
4. [Load Balancing in Azure](https://nnstorage99.blob.core.windows.net/public-recordings/session-3-load-balancing-in-azure.mp4)
5. [DNS Options in Azure](https://nnstorage99.blob.core.windows.net/public-recordings/Session-4-dns-options-in-azure.mp4)
6. [NVA High Availability in Azure](https://nnstorage99.blob.core.windows.net/public-recordings/session-5-nva-ha-in-azure.mp4)
7. [Private Endpoint and Private Link Service in Azure](https://nnstorage99.blob.core.windows.net/public-recordings/session-6-private-endpoint.mp4)

   
# Part 2 (FY 2024 - Upcoming live sessions)
### Download all drawio diagrams [here](/diagrams)
### Cross Functional Networking

1. [Azure AI Studio Networking](#Azure-AI-Studio-Network-design)- March 28th 2024  Completed - [Recording link](https://nnstorage99.blob.core.windows.net/public-recordings/Session-7-AzureAI-Studio-Enterprise-RAG-with-Managed-VNET.mp4)
2. [AVS Networking](#Azure-VMWare-Solutions-Network-design) (April 25th 2024)  [Webinar Registration Link](https://msit.events.teams.microsoft.com/event/fd652a29-af51-4adf-94de-497938bf7988@72f988bf-86f1-41af-91ab-2d7cd011db47)
3. [AKS Networking](#AKS-Networking)  (Webinar Registration link here- coming Soon)
4. ADF and SQL MI Networking
5. APIM Networking
6. Azure Container Apps, Web Apps Networking


# Part 3: (FY 2025 - Future topics)
### (Advanced Networking and Security) 
1. IPv6 in Azure
2. Azure Network Security (AzFW, DDoS)
3. ExpressRoute Designs
4. AVD (Azure Virtual Desktop)
5. Azure IoT Networking
6. SAP on Azure

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
- Service Endpoint
- Private Endpoint
- Private Link Service
- VNET Integration vs Private Endpoint
- Use case with Azure Front Door (AFD) with Private Endpoint
- Use case with AKS

# Design Areas (Cross Functional - Part 2)
## Azure AI Studio Network design
Download [draw.io diagram](diagrams/azure-ai.drawio). More information on how to open .drawio files [here](#installation).
![aistudio-design](design-gifs/aistudio-design.gif)
- AI Studio Prompt flow with Managed VNET and Private endpoints
- Short Demo with AI Studio Playground
- Azure AI Studio Architecture Components (PaaS and IaaS)
- Key Concepts (Private Endpoints, Webapp, Embedding and Vector Database, Managed EP, AI Models and Prompt flow)
- Traffic flows with managed VNET with Private Endpoints
- [FAQ and Feedback Links](Agenda/ai-studio-session.md)


## Azure VMware Solutions Network design
Download [draw.io diagram](diagrams/AVS.drawio). More information on how to open .drawio files [here](#installation).
![avs-design](design-gifs/avs-design.gif)
- On-Prem Connectivity Using Global Reach
- VPN ER Transit using ARS
- Network Virtual Appliance (NVA) in Azure VNET (with ARS)
- Transit VNET design with NVA in Azure NVET (with ARS)
- Deploy third party Virtual Apppliance using NSX-T segments within AVS
- Secured vWAN HUB Design with Routing Intent

## AKS Networking
Download [draw.io diagram](diagrams/aks.drawio). More information on how to open .drawio files [here](#installation).
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
- APIM Big Picture view
- Default mode
- External network mode
- Internal network mode
- Internal network mode with Azure Application Gateway
- Internal network mode with AKS Backend API
- APIM with Azure firewall/NVA
- APIM Identity - AAD and B2C Integration
- APIM Multi-region Architecture
- Self hosted gateway
- LetsEncrypt Certificates and APIM Custom Domain
- Azure Private DNS Zones integration
- Network Troubleshooting

## Azure Container Apps and App Service Networking

- Private Endpoint Integration
- Service Endpoint
- VNET Integration
- NAT Gateway Integration
- Azure Private DNS Zone Planning


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
- Shruthi Nair
- [Jose Moreno](https://github.com/erjosito)
- [Sowmyan Soman Chullikkattil](https://github.com/sowsan)
- [Mike Richter](https://github.com/michaelsrichter)
- [Mike Shelton](https://www.linkedin.com/in/mshelt)
- [Tommy Falgout](https://github.com/lastcoolnameleft)
- [Amanda Wong](https://github.com/wongamanda)
- Israel Ekpo

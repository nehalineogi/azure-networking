# About this repo: The why behind networking design and the art of the possible

The purpose of this repo is to deliver **reusable and github friendly** artifacts for Cloud Solutions Architects to run effective Azure design and skilling sessions. The repository will include tips and tools for effective story telling that explain the **why behind the design options based on requirements** and the art of the possible.  The design areas include - Azure Networking, Hybrid connectivity architectures, routing, firewalling, load balancing, multi-region, secure design, cross functional networking areas and AKS networking. The content is based on **real partner design sessions** with collaboration from cross-functional architects.  The networking complexity is broken down into **layers** with **one diagram** per design area using [draw.io](https://app.diagrams.net/) now [diagrams.net](https://www.diagrams.net/). This repo will include configuration snippets to reduce the lab prep time and the need to leave the labs running for demos.


# Scope: Reusable Artifacts for Cloud Architects

- Reusable whiteboard style architecture draw.io (diagrams.net) templates
- Layered diagrams to run effective Azure Design and skilling sessions 
- Real world use cases dervied from working with Partners and customers
- Level 100 to level 500 design in one diagram
- Github collaboration with Partners and cloud architects
- 30 second preview animation videos for each design area
- 45 minute sessions for each design area and Q&A
- Cross functional team collaboration for networking areas
- Documented flows and configuration snippets to reduce lab prep time

# Join us for live sessions


We have limited spots available so if you are interested to join live sesssion please fillout [a form](https://forms.office.com/r/MM5MgmN1iA) with your role, email ID and session of interest. We will serve the request on the first come first serve basis. This will be a virtual teams meeting. Join us to learn, **connect with your peers in the industry** and share your use cases and design variations.  If you are a partner and would like to be a guest speaker to present a 5 min story do let me know.  Note: We are also looking to do in-person session at the Microsoft Technology Center (MTC) in Burlington,MA in the future so stay tuned...


**Upcoming sessions:**

| Sesssion Name                                         | Date                        | Guest Speaker
|-------------------------------------------------------|-----------------------------|---------------------|
| [Azure Hub-Spoke Design](#azure-hub-spoke-design)     | Thu, Feb 23rd 2023 12-1pm ET|         TBA         |
| [ vWAN - Azure Virtual WAN](#vwan-azure-virtual-wan)  | Thu, Mar 2nd 2023 12-1pm ET |         TBA         |
| [Load balancing in Azure](#load-balancing-in-azure)   | Thu, Mar 9th 2023 12-1pm ET |         TBA         |
| [DNS Options in Azure](#dns-in-azure)                 | Thu, Mar 16th 2023 12-1pm ET|         TBA         |
| [NVA high availabilty options](#nva-high-availability)| Thu, Mar 23rd 2023 12-1pm ET|         TBA         |
| [Private Endpoints](#private-endpoints)               | Thu, Mar 30th,2023 12-1pm ET|         TBA         |




# Design Areas
## Azure Hub-Spoke Design

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

![lb-design](design-gifs/lb-design.GIF)
In this session we walk through the load balancing architectures. This design includes the following layers
 - Azure load balancer (layer 4)
 - Azure applicatin Gateway (layer 7)
 - Azure Traffic Manager
 - Azure Front door (AFD)
 - Multi-region design
 - Use case for Private endpoint with AFD

## DNS in Azure
![DNS Design](design-gifs/dns-design.GIF)

In this session we walk through the DNS options in Azure.his design includes the following layers

- DNS Options in Azure
- Default DNS configuration 
- Custom DNS
- Hybrid DNS
- Private DNS Zones
- Azure Private DNS Resolver

## NVA High availability
This design includes the following layers:
![nva-ha-design](design-gifs/nva-ha-design.GIF)
- NVA LB Sandwich design
- Challenge: Preserving flow symettry
- North South flows
- East West Flows
- Packet Captures
- Use case Floating IP
- Use case for HA Ports
- Configuration Snippets

## Private Endpoints
This design includes the following layers:
![private-ep-design](design-gifs/private-ep-design.GIF)
- Consumer provider model
- Use case with AFD
- Use case with AKS

# Acknowledgement
# Upcoming designs
## IPv6 in Azure
## AzFW deep dive
## ExpressRoute designs
## Azure VMWare Solutions - Network design
## Azure Virtual Desktop - Network design
## Networking in Azure Kubnernetes Services
## Azure API Management (APIM)
## Networking with Azure Data Factory and SQL MI


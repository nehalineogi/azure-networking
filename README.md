# About this repo: The **why** behind networking design

The purpose of this repo is to deliver **reusable and github friendly** artifacts for CSAs to run effective Azure design and partner skilling sessions that explains the **why behind the design options based on requirements**.  The design areas include - Azure Networking, Hybrid connectivity architectures, routing, firewalling, load balancing, multi-region,secure design and AKS Networking. The content is based on **real partner questions and design sessions** with collaboration from cross functional CSAs. **Provide effective story telling tips and tools  using draw.io (diagrams.net) layered approach**. Networking complexity broken down into layers and **one diagram** per design area. Include configuration snippets to reduce the lab prep time and the need to leave the labs running for demos.


# Scope: Reusable Artifacts for CSA

- Reusable whiteboard style architecture draw.io (diagrams.net) templates
- Layered diagrams to run effective Azure Design and skilling sessions 
- Real world use cases dervied from working with Partners and customers
- Level 100 to level 500 design in one diagram
- gihub collaboration with Partners and CSAs
- 30 second preview animation vedios for each design area
- 45 minute sessions for each design area
- Cross functional team collaboration for networking areas
- Documented flows and configuration snippets to reduce lab prep time

# Design Areas
## Azure Hub-Spoke Design

![Hub-spoke-design](design-gifs/hub-spoke-design.GIF)

- Hybrid Connectivity Architecture
- Site-to-site, Point-to-Site and ExR connected Branches
- Default traffic Flows
- Use case for AzFw  
- Use case for ARS (Azure Route server)
- Use case for NVA (Pros and Cons)
- VPN Gateway Active Active design challange
- Multi-region design
- Configuration snippets
- Concepts
- Limitations

## vWAN (Azure Virtual WAN)
![Hub-spoke-design](design-gifs/vwan-design.GIF)
 - Hybrid Connectivity Architecture
 - Single region default flows with Azure vWAN
 - Secured vWAN
 - Use case for routing intent
 - Use case for NVA
 - Use case for Custom Routing
 - Multiregin design
 - Configuratin snippets
 - Concepts
 - Limitations


## Load balancing in Azure
![lb-design](design-gifs/lb-design.GIF)
 - Azure load balancer (layer 4)
 - Azure applicatin Gateway (layer 7)
 - Azure Traffic Manager
 - Azure Front door (AFD)
 - Multi-region design
 - Use case for Private endpoint with AFD

## DNS in Azure
![DNS Design](design-gifs/dns-design.GIF)

- DNS Options in Azure
- Default DNS configuration 
- Custom DNS
- Hybrid DNS
- Private DNS Zones
- Azure Private DNS Resolver

## NVA High availability
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


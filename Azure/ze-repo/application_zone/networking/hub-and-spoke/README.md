# Azure Virtual Network Configuration with Hub and Spoke Architecture

This Terraform configuration sets up a Hub and Spoke network architecture in Azure, including the creation of Virtual Networks, Subnets, and Network Peering connections.

### Configuration Details

- **Hub and Spoke Resource Groups**

  Two Azure resource groups are created - one for the Hub and another for the Spokes. These resource groups serve as logical containers for organizing and managing Azure resources.

- **Hub Virtual Network and Subnets**
  
  The Hub Virtual Network is established, including its address space and subnets. The Hub Virtual Network is typically used as a central point for network services and connectivity.

- **Spoke Virtual Networks and Subnets**
  
  Multiple Spoke Virtual Networks are created, each with its own address space and subnets. Spoke Virtual Networks are often used to isolate workloads or services and can be connected to the Hub for centralized management and connectivity.

- **Virtual Network Peering Connections**
  
  Peering connections are established between the Hub Virtual Network and each of the Spoke Virtual Networks, as well as from Spoke to Hub. These peering connections enable secure and controlled communication between network segments, allowing for a hub-and-spoke network topology.

This configuration is intended to provide a structured and scalable network architecture in Azure, commonly used in scenarios where centralized control and secure communication between network segments are essential. It offers the flexibility to expand and add more Spoke Virtual Networks as needed, while maintaining a controlled and efficient network layout.

### Outputs
This configuration includes the following outputs about the resources:

- **`hub_vnet_info`**: Hub Virtual Network details.
- **`spoke_vnets_info`**: Information about Spoke Virtual Networks.
- **`hub_vnet_subnets_info`**: Details of Subnets in the Hub Virtual Network.
- **`spoke_vnet_subnets_info`**: Subnet information for Spoke Virtual Networks.

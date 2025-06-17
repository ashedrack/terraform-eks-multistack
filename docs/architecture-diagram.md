# Infrastructure Architecture Diagram

Below is a simple architecture diagram for the AWS infrastructure provisioned by this project. You can copy this Mermaid code into the [Mermaid Live Editor](https://mermaid.live/) or compatible Markdown viewers to visualize it.

```mermaid
flowchart TD
    subgraph VPC["VPC (10.0.0.0/16)"]
        IGW["Internet Gateway"]
        NAT["NAT Gateway"]
        EIP["Elastic IP"]
        RT_pub["Public Route Table"]
        RT_priv["Private Route Table"]

        subgraph Public_Subnets["Public Subnets"]
            PUB1["Subnet 10.0.1.0/24 (eu-west-2a)"]
            PUB2["Subnet 10.0.2.0/24 (eu-west-2b)"]
        end

        subgraph Private_Subnets["Private Subnets"]
            PRIV1["Subnet 10.0.101.0/24 (eu-west-2a)"]
            PRIV2["Subnet 10.0.102.0/24 (eu-west-2b)"]
        end

        EKS["EKS Cluster"]
        NODES["EKS Node Group (EC2)"]

        IGW-->|"0.0.0.0/0"|RT_pub
        RT_pub-->|"routes"|PUB1
        RT_pub-->|"routes"|PUB2
        PUB1-->|"for NAT"|NAT
        NAT-->|"private route"|RT_priv
        RT_priv-->|"routes"|PRIV1
        RT_priv-->|"routes"|PRIV2

        EIP-->|"attached to"|NAT
        EKS-->|"API/Control Plane"|NODES
        NODES-->|"Pods/Services"|PRIV1
        NODES-->|"Pods/Services"|PRIV2
    end

    subgraph IAM["IAM"]
        ROLE["EKS Node Group Role"]
        POLICY1["AmazonEKSWorkerNodePolicy"]
        POLICY2["AmazonEKS_CNI_Policy"]
        POLICY3["AmazonEC2ContainerRegistryReadOnly"]
        ROLE-->|"attached"|POLICY1
        ROLE-->|"attached"|POLICY2
        ROLE-->|"attached"|POLICY3
        NODES-->|"assume role"|ROLE
    end

    IGW-->|"Internet Access"|Internet
    NAT-->|"Outbound to Internet"|Internet
    Internet["Internet"]
```

---

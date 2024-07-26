# Help for AsciiArtify team

To help the AsciiArtify startup team prepare a comparative analysis of three tools for deploying Kubernetes clusters in a local environment - **minikube, kind, and k3d** - the following action plan is proposed:

## 1. Introduction

**Description of tools and their purpose**
* **minikube:** A local Kubernetes system that allows you to deploy a Kubernetes cluster on a single computer. A convenient option for development and testing.
* **kind:** A tool that allows you to create local Kubernetes clusters in Docker containers. It is used for testing.
* **k3d:** A tool for creating local Kubernetes clusters in Docker containers using the Rancher Kubernetes Engine (RKE). Fast and easy to use.

## 2. Features
**Main characteristics of each tool**

* **minikube:**
    * Supported OS: Windows, macOS, Linux
    * Architectures: x86-64, ARM
    * Automation: Possible via scripts and CI/CD
    * Additional features: Monitoring, integration with various hypervisors
* **kind:**
    * Supported OS: Windows, macOS, Linux
    * Architectures: x86-64, ARM
    * Automation: Easy integration with CI/CD
    * Additional features: Easy and fast startup
* **k3d:**
    * Supported OS: Windows, macOS, Linux
    * Architectures: x86-64, ARM
    * Automation: Easy integration with CI/CD
    * Additional features: Fast cluster creation, support for multi-cluster configurations

 ## 3. Advantages and disadvantages
**Description of the advantages and disadvantages of each tool**
* **minikube:**
    * **Advantages:** Ease of use, stability, good documentation
    * **Disadvantages:** Limited scalability, hypervisor dependency
* **kind:**
    * **Advantages:** Speed of deployment, integration with Docker, easy configuration
    * **Disadvantages:** Requires Docker installation, limited functionality compared to real-world clusters
* **k3d:**
    * **Advantages:** Speed of deployment, support for multi-cluster configurations, ease of use
    * **Disadvantages:** Requires Docker installation, possible scaling issues

## Demonstration

** A short demonstration of the recommended tool (k3d) **

Installing k3d:
```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```
Creating a cluster
``` bash
k3d cluster create mycluster
```
Check the status of the cluster
```bash
kubectl get nodes
```
Deployment of the Hello World application
```bash
kubectl create deployment hello-world --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment hello-world --type=NodePort --port=8080 --target-port=8080 --name=hello-world
```
Check the availability of the application
```bash
kubectl get services
```


## Docker licensing risks 

### Using Podman as an alternative to Docker 

Docker has certain licensing restrictions, especially in enterprise environments. To avoid these restrictions, you can use Podman, which is a free and open source alternative to Docker. 

**Installing Podman and configuring it for use with Kubernetes** 

#### 1. Installing Podman
```bash
    sudo apt-get update
    sudo apt-get -y install podman
```
#### 2. Setting up Podman as Kubernetes
```bash
    podman machine init
    odman machine start
    podman kube play myapp.yaml
```

## Conclusion
* **minikube:** Recommended for local development
* **kind:** Good choice for CI/CD
* **k3d:** The best option for PoC (recommended).


# AsciiArtify PoC

PoC for deploying a GitOps system on Kubernetes using ArgoCD.
For detailed instructions, see - [doc/POC.md](doc/POC.md)
# Concept

## Introduction
Description of the tools: minikube, kind, and k3d.

## Characteristics
| Tools      | Supported OS          | Architecture | Automation | Additional features                      |
|------------|-----------------------|--------------|------------|------------------------------------------|
| minikube   | Windows, macOS, Linux | x86-64, ARM  | Possible   | Monitoring, integration with hypervisors |
| kind       | Windows, macOS, Linux | x86-64, ARM  | Easy       | Quick startup                            |
| k3d        | Windows, macOS, Linux | x86-64, ARM  | Easy       | Quickly create clusters                  |

## Advantages and Disadvantages
### minikube
* **Advantages:** Ease of use, stability
* **Disadvantages:** Limited scalability

### kind
* **Advantages:** Speed of deployment, integration with Docker
* **Disadvantages:** Requires Docker installation

### k3d
* **Advantages:** Fast deployment, support for multi-cluster configurations
* **Disadvantages:** Requires Docker installation

## How to use?
### k3d
```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create mycluster
kubectl get nodes
kubectl create deployment hello-world --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment hello-world --type=LoadBalancer --port=8080
kubectl get services
```
## Demostration
**A short demonstration of the recommended tool (k3d)**
[![asciicast](https://asciinema.org/a/Fz3wzWDkzaSvE6mKduCUG8kc1.svg)](https://asciinema.org/a/Fz3wzWDkzaSvE6mKduCUG8kc1)

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
    podman machine start
    podman kube play myapp.yaml
```

## Conclusion
* **minikube:** Recommended for local development
* **kind:** Good choice for CI/CD
* **k3d:** The best option for PoC (recommended).


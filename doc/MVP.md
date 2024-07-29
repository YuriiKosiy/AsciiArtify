# Deploying MVP on ArgoCD for the AsciiArtify team

## Previous steps in deploying ArgoCD.

For detailed instructions, see. [/doc/POC.md](/doc/POC.md).

## Demonstration

A repository fork has been made from [https://github.com/den-vasyliev/go-demo-app/](https://github.com/den-vasyliev/go-demo-app/) into a new [https://github.com/YuriiKosiy/go-demo-app](https://github.com/YuriiKosiy/go-demo-app) to demonstrate how ArgoCD works.

### Create New APP

1. Click the New APP button
2. Application Name: demo
3. Project Name: default
4. SYNC POLICY: Automatic
5. Repository URL: https://github.com/YuriiKosiy/go-demo-app
6. Path: helm
7. Cluster URL: https://kubernetes.default.svc
8. Namespace: demo
9. Check the box AUTO-CREATE NAMESPACE and click on Create
**after that we need to synchronize**
To do this, go to our newly created app and the SYNC button and then the Synchronize button.

![Image](/.data/argo-cd.gif)

<a href="https://youtu.be/p13DM2t6wp4" target="_blank">1. Demo Video YouTube</a>

### Make changes in the go-demo-app repository and commit them.

![Image](/.data/pp.gif)

<a href="https://youtu.be/LxJ66SzxAMc" target="_blank">2. Demo Video YouTube</a>

### A few minutes later, our ArgoCD sees the changes in the repository and synchronizes them. You can see it in the screenshot below.

![Image](/.data/demo-Argo-CD.png)

# AsciiArtify Concept

Characteristics of the each tool on the [Concept.md](Concept.md)

# AsciiArtify PoC

PoC for deploying a GitOps system on Kubernetes using ArgoCD.
For detailed instructions, see - [POC.md](POC.md)

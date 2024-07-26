# Proof of Concept for ArgoCD on Kubernetes

## Introduction

This is a PoC for deploying a GitOps system on Kubernetes using ArgoCD for AsciiArtify team

## Deployment steps 

### Preparation

1. Install 'k3d' (if you haven't done it earlier):
Check version k3d:
```bash
k3d --version
```
Install, if necessary:
```bash
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
```
2. Install 'kubectl' (if you haven't done it earlier):
Check version k3d:
```bash
kubectl version
```
Install, if necessary:
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/
```
### Deploying a Kubernetes cluster and install ArgoCD

1. Create cluster:
```bash
k3d cluster create argocd-poc
```
2. Create namespace:
```bash
kubectl create namespace argocd
```
3. Install ArgoCD:
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
4. Check pods if running:
```bash
kubectl get pods -n argocd
```
NAME                                               READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                    1/1     Running   0          126m
argocd-applicationset-controller-65bb5ff89-b22k6   1/1     Running   0          126m
argocd-dex-server-69b469f8fb-fff58                 1/1     Running   0          126m
argocd-notifications-controller-64bc7c9f7-vwbx6    1/1     Running   0          126m
argocd-redis-867d4785f-m4r5g                       1/1     Running   0          126m
argocd-repo-server-5744559fff-qt7mp                1/1     Running   0          126m
argocd-server-697df9f478-5vgwm                     1/1     Running   0          126m

**STATUS** must be **Running**

5. If all **Running**, open the port:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
6. Open in your browser link https://127.0.0.1:8080/ and skip certificate verification.
You should see this page:

![Image](.data/Argo-CD.png)

Username: admin
Password: <next steps>

7. Give me password:
```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d; echo
```
Copy password to your browser on **password** field.

## Conclusion

ArgoCD is successfully installed and ready to use.



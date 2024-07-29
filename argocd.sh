#!/bin/bash

# Ім'я кластера та namespace
CLUSTER_NAME="argocd"

# Функція для зупинки і видалення всіх кластерів
stop_and_delete_clusters() {
  echo "Stopping and deleting all k3d clusters..."
  CLUSTERS=$(k3d cluster list -o json | jq -r '.[].name')
  for CLUSTER in $CLUSTERS; do
    echo "Stopping and deleting cluster $CLUSTER..."
    k3d cluster stop $CLUSTER
    k3d cluster delete $CLUSTER
  done
  echo "All clusters stopped and deleted."
}

# Функція для видалення namespace
delete_namespace() {
  local NAMESPACE=$1
  if kubectl get namespace $NAMESPACE > /dev/null 2>&1; then
    echo "Deleting namespace $NAMESPACE..."
    kubectl delete namespace $NAMESPACE
    # Чекаємо, поки namespace буде повністю видалено
    while kubectl get namespace $NAMESPACE > /dev/null 2>&1; do
      echo "Waiting for namespace $NAMESPACE to be deleted..."
      sleep 2
    done
  else
    echo "Namespace $NAMESPACE does not exist."
  fi
}

# Очистка Docker
clean_docker() {
  echo "Cleaning up Docker..."
  docker system prune -a -f --volumes
  echo "Docker cleanup completed."
}

# Підтвердження зупинки всіх кластерів і очищення Docker
read -p "Are you sure you want to stop and delete all k3d clusters and clean Docker? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
  echo "Operation cancelled."
  exit 1
fi

# Зупинка і видалення всіх кластерів
stop_and_delete_clusters

# Очистка Docker
clean_docker

# Запуск кластера
echo "Starting k3d cluster '$CLUSTER_NAME'..."
k3d cluster create $CLUSTER_NAME

# Переконання, що кластер запущений
if [ $? -ne 0 ]; then
  echo "Failed to start the cluster '$CLUSTER_NAME'."
  exit 1
fi

# Встановлення контексту для k3d кластеру
export KUBECONFIG=$(k3d kubeconfig write $CLUSTER_NAME)

# Перевірка стану вузлів
echo "Checking node status..."
kubectl get nodes
kubectl describe nodes

# Видалення namespace якщо існує
delete_namespace $CLUSTER_NAME

# Створення namespace
echo "Creating namespace '$CLUSTER_NAME'..."
kubectl create namespace $CLUSTER_NAME

# Видалення старого секрету якщо існує
echo "Deleting old secret 'argocd-redis' if it exists..."
kubectl delete secret argocd-redis -n $CLUSTER_NAME

# Видалення старих інсталяцій Redis якщо існують
echo "Deleting old Redis installation if it exists..."
kubectl delete deployment argocd-redis -n $CLUSTER_NAME
kubectl delete statefulset argocd-redis -n $CLUSTER_NAME
kubectl delete svc argocd-redis -n $CLUSTER_NAME

# Встановлення ArgoCD
echo "Installing ArgoCD..."
kubectl apply -n $CLUSTER_NAME -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Перевірка стану подів ArgoCD з очікуванням
echo "Waiting for ArgoCD pods to be ready..."
while true; do
  PODS_STATUS=$(kubectl get pods -n $CLUSTER_NAME -o jsonpath='{.items[*].status.phase}')
  echo $PODS_STATUS | grep -q "Pending"
  if [ $? -ne 0 ]; then
    echo "All ArgoCD pods are running."
    break
  else
    echo "Some pods are still pending. Checking for issues..."
    kubectl get pods -n $CLUSTER_NAME
    sleep 10
  fi
done

# Якщо поди залишаються в стані "Pending", виконуємо діагностичні команди
PENDING_PODS=$(kubectl get pods -n $CLUSTER_NAME --field-selector=status.phase=Pending -o jsonpath='{.items[*].metadata.name}')
if [ -n "$PENDING_PODS" ]; then
  echo "Pods are still pending. Running diagnostics..."
  for POD in $PENDING_PODS; do
    echo "Describing pod $POD:"
    kubectl describe pod $POD -n $CLUSTER_NAME
    echo "Logs for pod $POD:"
    kubectl logs $POD -n $CLUSTER_NAME
  done
  exit 1
fi

# Додавання порт форвардінгу
echo "Adding port forwarding..."
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d; echo

# Повідомлення про завершення
echo "Script completed."

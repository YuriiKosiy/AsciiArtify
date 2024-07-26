#!/bin/bash

# Змінна для простору імен
NAMESPACE="argocd"

# Отримання списку подів у просторі імен
PODS=$(kubectl get pods -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}')

# Перевірка чи є поди в просторі імен
if [ -z "$PODS" ]; then
  echo "No pods found in namespace $NAMESPACE."
  exit 0
fi

# Вивід списку подів
echo "Pods in namespace $NAMESPACE:"
for POD in $PODS; do
  echo $POD
done

# Видалення подів
echo "Deleting pods..."
for POD in $PODS; do
  kubectl delete pod $POD -n $NAMESPACE
done

# Перевірка стану подів після видалення
echo "Checking pod status after deletion..."
kubectl get pods -n $NAMESPACE

# Повідомлення про завершення
echo "Script completed."

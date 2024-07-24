#!/bin/bash

# Minecraftのバージョンを指定
MINECRAFT_VERSION=${1:-"1.16.5"}

# Dockerイメージのビルド
docker build --build-arg MINECRAFT_VERSION=$MINECRAFT_VERSION -t minecraft-server:$MINECRAFT_VERSION .

# Kubernetesのデプロイメントファイルを更新
sed -i "s|image: minecraft-server:.*|image: minecraft-server:$MINECRAFT_VERSION|g" minecraft-deployment.yaml

# Kubernetesにデプロイ
kubectl apply -f minecraft-pvc.yaml
kubectl apply -f minecraft-deployment.yaml
kubectl apply -f minecraft-service.yaml

echo "Minecraft server version $MINECRAFT_VERSION has been deployed to Kubernetes."

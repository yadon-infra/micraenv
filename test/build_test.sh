#!/bin/bash

# テスト用のMinecraftバージョン
TEST_VERSION="1.17.1"

# スクリプトの存在確認
if [ ! -f ./deploy_minecraft.sh ]; then
  echo "deploy_minecraft.sh script not found!"
  exit 1
fi

# デプロイメントファイルのバックアップ
cp minecraft-deployment.yaml minecraft-deployment.yaml.bak

# スクリプトの実行
./deploy_minecraft.sh $TEST_VERSION

# デプロイメントの確認
echo "Checking deployment status..."
DEPLOYMENT_STATUS=$(kubectl get deployment minecraft-server -o jsonpath='{.status.readyReplicas}')
if [ "$DEPLOYMENT_STATUS" -eq 1 ]; then
  echo "Deployment succeeded."
else
  echo "Deployment failed."
  kubectl logs deployment/minecraft-server
  # デプロイメントファイルの復元
  mv minecraft-deployment.yaml.bak minecraft-deployment.yaml
  exit 1
fi

# サービスの確認
echo "Checking service status..."
SERVICE_STATUS=$(kubectl get service minecraft-server -o jsonpath='{.spec.ports[0].nodePort}')
if [ -n "$SERVICE_STATUS" ]; then
  echo "Service is running on port $SERVICE_STATUS."
else
  echo "Service creation failed."
  # デプロイメントファイルの復元
  mv minecraft-deployment.yaml.bak minecraft-deployment.yaml
  exit 1
fi

# デプロイメントファイルの復元
mv minecraft-deployment.yaml.bak minecraft-deployment.yaml

echo "Test completed successfully."

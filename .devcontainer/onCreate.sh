#!/bin/bash
set -e

echo "🚀 Starting onCreate setup..."

# 配置 pnpm store 目录
echo "📦 Configuring pnpm..."
# Use /tmp for store to avoid permission issues in different environments
mkdir -p /tmp/pnpm-store
pnpm config set store-dir /tmp/pnpm-store
export PNPM_HOME=/tmp/.pnpm

# 设置 copilot 配置
echo "🤖 Setting up Copilot MCP..."
mkdir -p ~/.copilot
cp /workspaces/sc-shop-dev-workspace/.devcontainer/mcp-config.json ~/.copilot/

# 克隆仓库（如果不存在）
echo "📥 Cloning repositories..."
cd /workspaces/sc-shop-dev-workspace

if [ ! -d "sc-shop-frontend" ]; then
  git clone https://github.com/tokisaki-galaxy/sc-shop-frontend
  echo "✅ Frontend repository cloned"
else
  echo "⏭️  Frontend repository already exists"
fi

if [ ! -d "sc-shop-backend" ]; then
  git clone https://github.com/tokisaki-galaxy/sc-shop-backend
  echo "✅ Backend repository cloned"
else
  echo "⏭️  Backend repository already exists"
fi

echo "✨ onCreate setup complete!"

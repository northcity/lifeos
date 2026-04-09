#!/bin/bash
# LifeOS 一键部署脚本
# 适用于 Alibaba Cloud Linux / CentOS / Ubuntu
# 服务器: 2vCPU / 1GiB
# 使用方式: bash deploy.sh
# 注意: 运行前请先设置域名 DNS A记录指向本服务器 IP

set -e

# ──────────────────────────────────────────────
# 配置区 (按需修改)
# ──────────────────────────────────────────────
DOMAIN="earthguide.pro"
REPO="https://github.com/northcity/lifeos.git"
APP_DIR="/opt/lifeos"
SERVICE_USER="lifeos"

# ──────────────────────────────────────────────
# 1. 检测系统并安装基础依赖
# ──────────────────────────────────────────────
echo ">>> [1/8] 安装系统依赖..."

if command -v dnf &>/dev/null; then
    PKG="dnf"
elif command -v yum &>/dev/null; then
    PKG="yum"
else
    PKG="apt-get"
fi

if [ "$PKG" = "apt-get" ]; then
    apt-get update -q
    apt-get install -y git nginx certbot python3-certbot-nginx curl
else
    $PKG install -y git nginx certbot python3-certbot-nginx curl
fi

# ──────────────────────────────────────────────
# 2. 安装 Node.js 20
# ──────────────────────────────────────────────
echo ">>> [2/8] 安装 Node.js 20..."
if ! command -v node &>/dev/null || [[ "$(node -v)" < "v20" ]]; then
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - 2>/dev/null || \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 2>/dev/null
    $PKG install -y nodejs
fi
echo "Node.js: $(node -v)"

# ──────────────────────────────────────────────
# 3. 安装 Python 3.11
# ──────────────────────────────────────────────
echo ">>> [3/8] 安装 Python 3.11..."
if ! command -v python3.11 &>/dev/null; then
    if [ "$PKG" = "apt-get" ]; then
        add-apt-repository -y ppa:deadsnakes/ppa 2>/dev/null || true
        apt-get install -y python3.11 python3.11-venv python3.11-dev
    else
        $PKG install -y python3.11 python3.11-devel || \
        $PKG install -y python3 python3-devel
    fi
fi
PYTHON=$(command -v python3.11 || command -v python3)
echo "Python: $($PYTHON --version)"

# ──────────────────────────────────────────────
# 4. 创建用户和拉取代码
# ──────────────────────────────────────────────
echo ">>> [4/8] 拉取代码..."
id -u $SERVICE_USER &>/dev/null || useradd -r -s /bin/bash -m $SERVICE_USER

if [ -d "$APP_DIR" ]; then
    cd $APP_DIR && git pull
else
    git clone $REPO $APP_DIR
fi

chown -R $SERVICE_USER:$SERVICE_USER $APP_DIR

# ──────────────────────────────────────────────
# 5. 安装 Python 依赖 (轻量版，不含 camel-ai/PyTorch)
# ──────────────────────────────────────────────
echo ">>> [5/8] 安装 Python 依赖..."
cd $APP_DIR/backend

# 创建虚拟环境
sudo -u $SERVICE_USER $PYTHON -m venv .venv
sudo -u $SERVICE_USER .venv/bin/pip install --upgrade pip -q

# 安装核心依赖 (跳过 camel-ai/oasis 节省内存)
sudo -u $SERVICE_USER .venv/bin/pip install -q \
    flask>=3.0.0 \
    flask-cors>=6.0.0 \
    openai>=1.0.0 \
    "zep-cloud==3.13.0" \
    "PyMuPDF>=1.24.0" \
    "charset-normalizer>=3.0.0" \
    chardet>=5.0.0 \
    python-dotenv>=1.0.0 \
    "pydantic>=2.0.0" \
    gunicorn>=21.0.0 \
    httpx>=0.24.0

echo "Python 依赖安装完成 (已跳过 camel-ai/oasis 以节省内存)"

# ──────────────────────────────────────────────
# 6. 构建前端
# ──────────────────────────────────────────────
echo ">>> [6/8] 构建前端..."
cd $APP_DIR/frontend
sudo -u $SERVICE_USER npm ci --silent
sudo -u $SERVICE_USER npm run build
echo "前端构建完成: $APP_DIR/frontend/dist"

# ──────────────────────────────────────────────
# 7. 配置 nginx
# ──────────────────────────────────────────────
echo ">>> [7/8] 配置 nginx..."

cat > /etc/nginx/conf.d/lifeos.conf << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        proxy_pass         http://127.0.0.1:5001;
        proxy_http_version 1.1;
        proxy_set_header   Host \$host;
        proxy_set_header   X-Real-IP \$remote_addr;
        proxy_read_timeout 300s;
        client_max_body_size 50M;
    }
}
EOF

nginx -t && systemctl enable nginx && systemctl restart nginx

# ──────────────────────────────────────────────
# 8. 创建 systemd 服务
# ──────────────────────────────────────────────
echo ">>> [8/8] 创建系统服务..."

cat > /etc/systemd/system/lifeos.service << EOF
[Unit]
Description=LifeOS Backend
After=network.target

[Service]
Type=simple
User=$SERVICE_USER
WorkingDirectory=$APP_DIR/backend
EnvironmentFile=$APP_DIR/.env
ExecStart=$APP_DIR/backend/.venv/bin/gunicorn \
    --bind 0.0.0.0:5001 \
    --workers 1 \
    --threads 4 \
    --timeout 300 \
    --worker-class gthread \
    "app:create_app()"
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable lifeos

# ──────────────────────────────────────────────
# 提示配置 .env
# ──────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "✅ 部署完成！还需要两步："
echo ""
echo "1. 填写 API 密钥："
echo "   nano $APP_DIR/.env"
echo ""
echo "   内容："
echo "   LLM_API_KEY=sk-xxxxxxx"
echo "   LLM_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1"
echo "   LLM_MODEL_NAME=qwen-plus"
echo "   ZEP_API_KEY=z_xxxxxxx"
echo ""
echo "2. 申请 SSL 证书（需要域名 DNS 已指向本机 IP）："
echo "   certbot --nginx -d $DOMAIN -d www.$DOMAIN"
echo ""
echo "3. 启动服务："
echo "   systemctl start lifeos"
echo "   systemctl status lifeos"
echo ""
echo "访问地址: http://$DOMAIN (HTTPS 证书申请后自动升级)"
echo "════════════════════════════════════════"

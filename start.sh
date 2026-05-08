#!/bin/sh
set -e

echo "========== start.sh 已执行 =========="

: "${UUID:?UUID is required}"
: "${TROJAN_PASSWORD:?TROJAN_PASSWORD is required}"
: "${ARGO_TOKEN:?ARGO_TOKEN is required}"

# Tunnel 域名，Host / SNI 使用
: "${VLESS_DOMAIN:=vless.millerchen.qzz.io}"
: "${VMESS_DOMAIN:=vmess.millerchen.qzz.io}"
: "${TROJAN_DOMAIN:=trojan.millerchen.qzz.io}"

# 连接地址，可填写优选域名 / 优选 IP
: "${VLESS_ADDR:=$VLESS_DOMAIN}"
: "${VMESS_ADDR:=$VMESS_DOMAIN}"
: "${TROJAN_ADDR:=$TROJAN_DOMAIN}"

echo "========== 参数检查 =========="
echo "UUID exists"
echo "TROJAN_PASSWORD exists"
echo "ARGO_TOKEN length: ${#ARGO_TOKEN}"
echo "VLESS_DOMAIN: $VLESS_DOMAIN"
echo "VMESS_DOMAIN: $VMESS_DOMAIN"
echo "TROJAN_DOMAIN: $TROJAN_DOMAIN"
echo "VLESS_ADDR: $VLESS_ADDR"
echo "VMESS_ADDR: $VMESS_ADDR"
echo "TROJAN_ADDR: $TROJAN_ADDR"
echo "============================="

# 替换配置文件
sed -i "s/PASTE_UUID_HERE/$UUID/g" config.json
sed -i "s/PASTE_TROJAN_PASSWORD_HERE/$TROJAN_PASSWORD/g" config.json

echo "========== Final config.json =========="
cat config.json
echo "======================================="

echo "========== 节点链接 =========="

echo "VLESS:"
echo "vless://$UUID@$VLESS_ADDR:443?encryption=none&security=tls&sni=$VLESS_DOMAIN&insecure=0&allowInsecure=0&type=ws&host=$VLESS_DOMAIN&path=%2Fvless#Railway-VLESS"
echo

echo "Trojan:"
echo "trojan://$TROJAN_PASSWORD@$TROJAN_ADDR:443?security=tls&sni=$TROJAN_DOMAIN&insecure=0&allowInsecure=0&type=ws&host=$TROJAN_DOMAIN&path=%2Ftrojan#Railway-Trojan"
echo

echo "VMess 参数:"
echo "地址: $VMESS_ADDR"
echo "端口: 443"
echo "UUID: $UUID"
echo "Host: $VMESS_DOMAIN"
echo "SNI: $VMESS_DOMAIN"
echo "Path: /vmess"
echo "TLS: tls"
echo "Network: ws"

echo "=============================="

echo "Starting sing-box..."
sing-box run -c config.json &

sleep 3

echo "Starting cloudflared..."
cloudflared tunnel --no-autoupdate run --token "$ARGO_TOKEN"

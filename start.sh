#!/bin/sh
set -e

: "${UUID:?UUID is required}"
: "${TROJAN_PASSWORD:?TROJAN_PASSWORD is required}"
: "${ARGO_TOKEN:?ARGO_TOKEN is required}"

# 替换 UUID，VLESS 和 VMess 共用同一个 UUID
sed -i "s/PASTE_UUID_HERE/$UUID/g" config.json

# 替换 Trojan 密码
sed -i "s/PASTE_TROJAN_PASSWORD_HERE/$TROJAN_PASSWORD/g" config.json

# 后台运行 sing-box
sing-box run -c config.json &

# 前台运行 Cloudflare Tunnel

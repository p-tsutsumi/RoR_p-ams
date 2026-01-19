# RoR_p-ams

# ネットワーク作成
APP-IDP間の通信ネットワーク
```
docker network create auth-bridge
```
# IDP環境設定
自己証明書の作成
```
cd idp
openssl req -x509 -newkey rsa:4096 -keyout certs/server.key -out certs/server.crt -days 3650 -nodes -subj "/CN=reverse-proxy"
```
# コンテナ起動
## IDP環境
```
cd idp
cp -p .env_local .env
vi .env
docker-compose up -d
```
## APP環境
```
cd ..
cp -p .env_local .env
vi .env
docker-compose up -d
```

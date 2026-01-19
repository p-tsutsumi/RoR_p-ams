# RoR_p-ams

# IDP環境設定
自己証明書の作成
```
cd idp
openssl req -x509 -newkey rsa:4096 -keyout certs/server.key -out certs/server.crt -days 3650 -nodes -subj "/CN=localhost"
```
ネットワーク作成
```
docker network create auth-bridge
```
コンテナ起動
```
cd idp
docker-compose up -d
```

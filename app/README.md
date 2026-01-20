# RoR_p-ams


# 導入時の記録
## アプリケーションの作成
```
[root@101ddbf241b1 app]# rails new p-ams -G -d postgresql
[root@101ddbf241b1 app]# cd p-ams

```
## DBの設定ファイルを修正
```
[root@101ddbf241b1 p-ams]# vi config/database.yml
[root@101ddbf241b1 p-ams]# bin/rails db:create
```
## slimの導入
```
[root@101ddbf241b1 p-ams]# bundle exec erb2slim app/views/layouts/ --delete
```

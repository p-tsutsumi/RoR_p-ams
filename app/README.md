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
[root@101ddbf241b1 p-ams]# bundle install
[root@101ddbf241b1 p-ams]# bundle exec erb2slim app/views/layouts/ --delete
```
## bootstrapの導入
```
[root@101ddbf241b1 p-ams]# bundle install
[root@101ddbf241b1 p-ams]# bin/rails dartsass:install
[root@101ddbf241b1 p-ams]# mv app/assets/stylesheets/application.{css,scss} 
[root@101ddbf241b1 p-ams]# cat app/assets/stylesheets/application.scss 
@import "bootstrap";
```
## 日本語対応
```
[root@101ddbf241b1 p-ams]# curl -s https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml -o config/locales/ja.yml
[root@101ddbf241b1 p-ams]# app/p-ams/config/initializers/locale.rb
```

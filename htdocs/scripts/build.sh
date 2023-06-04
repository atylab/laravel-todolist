#!/bin/sh

# ドキュメントルートへ移動
cd /var/www/html

ENV='local'
NPM_ENV='dev'

cp -af ${ENV}.env .env

# composerを実行
composer install

php artisan migrate

# Webpack
npm install
npm run $NPM_ENV &

# キャッシュクリア
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear


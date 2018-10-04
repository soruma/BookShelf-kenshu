# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# 手順

## create application

```bash
# Copy docker-compose.yml
# docker-compose.ymlのvolumesの/appをアプリ名に変更
# Copy Dockerfile
# Dockerfileのmkdir, WORKDIRの行をそれぞれ、アプリ名に変更
docker-compose build
docker-compose run --rm web bundle init
# Gemfile が作成されるので #gem 'rails' のコメントを外す
docker-compose run --rm web bundle install
# ヘルプをみてどうすれば期待通りになるか
# docker-compose run --rm web rails -T # rails に用意されているコマンド
# docker-compose run --rm web rails new -h # newの仕方を検索
# docker-compose run --rm web rails new -h | grep database # dbに何が使えるか
# docker-compose run --rm web rails new -h | grep test # test作成をスキップする方法
# アプリ作成 databaseはpostgresql, テストとシステムテスト作成は行わない
docker-compose run --rm web bundle exec rails new -d postgresql -T --skip-system-test .
```

DB接続先修正(docker対応)

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

dev_server: &dev
  <<: *default
  username: postgres
  password:
  host: db
  port: 5432

development:
  <<: *dev
  database: book_shelf_development

test:
  <<: *dev
  database: book_shelf_test

production:
  <<: *default
  database: book_shelf_production
  username: book_shelf
  password: <%= ENV['BOOK_SHELF_DATABASE_PASSWORD'] %>
```

## install rspec

fix Gemfile

```ruby
group :development, :test do
  gem 'rspec-rails'
end
```

```bash
docker-compose run --rm web bundle install
# specフォルダが作成される
docker-compose run --rm web bundle exec rails g rspec:install
```

## install ruboco

fix Gemfile

```ruby
group :development do
  gem 'rubocop', require: false
end
```

```bash
docker-compose run --rm web bundle install
```

`.rubocop.yml` を編集

```bash
# チェック
docker-compose run --rm web bundle exec rubocop
# 自動で修正可能な箇所を修正
docker-compose run --rm web bundle exec rubocop -a
```

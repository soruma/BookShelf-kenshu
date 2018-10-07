# 手順

## create application

```bash
# Copy docker-compose.yml
# Copy Dockerfile
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

DB作成

```bash
docker-compose run --rm web bundle exec rails db:create
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

# アプリ開発

## モデル作成

### Person追加

  | 論理名 | 物理名 | タイプ | バリデーション | 備考 |
  |-|-|-|-|-|
  | 名前 | name | string | 必須 | |

### Book追加

  | 論理名 | 物理名 | タイプ |バリデーション| 備考 |
  |-|-|-|-|-|
  | タイトル | title | string | 必須 | |
  | 著者 | author_id | 必須 | integer | Personとの関係あり |

### BookShelf追加

  | 論理名 | 物理名 | タイプ |バリデーション| 備考 |
  |-|-|-|-|-|
  | 本 | book | references | 必須 | Bookとの関係 |
  | 場所 | point | string | 任意 | |

### Book修正

  | 論理名 | 物理名 | タイプ |バリデーション| 備考 |
  |-|-|-|-|-|
  | 廃盤 | out_of_print | boolean | 必須(true, false) | |

必須入力でbooleanヒント: https://qiita.com/mktakuya/items/a13c2175f0f0d9871038

### コンソールからデータを登録・修正

1. Person登録
1. Book登録(x2)
1. BookShelf登録
1. Book修正(廃盤)

## view と コントローラー

ボタンとテキストボックスはBootstrap
localeファイルを指定すること、modelのロケールファイルとviewのロケールファイルを個別で作成すること

### Book

#### index

tableで実装

表示項目

* Bookの一覧
  * 本のタイトル
  * 著者の選択(コンボボックス)
  * 廃盤(廃盤の場合、廃盤と表示、テーブルのヘッダーは空文字)
  * 詳細(show)リンク
  * 削除(destroy)リンク
* 追加(new)へのリンク

#### show

* tableで表示
  * タイトル
  * 著者
  * 廃盤(チェックボックス)
* 編集ページに遷移
* 一覧ページに遷移

#### new

* tableで一覧
  * タイトル
  * 著者(コンボボックス)
  * 廃盤(チェックボックス)
* 追加ボタン
* 戻るボタン

#### create

アクションを追加
保存が成功すれば、詳細ページに遷移する。
保存が失敗すると、追加ページに遷移する。

#### destroy

本を削除

### BookShelf

#### index

tableで実装

表示項目

* BookShelfの一覧
  * 本のタイトル
  * 場所
  * 詳細(show)リンク
 * 削除(destroy)リンク
* 追加(new)へのリンク

#### show

* tableで表示
  * id
  * 本のタイトル
  * 本の著者
  * 場所
* 編集ページに遷移
* 一覧ページに遷移

#### new

* tableで一覧
  * 本の選択(コンボボックス)
  * 場所
* 追加ボタン
* 戻るボタン

#### create

アクションを追加
保存が成功すれば、詳細ページに遷移する。
保存が失敗すると、追加ページに遷移する。

#### destory

本棚から本を削除

#### リファクタリング

* routingを1行で
* 著者を削除したら、本が消える

# Docker Todo App

Docker環境で構築されたフルスタックTODOアプリケーションです。Next.js (TypeScript) + Rails API + MySQLの構成で、完全にコンテナ化された開発環境を提供します。

## 📋 概要

このプロジェクトは、Docker Composeを使用したマイクロサービス構成のTODOアプリケーションです。開発からデプロイまでの一貫したワークフローを提供し、チーム開発に最適化されています。

## 🛠️ 技術スタック

### フロントエンド
- **Next.js 14** - React フレームワーク（App Router対応）
- **TypeScript** - 型安全な開発環境
- **CSS Modules** - コンポーネント単位のスタイリング
- **Axios** - HTTP クライアント（API通信）

### バックエンド
- **Ruby on Rails 7** - API専用モード
- **Rack-CORS** - Cross-Origin Resource Sharing対応
- **JWT** - 認証トークン（将来の拡張用）

### データベース
- **MySQL 8.0** - メインデータストア
- **初期化スクリプト** - 自動DB構築

### インフラストラクチャ
- **Docker 20.10+** - アプリケーションコンテナ化
- **Docker Compose** - マルチコンテナオーケストレーション
- **Alpine Linux** - 軽量ベースイメージ

## 🚀 機能

- ✅ TODOの作成・編集・削除
- 📝 詳細説明の追加
- ⏰ 期限設定
- 🎯 優先度設定（高・中・低）
- ✔️ 完了/未完了の切り替え
- 🔍 タスクの検索・フィルタリング
- 📱 レスポンシブデザイン

## 📁 プロジェクト構造

```
todo-app/
├── docker-compose.yml          # サービスオーケストレーション設定
├── .env.example                # 環境変数テンプレート（公開用）
├── .env                        # 実際の環境変数（Git除外）
├── .gitignore                  # バージョン管理除外設定
│
├── backend/                    # Rails API アプリケーション
│   ├── Dockerfile             # Rails用コンテナ設定
│   ├── Gemfile                # Ruby依存関係定義
│   ├── Gemfile.lock           # 依存関係固定版
│   ├── app/
│   │   ├── controllers/       # API エンドポイント
│   │   │   ├── application_controller.rb
│   │   │   └── todos_controller.rb
│   │   ├── models/           # データモデル
│   │   │   └── todo.rb
│   │   └── serializers/      # JSON出力フォーマット
│   ├── config/
│   │   ├── database.yml      # DB接続設定（環境変数対応）
│   │   ├── routes.rb         # ルーティング定義
│   │   └── cors.rb           # CORS設定
│   └── db/
│       ├── migrate/          # データベースマイグレーション
│       └── seeds.rb          # 初期データ投入
│
├── frontend/                   # Next.js フロントエンド
│   ├── Dockerfile             # Next.js用コンテナ設定
│   ├── package.json           # Node.js依存関係
│   ├── package-lock.json      # 依存関係固定版
│   ├── tsconfig.json          # TypeScript設定
│   ├── next.config.js         # Next.js設定
│   ├── pages/
│   │   └── index.tsx          # メインページ
│   ├── types/
│   │   └── todo.ts            # Todo型定義
│   ├── lib/
│   │   └── api.ts             # API通信関数
│   └── components/            # 再利用コンポーネント
│
└── mysql/                      # MySQL初期化
    └── init.sql               # データベース初期化スクリプト
```

## ⚡ クイックスタート

### 前提条件
- **Docker 20.10+** がインストール済み
- **Docker Compose V2** がインストール済み
- **Git** がインストール済み

### 1. プロジェクトのセットアップ
```bash
# リポジトリのクローン
git clone https://github.com/your-username/todo-app.git
cd todo-app

# 環境変数ファイルの作成
cp .env.example .env

# 必要に応じて .env を編集
# 例：ポート競合がある場合
# DB_PORT=13306
# BACKEND_PORT=13001
# FRONTEND_PORT=13000
```

### 2. プロジェクト構造の作成
```bash
# 必要なディレクトリを作成（クローン時に存在しない場合）
mkdir -p backend frontend mysql
```

### 3. Docker環境の起動
```bash
# 全サービスのビルドと起動（初回）
docker-compose up --build

# バックグラウンド実行する場合
docker-compose up -d --build

# 起動状況の確認
docker-compose ps
```

### 4. Rails APIのセットアップ
```bash
# Rails プロジェクトの作成（初回のみ）
docker-compose run --rm backend rails new . --api --database=mysql --skip-bundle --force

# データベースの作成とマイグレーション
docker-compose exec backend rails db:create
docker-compose exec backend rails db:migrate

# サンプルデータの投入（オプション）
docker-compose exec backend rails db:seed
```

### 5. Next.js フロントエンドのセットアップ
```bash
# Next.js プロジェクトの作成（初回のみ）
docker-compose exec frontend npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"

# 依存関係のインストール（必要に応じて）
docker-compose exec frontend npm install axios
```

### 6. アプリケーションへのアクセス
サービス起動後、以下のURLでアクセス可能：

- **フロントエンド**: http://localhost:3000
- **Rails API**: http://localhost:3001/api/todos
- **MySQL**: localhost:3306 (ユーザー: todo_user, パスワード: .envで設定)

## 🔧 開発環境操作

### Docker Compose基本操作
```bash
# === サービス管理 ===
# 全サービス起動
docker-compose up

# 特定サービスのみ起動
docker-compose up db backend

# サービス停止
docker-compose down

# サービス停止（ボリューム削除も実行）
docker-compose down -v

# === ビルド関連 ===
# キャッシュを使わずに再ビルド
docker-compose build --no-cache

# 特定サービスのみ再ビルド
docker-compose build backend

# === ログ確認 ===
# 全サービスのログ
docker-compose logs -f

# 特定サービスのログ
docker-compose logs -f backend

# 最新50行のログ
docker-compose logs --tail=50 frontend
```

### Rails開発操作
```bash
# === データベース操作 ===
# マイグレーション作成
docker-compose exec backend rails generate migration CreateTodos title:string completed:boolean

# マイグレーション実行
docker-compose exec backend rails db:migrate

# ロールバック
docker-compose exec backend rails db:rollback

# データベースリセット
docker-compose exec backend rails db:drop db:create db:migrate db:seed

# === Rails関連操作 ===
# モデル作成
docker-compose exec backend rails generate model Todo title:string description:text completed:boolean

# コントローラー作成
docker-compose exec backend rails generate controller Todos

# Railsコンソール
docker-compose exec backend rails console

# ルート確認
docker-compose exec backend rails routes
```

### Next.js開発操作
```bash
# === パッケージ管理 ===
# 新しいパッケージ追加
docker-compose exec frontend npm install axios @types/axios

# 開発用パッケージ追加
docker-compose exec frontend npm install -D @types/jest

# パッケージ削除
docker-compose exec frontend npm uninstall package-name

# === Next.js関連 ===
# ビルド作成
docker-compose exec frontend npm run build

# 本番モードで起動
docker-compose exec frontend npm start

# TypeScript型チェック
docker-compose exec frontend npm run type-check
```

### コンテナ内での直接作業
```bash
# バックエンドコンテナに入る
docker-compose exec backend bash

# フロントエンドコンテナに入る  
docker-compose exec frontend sh

# MySQLコンテナに接続
docker-compose exec db mysql -u todo_user -p todo_development
```

## 📡 API エンドポイント

### TODOs
| Method | Endpoint | 説明 |
|--------|----------|------|
| GET    | `/api/todos` | TODO一覧取得 |
| POST   | `/api/todos` | TODO作成 |
| GET    | `/api/todos/:id` | TODO詳細取得 |
| PUT    | `/api/todos/:id` | TODO更新 |
| DELETE | `/api/todos/:id` | TODO削除 |

### リクエスト/レスポンス例
```json
// POST /api/todos
{
  "title": "プロジェクトの企画書作成",
  "description": "新規プロジェクトの企画書を作成する",
  "due_date": "2024-12-31",
  "priority": "high",
  "completed": false
}
```

## 🔒 環境変数設定

### .env.example（GitHubに公開するテンプレート）
```bash
# === データベース設定 ===
DB_ROOT_PASSWORD=password
DB_USER=todo_user
DB_PASSWORD=todo_password
DB_NAME=todo_development
DB_PORT=3306

# === アプリケーション設定 ===
BACKEND_PORT=3001
FRONTEND_PORT=3000
RAILS_ENV=development

# === API設定 ===
API_URL=http://localhost:3001
NEXT_PUBLIC_API_URL=http://localhost:3001/api

# === CORS設定 ===
CORS_ORIGINS=http://localhost:3000

# === ログレベル ===
LOG_LEVEL=debug
```

### 本番環境用 .env設定例
```bash
# 本番環境では強力なパスワードを使用
DB_ROOT_PASSWORD=Pr0d!R00t!P@ssW0rd2024!
DB_PASSWORD=Pr0d!App!P@ssW0rd2024!

# 本番ドメイン
API_URL=https://api.yourdomain.com
NEXT_PUBLIC_API_URL=https://api.yourdomain.com/api
CORS_ORIGINS=https://yourdomain.com

# 本番設定
RAILS_ENV=production
LOG_LEVEL=info
```

### 環境別での起動方法
```bash
# 開発環境（デフォルト）
docker-compose up

# テスト環境
docker-compose --env-file .env.test up

# 本番環境
docker-compose --env-file .env.production up -d
```

## 🐛 トラブルシューティング

### よくある問題と解決方法

#### 1. ポート競合エラー
**症状**: `port is already allocated` エラー
```bash
# 使用中のポートを確認
lsof -i :3000  # フロントエンド
lsof -i :3001  # バックエンド  
lsof -i :3306  # MySQL

# 解決方法1: .envでポート変更
DB_PORT=13306
BACKEND_PORT=13001
FRONTEND_PORT=13000

# 解決方法2: 競合プロセスを停止
sudo kill -9 $(lsof -ti:3000)
```

#### 2. MySQL接続エラー
**症状**: `Can't connect to MySQL server`
```bash
# MySQLコンテナの状態確認
docker-compose ps db

# MySQLログ確認
docker-compose logs db

# データベース再作成
docker-compose exec backend rails db:drop db:create db:migrate

# コンテナ再起動
docker-compose restart db
```

#### 3. Rails Bundler エラー
**症状**: `Gem::LoadError` や bundle install失敗
```bash
# Bundlerキャッシュクリア
docker-compose exec backend bundle install --redownload

# Gemfile.lock削除して再生成
docker-compose exec backend rm Gemfile.lock
docker-compose exec backend bundle install

# コンテナ再ビルド
docker-compose build --no-cache backend
```

#### 4. Next.js ビルドエラー
**症状**: `Module not found` や TypeScript エラー
```bash
# node_modulesクリア
docker-compose exec frontend rm -rf node_modules package-lock.json
docker-compose exec frontend npm install

# Next.jsキャッシュクリア
docker-compose exec frontend npm run clean
docker-compose exec frontend rm -rf .next

# TypeScript型チェック
docker-compose exec frontend npm run type-check
```

#### 5. Docker関連の問題
**症状**: コンテナ起動失敗、イメージビルドエラー
```bash
# 全コンテナ・イメージ・ボリューム削除
docker-compose down -v --rmi all
docker system prune -a
docker volume prune

# 特定サービスの再ビルド
docker-compose build --no-cache [service-name]

# Docker Composeファイル構文チェック
docker-compose config
```

#### 6. 環境変数が読み込まれない
**症状**: 設定値が反映されない
```bash
# 環境変数が読み込まれているか確認
docker-compose config

# .envファイルの場所と内容確認
ls -la .env
cat .env

# 環境変数の優先順位確認
# 1. シェル環境変数
# 2. .envファイル  
# 3. docker-compose.ymlのdefault値
```

### パフォーマンス最適化

#### Docker Build高速化
```bash
# .dockerignoreファイル作成
echo "node_modules" >> frontend/.dockerignore
echo "tmp" >> backend/.dockerignore

# マルチステージビルド使用（本番用）
# BuildKitを有効にしてビルド
DOCKER_BUILDKIT=1 docker-compose build
```

#### 開発効率向上
```bash
# ファイル変更時の自動リロード確認
# Next.js: Fast Refreshが有効か確認
# Rails: spring gemsが正常に動作しているか確認

# ホットリロードが効かない場合
docker-compose restart frontend
docker-compose restart backend
```

## 🤝 開発への参加

### 開発ワークフロー

#### 1. 初回セットアップ
```bash
# リポジトリのフォーク
# GitHubでForkボタンをクリック

# フォークしたリポジトリをクローン
git clone https://github.com/YOUR_USERNAME/todo-app.git
cd todo-app

# 上流リポジトリを追加
git remote add upstream https://github.com/ORIGINAL_OWNER/todo-app.git

# 環境構築
cp .env.example .env
docker-compose up --build
```

#### 2. 機能開発の流れ
```bash
# 最新の main ブランチに同期
git checkout main
git pull upstream main

# 機能ブランチ作成
git checkout -b feature/add-todo-priority

# 開発作業
# ... コード編集 ...

# 変更をコミット
git add .
git commit -m "feat: Todo優先度機能を追加"

# プッシュ
git push origin feature/add-todo-priority

# GitHub でプルリクエスト作成
```

### ブランチ戦略
```
main          本番環境（安定版）
├── develop   開発統合ブランチ  
├── feature/* 機能開発ブランチ
├── bugfix/*  バグ修正ブランチ
└── hotfix/*  緊急修正ブランチ
```

### コミットメッセージ規則
```bash
# フォーマット: type: 説明

# 機能追加
feat: Todo削除機能を追加
feat(frontend): タスク編集UIを実装

# バグ修正  
fix: Todo更新時のバリデーションエラーを修正
fix(backend): API認証トークンの有効期限を修正

# ドキュメント
docs: README.mdのセットアップ手順を更新
docs(api): エンドポイント仕様書を追加

# スタイル修正
style: Prettierに従ってコードフォーマット

# リファクタリング
refactor: Todoコンポーネントを再利用可能に変更

# テスト
test: Todo作成のユニットテストを追加

# 設定変更
chore: Docker Composeファイルを最新化
ci: GitHub Actionsワークフローを追加
```

### コードレビューガイドライン

#### プルリクエスト作成時
- [ ] 動作確認を完了している
- [ ] テストが追加・更新されている  
- [ ] ドキュメントが更新されている
- [ ] コミットメッセージが規則に従っている
- [ ] 競合（conflict）がない

#### レビュー観点
- **機能性**: 要件を満たしているか
- **品質**: コードが読みやすく保守しやすいか
- **性能**: パフォーマンスに問題がないか
- **セキュリティ**: セキュリティ上の問題がないか
- **テスト**: 適切なテストが書かれているか

### 開発環境統一

#### エディタ設定（推奨）
```json
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "ruby.format": "rubocop",
  "files.associations": {
    "*.rb": "ruby"
  }
}
```

#### Lint設定
```bash
# フロントエンド: ESLint + Prettier
docker-compose exec frontend npm run lint
docker-compose exec frontend npm run format

# バックエンド: RuboCop
docker-compose exec backend bundle exec rubocop
docker-compose exec backend bundle exec rubocop -a  # 自動修正
```

## 📝 ライセンス

MIT License

## 👥 作者

- **開発者名** - [GitHub](https://github.com/your-username)

## 📞 サポート

質問や問題がある場合は、[Issues](https://github.com/your-username/todo-app/issues)で報告してください。

---

⭐ このプロジェクトが役立ったら、ぜひスターを付けてください！

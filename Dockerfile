# ベースイメージ
FROM node:18-alpine AS builder

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係をコピーしてインストール
COPY package.json package-lock.json ./
RUN npm install

# アプリのソースコードをコピー
COPY . .

# Next.jsアプリをビルド
RUN npm run build

# 軽量の実行環境を使用
FROM node:18-alpine AS runner

WORKDIR /app

# 必要なファイルのみコピー
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# ポートを公開
EXPOSE 3000

# Next.jsのアプリを起動
CMD ["npm", "run", "dev"]
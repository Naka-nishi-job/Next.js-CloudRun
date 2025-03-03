# --- Builder Stage ---
FROM node:20-alpine AS builder

WORKDIR /app

# 依存関係のインストール
COPY package*.json ./
RUN npm install

# アプリケーションソースのコピー
COPY . .

# Prisma Clientの生成
# RUN npx prisma generate

# プロダクションビルドの実行
RUN npm run build

# --- Production Stage ---
FROM node:20-alpine

WORKDIR /app

# Builder Stageで作成した成果物をコピー
COPY --from=builder /app ./

# Cloud RunはデフォルトでPORT=8080を利用するのでEXPOSEでドキュメント上明記（実際はdocker run時に影響しない）
EXPOSE 8080

# 実行時の環境変数
ENV NEXTAUTH_SECRET=${NEXTAUTH_SECRET}
ENV NEXTAUTH_URL=${NEXTAUTH_URL}
ENV DATABASE_URL=${DATABASE_URL}

# プロダクションサーバーを起動
CMD ["npm", "start"]
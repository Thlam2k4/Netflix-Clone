# --- STAGE 1: BUILD FRONT-END (React/Vite) ---
FROM --platform=linux/amd64 node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# --- STAGE 2: RUNTIME NGINX SERVER ---
FROM --platform=linux/amd64 nginx:stable-alpine

# Chạy dưới root để đảm bảo quyền
USER root

# Xóa nội dung cũ (chỉ khi cần)
RUN rm -rf /usr/share/nginx/html/*

# Copy build từ stage 1
COPY --from=build /app/dist /usr/share/nginx/html

# Chỉ định port
EXPOSE 80

# Khởi động nginx foreground
CMD ["nginx", "-g", "daemon off;"]

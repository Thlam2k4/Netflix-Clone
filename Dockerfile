# Stage 1: Build React/Vite
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# Stage 2: NGINX runtime
# Sử dụng multi-arch image tương thích với host EKS
FROM nginx:stable-alpine

# Không xóa folder, chỉ COPY build
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

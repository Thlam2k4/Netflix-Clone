# Stage 1: Build React/Vite
FROM --platform=linux/amd64 node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# Stage 2: NGINX runtime
FROM --platform=linux/amd64 nginx:stable-alpine

# Chỉ cần tạo thư mục (không xóa)
RUN mkdir -p /usr/share/nginx/html

# Copy build
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

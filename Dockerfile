# --- STAGE 1: BUILD FRONT-END (React/Vite) ---
FROM --platform=linux/amd64 node:18-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

# --- STAGE 2: RUNTIME NGINX SERVER ---
FROM --platform=linux/amd64 nginx:stable-alpine

# Đảm bảo thư mục tồn tại và không để rm bị lỗi
RUN mkdir -p /usr/share/nginx/html \
    && rm -rf /usr/share/nginx/html/* || true

# Copy build output
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

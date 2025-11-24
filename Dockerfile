# --- STAGE 1: BUILD FRONT-END (React/Vite) ---
# Bắt buộc kéo Base Image node:18-alpine với kiến trúc AMD64 (x86_64)
FROM --platform=linux/amd64 node:18-alpine AS build

# Cấu hình môi trường build
WORKDIR /app

# Cài đặt dependencies
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

# Build ứng dụng
COPY . .
RUN npm run build

# --- STAGE 2: RUNTIME NGINX SERVER ---
# Bắt buộc kéo Base Image nginx:stable-alpine với kiến trúc AMD64 (x86_64)
FROM --platform=linux/amd64 nginx:stable-alpine

# Xóa nội dung mặc định của nginx và thay bằng file tĩnh của ứng dụng
# Lệnh này đã được bảo vệ khỏi lỗi 'exec format error' nhờ chỉ định platform ở trên.
RUN rm -rf /usr/share/nginx/html/*

# Copy build từ Vite (Stage 1) vào thư mục phục vụ của nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Mở cổng mặc định của nginx
EXPOSE 80

# Lệnh khởi động (đảm bảo nginx chạy ở foreground)
CMD ["nginx", "-g", "daemon off;"]

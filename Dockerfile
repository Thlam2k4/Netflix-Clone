# Stage 1: Build front-end
FROM node:18-alpine AS build

WORKDIR /app
 
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

# Stage 2: Run with Nginx
FROM nginx:stable-alpine

# Xóa default nginx config
RUN rm -rf /usr/share/nginx/html/*

# Copy build từ Vite vào nginx
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

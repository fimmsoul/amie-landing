FROM nginx:alpine

# 작업 디렉토리 생성
WORKDIR /usr/share/nginx/html

# 기존 nginx 설정 파일 제거
RUN rm -rf /etc/nginx/conf.d/*

# nginx 설정 파일 복사
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 정적 파일 복사
COPY landingpage/ .

# 포트 노출
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"] 
FROM alpine:latest
ENV NGINX_VERSION=1.19.9
RUN apk update && apk upgrade
RUN \
  apk --update add build-base ca-certificates linux-headers openssl openssl-dev pcre pcre-dev wget zlib zlib-dev && \
  cd /tmp && \
  wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  tar xzf nginx-${NGINX_VERSION}.tar.gz && \
  cd /tmp/nginx-${NGINX_VERSION} && \
  ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module && \
  make && \
  make install && \
  adduser -D nginx && \
  rm -rf /tmp/* && \
  apk del build-base linux-headers openssl-dev pcre-dev wget zlib-dev && \
  rm -rf /var/cache/apk/*

EXPOSE 80 443

COPY index.html /etc/nginx/html/index.html

ENTRYPOINT ["nginx", "-g", "daemon off;"]

# create tomcat image
FROM reg.dev.circledna.cn:8443/library/nginx:1.14.0-alpine
MAINTAINER "Liuhongwei <weihoop@gmail.com>"
# 设置locale
ENV LANG="en_US.UTF-8"   \
    LANGUAGE="en_US:en"  \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

# 修改源及常用软件
RUN mkdir -p /etc/apk/ && \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache ca-certificates && \
    apk add --no-cache bash curl tree tzdata shadow && \
    sed -i '/^root/ {s/ash/bash/}' /etc/passwd && \
    # 新建web目录
    usermod -u 99 nobody && \
    groupmod -g 99 nobody && \
    mkdir -p /data/www && \
    chown 99.99 -R /var/cache/nginx /data/www

# 优化系统操作
COPY alias.env /etc/profile.d/alias.env
COPY bashrc /root/.bashrc

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /data/www/index.html

WORKDIR /root

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80

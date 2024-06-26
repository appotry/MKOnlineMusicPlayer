FROM php:7.2-fpm-alpine
WORKDIR /var/www/html
COPY / /var/www/html/
# 安装 nginx 和 cron
RUN apk add --no-cache nginx \
    && apk add --no-cache dcron \
    && mkdir /run/nginx \
    && chown -R www-data:www-data cache/ \
    && mv default.conf /etc/nginx/conf.d \
    && mv php.ini /usr/local/etc/php

EXPOSE 264
# Persistent config file and cache
VOLUME [ "/var/www/html/cache" ]
VOLUME [ "/var/www/html/temp" ]

# 复制 sh 文件到镜像中
COPY entrypoint.sh /entrypoint.sh
COPY userRun.sh /userRun.sh

RUN chmod +x /*.sh

# 设置 entrypoint.sh 脚本作为入口点
ENTRYPOINT ["/entrypoint.sh"]



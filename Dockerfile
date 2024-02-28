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

# 添加 cron 任务并启动服务
COPY cronjob /etc/crontabs/root
CMD if [ ! -d "/var/www/html/temp" ]; then \
        mkdir -p /var/www/html/temp; \
    fi; \
    if [ ! -d "/var/www/html/temp/baidu" ]; then \
        mkdir /var/www/html/temp/baidu; \
    fi; \
    if [ ! -d "/var/www/html/temp/kugou" ]; then \
        mkdir /var/www/html/temp/kugou; \
    fi; \
    if [ ! -d "/var/www/html/temp/netease" ]; then \
        mkdir /var/www/html/temp/netease; \ 
    fi; \
    if [ ! -d "/var/www/html/temp/tencent" ]; then \
        mkdir /var/www/html/temp/tencent; \
    fi; \ 
    if [ ! -d "/var/www/html/temp/xiami" ]; then \ 
        mkdir /var/www/html/temp/xiami; \
    fi; \
    php-fpm & nginx -g "daemon off;"


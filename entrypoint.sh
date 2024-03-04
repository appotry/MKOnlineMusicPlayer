#!/bin/sh

# 检查并创建目录，设置权限
mkdir -p -m 755 /var/www/html/temp/baidu
mkdir -p -m 755 /var/www/html/temp/kugou
mkdir -p -m 755 /var/www/html/temp/netease
mkdir -p -m 755 /var/www/html/temp/tencent
mkdir -p -m 755 /var/www/html/temp/xiami

chown -R www-data:www-data /var/www/html/temp/baidu
chown -R www-data:www-data /var/www/html/temp/kugou
chown -R www-data:www-data /var/www/html/temp/netease
chown -R www-data:www-data /var/www/html/temp/tencent
chown -R www-data:www-data /var/www/html/temp/xiami

# 添加执行权限给所有的 `.sh` 文件
chmod +x /*.sh

# 复制 cron 任务配置文件到 /etc/crontabs/root
cp /var/www/html/cronjob /etc/crontabs/root

# 启动 cron 服务，并将日志重定位到指定位置
crond -l 2 

if [ ! -f /var/www/html/userRun.sh ]; then 
    echo "cp userRun.sh"
    cp /userRun.sh /var/www/html/userRun.sh; 
    chmod +x /var/www/html/userRun.sh;
    /var/www/html/userRun.sh; 
else 
    echo "run userRun.sh"
    /var/www/html/userRun.sh; 
fi

# 启动 PHP-FPM 和 Nginx
php-fpm & nginx -g "daemon off;"


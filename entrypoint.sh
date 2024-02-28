#!/bin/sh

# 检查并创建目录，设置权限
mkdir -p /var/www/html/temp/baidu
mkdir -p /var/www/html/temp/kugou
mkdir -p /var/www/html/temp/netease
mkdir -p /var/www/html/temp/tencent
mkdir -p /var/www/html/temp/xiami

# 设置权限
chmod 755 /var/www/html/temp/baidu
chmod 755 /var/www/html/temp/kugou
chmod 755 /var/www/html/temp/netease
chmod 755 /var/www/html/temp/tencent
chmod 755 /var/www/html/temp/xiami

# 添加执行权限给所有的 `.sh` 文件
chmod +x /*.sh

# 设置 cron 日志文件路径
CRON_LOG="/var/www/html/temp/cron.log"

# 复制 cron 任务配置文件到 /etc/crontabs/root
cp /var/www/html/cronjob /etc/crontabs/root

# 添加每分钟运行一次的任务
echo '* * * * * find /var/www/html/cache/*.json -type f -cmin +30 -exec rm -fv {} \;' >> /etc/crontabs/root

# 添加删除 已经存在了10分钟以上的MP3 文件的任务
echo '*/10 * * * * find /var/www/html/temp/*.mp3 -type f -cmin +10 -exec rm -fv {} \;' >> /etc/crontabs/root

# 添加删除日志文件的任务
echo '0 * * * * find /var/www/html/temp/*.log -type f -size +2M -exec truncate -s 0 {} +;' >> /etc/crontabs/root

# 启动 cron 服务
crond

# 启动 PHP-FPM 和 Nginx
php-fpm & nginx -g "daemon off;"


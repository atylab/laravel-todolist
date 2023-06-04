FROM --platform=linux/amd64 almalinux:8

RUN dnf -y update && dnf clean all

RUN dnf -y install vim tar which unzip httpd mod_ssl gcc make sysstat

RUN dnf -y install epel-release
RUN dnf -y install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf -y module enable php:remi-8.1 

RUN dnf -y update

# PHP8 をインストール
RUN dnf -y install php php-devel php-pear php-mysqlnd php-bcmath php-mbstring 
RUN dnf -y install php-pecl-xdebug php-pecl-redis

RUN dnf -y module reset nodejs
RUN dnf -y module enable nodejs:18
RUN dnf -y install nodejs

COPY web/php.ini /etc/php.ini
COPY web/httpd.conf /etc/httpd/conf/httpd.conf
COPY web/php-fpm.conf /etc/php-fpm.d/www.conf

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN systemctl enable httpd
RUN systemctl enable php-fpm

CMD ["/sbin/init"]

FROM php:7-fpm

ENV TZ Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libicu-dev \ 
        libxml2-dev \ 
        zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli pdo pdo_mysql  \
    && docker-php-ext-enable mysqli pdo pdo_mysql \   
    && docker-php-ext-configure intl \ 
    && docker-php-ext-install intl \    
    && docker-php-ext-install xmlrpc \ 
    && docker-php-ext-install zip \
    && docker-php-ext-install opcache \
    && docker-php-ext-install soap \
    && docker-php-ext-install bcmath
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini
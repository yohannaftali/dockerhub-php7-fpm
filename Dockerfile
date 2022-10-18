FROM php:7-fpm

ENV TZ Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libonig-dev \
        libpng-dev \
        libzip-dev \
        libicu-dev \ 
        libxml2-dev \ 
        libpq-dev \
        jpegoptim optipng pngquant gifsicle \
        zip \
        unzip \
        zlib1g-dev \
        sendmail \
        nano \
        wget \
        curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-enable \
        mysqli \
        pdo \   
        pdo_mysql \
        pgsql \
        pdo_pgsql \    
    && docker-php-ext-install intl \    
    && docker-php-ext-configure intl \ 
    && docker-php-ext-install xmlrpc \ 
    && docker-php-ext-install zip \
    && docker-php-ext-install opcache \
    && docker-php-ext-install soap \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install pcntl 
RUN yes | pecl install \
    apcu-${APCU_VERSION} \
    xdebug \
    && docker-php-ext-enable \
        apcu \
        xdebug \
    && echo "sendmail_path=/usr/sbin/sendmail -t -i" >> /usr/local/etc/php/conf.d/sendmail.ini  \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN sed -i '/#!\/bin\/sh/aservice sendmail restart' /usr/local/bin/docker-php-entrypoint
RUN sed -i '/#!\/bin\/sh/aecho "$(hostname -i)\t$(hostname) $(hostname).localhost" >> /etc/hosts' /usr/local/bin/docker-php-entrypoint
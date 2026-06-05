FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql zip gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN a2enmod rewrite headers

RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf \
    && sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-enabled/000-default.conf \
    && echo "output_buffering = On" > /usr/local/etc/php/conf.d/output-buffering.ini

COPY app/ /var/www/html/

RUN if [ -f /var/www/html/composer.json ]; then \
      cd /var/www/html && composer install --no-dev --no-interaction --optimize-autoloader; \
    fi

RUN if [ -f /var/www/html/frmwk/composer.json ]; then \
      cd /var/www/html/frmwk && composer install --no-dev --no-interaction --optimize-autoloader; \
    fi

RUN echo "display_errors = Off\nlog_errors = On\nerror_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT" \
    > /usr/local/etc/php/conf.d/production.ini

RUN find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2-foreground"]

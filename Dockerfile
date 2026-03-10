FROM alpine:3.23.3

RUN mkdir -p /var/www/localhost/htdocs/symfony-api

WORKDIR /var/www/localhost/htdocs/symfony-api
RUN apk update 
RUN apk add php84-bcmath php84-bz2 php84-calendar php84-ctype php84-curl php84-dom php84-gd \
    php84-iconv php84-intl php84-mbstring php84 nginx php84-fpm php84-phar bash curl php84-posix php84-pdo \
    php84-xml php84-apcu php84-mysql php84-mysqli php84-session php84-simplexml php84-tokenizer php84-opcache \
    php84-sqlite3 php84-pgsql php84-mysql php84-pdo_mysql php84-pdo_pgsql git wget

RUN cd /usr/sbin && wget https://getcomposer.org/download/2.9.3/composer.phar && chmod a+x composer.phar && ln -s composer.phar composer

RUN apk add supervisor
RUN copy it-infra/opi-pc2.conf /etc/nginx/http.d

COPY it-infra/nginx.ini /etc/supervisor.d/
COPY it-infra/php-fpm.ini /etc/supervisor.d/

COPY . .

RUN composer update

EXPOSE 3000
EXPOSE 8080

CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]

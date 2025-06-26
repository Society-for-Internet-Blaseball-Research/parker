FROM dunglas/frankenphp:alpine AS build
RUN apk add --no-cache wget sqlite sqlite-dev gawk sed
RUN echo "memory_limit = 2048M" > $PHP_INI_DIR/conf.d/memory-limit.ini

WORKDIR /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
RUN wget -O /tmp/mysql2sqlite https://raw.githubusercontent.com/mysql2sqlite/mysql2sqlite/refs/heads/master/mysql2sqlite && chmod +x /tmp/mysql2sqlite

RUN wp --allow-root core download
RUN wget https://downloads.wordpress.org/plugin/sqlite-database-integration.zip -O /tmp/sqlite-database-integration.zip && \
    unzip /tmp/sqlite-database-integration.zip -d /var/www/html/wp-content/mu-plugins/ && \
    rm /tmp/sqlite-database-integration.zip

RUN cp /var/www/html/wp-content/mu-plugins/sqlite-database-integration/db.copy /var/www/html/wp-content/db.php && \
    sed -i 's/{SQLITE_IMPLEMENTATION_FOLDER_PATH}/\/var\/www\/html\/wp-content\/mu-plugins\/sqlite-database-integration/g' /var/www/html/wp-content/db.php && \
    sed -i 's/{SQLITE_PLUGIN}/WP_PLUGIN_DIR\/SQLITE_MAIN_FILE/g' /var/www/html/wp-content/db.php

# https://github.com/WordPress/sqlite-database-integration/issues/119
RUN sed -i "s#'SELECT * FROM pragma_index_list(\"' . $table_name . '\") as l;'#\"SELECT * FROM pragma_index_list('\" . $table_name . \"') as l;\"#g" wp-content/mu-plugins/sqlite-database-integration/wp-includes/sqlite/class-wp-sqlite-translator.php
RUN sed -i "s#'SELECT * FROM pragma_index_info(\"' . $index['name'] . '\") as l;'#\"SELECT * FROM pragma_index_info('\" . $index['name'] . \"') as l;\"#g" wp-content/mu-plugins/sqlite-database-integration/wp-includes/sqlite/class-wp-sqlite-translator.php

RUN mkdir /var/www/db
RUN echo '$_SERVER["HTTPS"]="on";' | wp --allow-root config create --dbname=wp --dbuser=wp --skip-check --extra-php
RUN wp --allow-root config set DB_ENGINE sqlite
RUN wp --allow-root config set DB_DIR /var/www/db
RUN wp --allow-root config set DB_FILE wp.db
RUN wp --allow-root config set DISABLE_WP_CRON true --raw
RUN wp --allow-root config set table_prefix "kol_"

ADD localhost.sql /tmp
RUN sed -i 's/`content` json/`content` text/g' /tmp/localhost.sql
RUN sed -i 's#http://houstonspies.cyou#https://houstonspies.cyou#g' /tmp/localhost.sql
RUN sed -i '/-- Indexes for dumped tables/q' /tmp/localhost.sql
RUN /tmp/mysql2sqlite /tmp/localhost.sql | sqlite3 /var/www/db/wp.db
RUN echo 'CREATE TABLE IF NOT EXISTS _mysql_data_types_cache (`table` TEXT NOT NULL,`column_or_index` TEXT NOT NULL,`mysql_type` TEXT NOT NULL, PRIMARY KEY(`table`, `column_or_index`));' | sqlite3 /var/www/db/wp.db 
RUN echo "UPDATE kol_options SET option_value = 'https://houstonspies.cyou' WHERE option_name = 'siteurl';" | sqlite3 /var/www/db/wp.db 
RUN echo "UPDATE kol_options SET option_value = 'https://houstonspies.cyou' WHERE option_name = 'home';" | sqlite3 /var/www/db/wp.db

RUN wp --allow-root plugin install wordpress-seo

COPY data.zip /tmp
RUN unzip /tmp/data.zip && rm /tmp/data.zip

RUN rm -rf wp-admin/{css,images,js,maint,network,user,*.php}
RUN rm wp-activate.php wp-comments-post.php wp-config-sample.php wp-cron.php wp-links-opml.php wp-login.php wp-mail.php wp-signup.php wp-trackback.php xmlrpc.php

RUN echo "<?php header('Location: /'); ?>" > wp-login.php
RUN echo "<?php echo json_encode(array('error'=> true, 'message' => 'computer says no :/' )); ?>" > contact/formsubmit.php
RUN sed -i "s#\$password = \$_GET\['password'\];#\$password = \$_GET\['password'\];\$body=new stdClass();#g" wp-content/themes/twentytwenty/functions/password.php
COPY object-cache.php /var/www/html/wp-content/

RUN wp --allow-root user reset-password $(wp --allow-root user list --format=ids) --skip-email
RUN wp --allow-root user update $(wp --allow-root user list --format=ids) --skip-email --user_email=""
RUN echo "DELETE FROM kol_actionscheduler_actions; DELETE FROM kol_actionscheduler_logs; DELETE FROM kol_commentmeta; DELETE FROM kol_redirection_404; DELETE FROM kol_redirection_logs; DELETE FROM kol_usermeta WHERE meta_key = 'community-events-location';" | sqlite3 /var/www/db/wp.db
RUN echo "UPDATE kol_comments SET comment_author_email = 'redacted@houstonspies.cyou', comment_author_IP = '1.2.3.4', comment_agent = 'haha get it? agent?';" | sqlite3 /var/www/db/wp.db
RUN echo "UPDATE kol_users SET user_activation_key = '';" | sqlite3 /var/www/db/wp.db
RUN echo "DELETE FROM kol_comments WHERE comment_approved = 'spam';" | sqlite3 /var/www/db/wp.db
RUN echo 'VACUUM' | sqlite3 /var/www/db/wp.db

# -----
    
FROM dunglas/frankenphp:alpine
RUN install-php-extensions opcache

COPY --from=build /var/www /var/www
RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY Caddyfile /etc/caddy/Caddyfile

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

USER nobody
ENTRYPOINT ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]


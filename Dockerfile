FROM docker.io/centos:7.3.1611

RUN yum -y install mariadb httpd php php-mysql
RUN curl -o /tmp/cakephp.tar.gz https://codeload.github.com/cakephp/cakephp/tar.gz/2.7.11 
RUN curl -o /tmp/irohaboard.tar.gz https://codeload.github.com/irohasoft/irohaboard/tar.gz/v0.9.7 
RUN mkdir /var/www/cake
RUN tar xvzf /tmp/cakephp.tar.gz -C /var/www/cake --strip-components=1
RUN tar xvzf /tmp/irohaboard.tar.gz -C /var/www/html --strip-components=1
RUN rm -f /tmp/cakephp.tar.gz /tmp/irohaboard.tar.gz
COPY database.php /var/www/html/Config/database.php
COPY httpd.conf /etc/httpd/conf/httpd.conf
RUN chown apache:apache -R /var/www/html /var/www/cake

COPY check_variables /tmp/check_variables
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apachectl", "-DFOREGROUND"]


FROM stackbrew/debian:wheezy
 
RUN echo "deb http://ftp.de.debian.org/debian/ wheezy non-free contrib" >> /etc/apt/sources.list
RUN apt-get update

# install nginx and php5 and mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -qy install nginx php5-fpm php5-mysql php5-gd php5-intl php5-imagick php5-mcrypt php5-curl php5-cli git mysql-server supervisor postfix
RUN apt-get -qy clean

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD my.cnf /etc/mysql/my.cnf
ADD nginx.conf /etc/nginx/nginx.conf

RUN postconf -e mydestination="localhost.localdomain, localhost"
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini

RUN useradd -m -u 1500 user
 
CMD /usr/bin/supervisord -n

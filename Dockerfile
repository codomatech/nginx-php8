FROM nginx:mainline-bullseye

RUN apt-get update && \
  apt-get install -y wget lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" |  tee /etc/apt/sources.list.d/sury-php.list && \
  curl -fsSL  https://packages.sury.org/php/apt.gpg| gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg && \
  wget -qO - https://packages.sury.org/php/apt.gpg |  apt-key add - && \
  apt-get update

RUN apt-get install -y php8.1 php8.1-bcmath php8.1-curl php8.1-zip php8.1-gd \
  php8.1-zip php8.1-opcache php8.1-xml php8.1-fpm php8.1-curl php8.1-mbstring \
  php8.1-sqlite3 php8.1-mysql php8.1-pgsql

RUN echo 'include /etc/nginx/fastcgi_params;' >>/etc/nginx/fastcgi.conf
RUN sed -i 's@user\s\+nginx;@user www-data;@g' /etc/nginx/nginx.conf
RUN echo 'server {\n  listen   80;\n  listen  [::]:80;\n  server_name  localhost;\n\n  access_log  /dev/stdout;\n  access_log  /dev/stderr;\n\n  location / {\n  root   /usr/share/nginx/html;\n  index  index.html index.htm index.php;\n  }\n\n  location ~ [^/]\\.php(/|$) {\n  fastcgi_split_path_info ^(.+?\\.php)(/.*)$;\n  fastcgi_param HTTP_PROXY "";\n  fastcgi_param SCRIPT_FILENAME /usr/share/nginx/html$fastcgi_script_name;\n  fastcgi_pass unix:/run/php/php8.1-fpm.sock;\n  fastcgi_index app.php;\n  include fastcgi.conf;\n  }\n}\n' > /etc/nginx/conf.d/default.conf
EXPOSE 80

ENTRYPOINT ["bash", "-c", "service php8.1-fpm start && nginx -g 'daemon off;'"]

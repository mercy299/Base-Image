FROM nginx:mainline-alpine

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "http://dl-2.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories

RUN apk update && apk add --no-cache shadow

RUN useradd -M -s /sbin/nologin web_runtime_user && \
    echo "web_runtime_user:cdc01cb19cc1ee86b2bc4aa5c67d6f5b9d3866225a5c3b0f5df1866a6f371fe4" | chpasswd -e && \
    usermod -aG www-data web_runtime_user

RUN apk add --no-cache git

RUN apk add --no-cache tzdata && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone

RUN mkdir -p /tmp/log/nginx && \
    touch /tmp/log/nginx/app-error.log /tmp/log/nginx/access.log && \
    chown -R web_runtime_user:www-data /tmp/log/nginx /var/log/nginx

RUN find / -path /proc -prune -o -name "*.sh" -exec chmod +x {} +

RUN apk add --no-cache supervisor

COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY supervisord.conf /etc/supervisord.conf

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf.d/ /etc/nginx/conf.d/

RUN rm -rf /tmp/* /var/cache/apk/*

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

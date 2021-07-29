# Dockerfile 文件
FROM alpine:latest

# 作者名称
MAINTAINER limingshuang lms.minsonlee@gmail.com

# 环境变量
ENV APP_INSTALL_PATH /apps/nginx
ENV PATH $PATH:$APP_INSTALL_PATH/sbin

# 构建镜像
# 定义安装所需依赖包
RUN BUILD_DEPS="gcc g++ libc-dev zlib zlib-dev make perl pcre pcre-dev openssl openssl-dev readline readline-dev tzdata binutils curl" \
    # 定义 Nginx 安装信息变量
    && NGINX_VERSION="1.21.1" \
    && NGINX_USER="www" \
    && NGINX_GROUP="www" \
    && NGINX_SBIN_PATH="$APP_INSTALL_PATH/sbin/nginx" \
    && NGINX_CONF_PATH="$APP_INSTALL_PATH/conf" \
    && NGINX_LOGS_PATH="$APP_INSTALL_PATH/logs" \
    && NGINX_PIDS_PATH="$APP_INSTALL_PATH/pids" \
    && NGINX_LOCKS_PATH="$APP_INSTALL_PATH/locks" \
    && NGINX_MODULES_PATH="$APP_INSTALL_PATH/modules" \
    && HTTP_TEMP_PATH="/var/cache/nginx" \
    && SOURCE_CODE_PATH="/usr/src/nginx" \
    && NGINX_CONFIG="\
        --prefix=$APP_INSTALL_PATH \
        --sbin-path=$NGINX_SBIN_PATH \
        --modules-path=$NGINX_MODULES_PATH \
        --user=$NGINX_USER --group=$NGINX_GROUP \
        --conf-path=$NGINX_CONF_PATH/nginx.conf \
        --pid-path=$NGINX_PIDS_PATH/nginx.pid \
        --lock-path=$NGINX_LOCKS_PATH/nginx.lock \
        --error-log-path=$NGINX_LOGS_PATH/error.log \
        --http-log-path=$NGINX_LOGS_PATH/access.log \
        --http-client-body-temp-path=$HTTP_TEMP_PATH/client_body_temp \
        --http-proxy-temp-path=$HTTP_TEMP_PATH/proxy_temp \
        --http-fastcgi-temp-path=$HTTP_TEMP_PATH/fastcgi_temp \
        --http-uwsgi-temp-path=$HTTP_TEMP_PATH/uwsgi_temp \
        --http-scgi-temp-path=$HTTP_TEMP_PATH/scgi_temp \
        --with-debug \
        --with-stream \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_gzip_static_module \
        --with-openssl=$SOURCE_CODE_PATH/openssl-OpenSSL_1_0_2l \
        --add-module=$SOURCE_CODE_PATH/nginx-http-concat-master \
        --add-module=$SOURCE_CODE_PATH/nginx-push-stream-module-master \
        " \
    # 1. 创建所需目录
    && mkdir -p $HTTP_TEMP_PATH \
    && mkdir -p $SOURCE_CODE_PATH \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && addgroup -g 10000 $NGINX_USER \
    && adduser -DH -u 10000 -s /sbin/nologin -G $NGINX_GROUP $NGINX_USER \
    && cd $SOURCE_CODE_PATH \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && curl -fSL https://github.com/alibaba/nginx-http-concat/archive/master.zip -o nginx-http-concat.zip \
    && curl -fSL https://github.com/wandenberg/nginx-push-stream-module/archive/master.zip -o nginx-push-stream-module.zip \
    && curl -fSL https://github.com/openssl/openssl/archive/OpenSSL_1_0_2l.tar.gz -o openssl.tar.gz \
    && tar -zxC $SOURCE_CODE_PATH -f nginx.tar.gz \
    && unzip -d $SOURCE_CODE_PATH nginx-http-concat.zip \
    && unzip -d $SOURCE_CODE_PATH nginx-push-stream-module.zip \
    && tar -zxC $SOURCE_CODE_PATH -f openssl.tar.gz \
    && cd $SOURCE_CODE_PATH/nginx-$NGINX_VERSION \
    && export CFLAGS="-Wno-error" \
    && ./configure $NGINX_CONFIG \
    && make -j "$(nproc)" \
    && make install \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' $NGINX_SBIN_PATH $NGINX_MODULES_PATH/*.so \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && strip $APP_INSTALL_PATH/sbin/nginx \
    && apk add --no-cache $runDeps \
    && ln -sf /dev/stdout $APP_INSTALL_PATH/logs/access.log \
    && ln -sf /dev/stderr $APP_INSTALL_PATH/logs/error.log \
    && apk del .build-deps \
    && rm -rf $SOURCE_CODE_PATH $APP_INSTALL_PATH/html

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]

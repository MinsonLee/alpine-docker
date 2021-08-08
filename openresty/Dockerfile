# Dockerfile 文件
FROM alpine:latest

# 作者名称
MAINTAINER limingshuang lms.minsonlee@gmail.com

# 环境变量
ENV APP_INSTALL_PATH /apps/openresty
ENV NGINX_INSTALL_PATH /apps/nginx
ENV WORK_DIR /work
ENV PATH $PATH:$NGINX_INSTALL_PATH/sbin

# 构建镜像
# 定义临时存放所有下载源码信息的目录、依赖版本
RUN OPENRESTY_VERSION="1.19.3.2" \
    && BUILD_DEPS="linux-headers gd-dev geoip-dev openssl-dev libxml2-dev libxslt-dev pcre-dev perl-dev pkgconf readline-dev zlib-dev make build-base !nginx postgresql postgresql-dev curl" \
    # 定义 Nginx 安装信息变量
    && SOURCE_CODE_PATH="/tmp/src" \
    && NGINX_USER="www" \
    && NGINX_GROUP="www" \
    && NGINX_SBIN_PATH="$NGINX_INSTALL_PATH/sbin/nginx" \
    && NGINX_LOGS_PATH="$NGINX_INSTALL_PATH/logs" \
    && NGINX_CONF_PATH="$NGINX_INSTALL_PATH/conf" \
    && NGINX_MODULES_PATH="$NGINX_INSTALL_PATH/modules" \
    && HTTP_TEMP_PATH="$NGINX_INSTALL_PATH/cache" \
    && CONFIGURE_CONFIG="\
        --prefix=$APP_INSTALL_PATH \
        --sbin-path=$NGINX_SBIN_PATH \
        --modules-path=$NGINX_MODULES_PATH \
        --conf-path=$NGINX_CONF_PATH/nginx.conf \
        --error-log-path=$NGINX_LOGS_PATH/error.log \
        --http-log-path=$NGINX_LOGS_PATH/access.log \
        --pid-path=$NGINX_INSTALL_PATH/pids/nginx.pid \
        --lock-path=$NGINX_INSTALL_PATH/locks/nginx.lock \
        --http-client-body-temp-path=$HTTP_TEMP_PATH/client_body_temp \
        --http-proxy-temp-path=$HTTP_TEMP_PATH/proxy_temp \
        --http-fastcgi-temp-path=$HTTP_TEMP_PATH/fastcgi_temp \
        --http-uwsgi-temp-path=$HTTP_TEMP_PATH/uwsgi_temp \
        --http-scgi-temp-path=$HTTP_TEMP_PATH/scgi_temp \
        --user=$NGINX_USER --group=$NGINX_GROUP \
        --with-debug \
        --with-stream \
        --with-luajit \
        --with-http_iconv_module \
        --with-http_postgres_module \
        --with-http_gzip_static_module \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_geoip_module \
    "\
    # 开始执行任务
    && mkdir -p $APP_INSTALL_PATH \
    && mkdir -p $NGINX_INSTALL_PATH \
    && mkdir -p $WORK_DIR \
    && mkdir -p $SOURCE_CODE_PATH \
    && mkdir -p $HTTP_TEMP_PATH $NGINX_MODULES_PATH $NGINX_CONF_PATH $NGINX_LOGS_PATH \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && addgroup -g 10000 $NGINX_USER \
    && adduser -DH -u 10000 -s /sbin/nologin -G $NGINX_GROUP $NGINX_USER \
    && cd $SOURCE_CODE_PATH \ 
    && curl -fSL https://openresty.org/download/openresty-$OPENRESTY_VERSION.tar.gz -o openresty.tar.gz \
    && tar -zxC $SOURCE_CODE_PATH -f openresty.tar.gz \
    && cd $SOURCE_CODE_PATH/openresty-$OPENRESTY_VERSION \
    # 编译安装
    && ./configure $CONFIGURE_CONFIG \
    && make -j "$(nproc)" \
    && make install \
    # 扫描获取运行必要的依赖库文件
    && DEPEND_PKG="$( \
        scanelf --needed --nobanner --format '%n#p' $NGINX_SBIN_PATH $NGINX_MODULES_PATH/*.so \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    # 软连信息
    && ln -sf $NGINX_LOGS_PATH $WORK_DIR/logs \
    && ln -sf $NGINX_CONF_PATH $WORK_DIR/conf \
    && ln -sf $HTDOCS_PATH $WORK_DIR/htdocs \
    # 删除预安装的文件
    && apk del .build-deps \
    && rm -rf $SOURCE_CODE_PATH \
    # 重新添加运行时必要安装的库文件
    && apk add --no-cache $DEPEND_PKG

#映射端口
EXPOSE 80

WORKDIR $WORK_DIR

STOPSIGNAL SIGTERM

# 执行命令
CMD ["nginx", "-g", "daemon off;"]

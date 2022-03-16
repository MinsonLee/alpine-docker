# 基于 alpine 最新版本作基础镜像
FROM alpine:latest

# 作者名称
MAINTAINER limingshuang lms.minsonlee@gmail.com

# 环境变量
env GOPATH /home
env GOROOT /usr/local/go
env GOPROXY goproxy.cn
env PATH $GOROOT/bin:$GOPATH/bin:$PATH

# 构建镜像
# 1. 修改 alpine 镜像源为阿里云镜像源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    # 定义安裝信息
    && GO_VERSION="1.18" \
    # 2. 安装基础软件和依赖 
	# build-base 会安装一些基础依赖，但也会让安装出来的镜像略大
    && apk add --no-cache --virtual .build-deps wget git tar \
    && apk add --no-cache gcc musl-dev gdb binutils libc6-compat \
    # 下列工具安装-学习过程可能会涉及
    && apk add --no-cache vim strace htop htop-doc procps sysstat mandoc man-pages \
    # 3. 下载 golang 1.14.12 && 解压
    && wget -O /tmp/go.tar.gz "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz" \
    && tar -C /usr/local -zxvf /tmp/go.tar.gz \
    # 4. 安装 dlv
    && echo "140.82.112.4 github.com" >> /etc/hosts \
    && echo "185.199.108.154 github.githubassets.com" >> /etc/hosts \
    && echo "199.232.69.194 github.global.ssl.fastly.net" >> /etc/hosts \
    && git clone https://github.com/go-delve/delve /tmp/delve \
    && cd /tmp/delve/cmd/dlv \
    && go build && go install \
    # 4. 清理无用安装文件和缓存文件
    && rm -rf /tmp/* \
    && rm -rf $GOPATH/pkg/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/src/* \
    && apk del .build-deps

# 复制文件
COPY hosts entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# 设置工作目录
WORKDIR $GOPATH

STOPSIGNAL SIGQUIT


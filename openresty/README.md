## 常用命令

- 构建镜像：`docker build -t openresty .`
- 运行容器：`docker run -dit -p 80:80 -v /docker/alpine-docker/openresty/conf:/apps/nginx/conf -v /docker/alpine-docker/openresty/logs:/apps/nginx/logs --name openresty openresty`
- 启动/停止容器：`docker start/stop openresty`
- 运行容器：`docker exec -it openresty sh`

> 注意：logs 目录权限需要设置为 0777


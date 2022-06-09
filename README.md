# sentinel-dashboard-for-k8s
alibaba sentinel dashboard for k8s.


# TAGS

`1.7.1` `latest`

`1.6.1` `1.6.3` `1.8.4`

# 端口
web端口 8858

api server : 8719

# 默认用户名和密码
sentinel/sentinel

# VOLUME

容器内日志目录：/opt/logs

# Helm deploy
```shell
helm repo add sentinel-dashboard https://royalwang.github.io/sentinel-dashboard-for-k8s/charts/

helm install msentinel-dashboard sentinel-dashboard/sentinel-dashboard

```


# Docker run

```shell
docker run --name sentinel -p 8858:8858 -v ./logs:/opt/logs royalwang/sentinel-dashboard:latest
```

或

```shell
docker run -e JAVA_OPT_EXT='-Xmx1g' -e USERNAME="sentinel" -e PASSWORD="sentinel" -e SERVER_HOST="localhost" --name sentinel -p 8858:8858 royalwang/sentinel-dashboard:latest
```
或

```shell
docker run --rm --name sentinel -p 8858:8858 royalwang/sentinel-dashboard:latest
```

或

```shell
docker run --rm -e JAVA_OPT_EXT='-Xmx1g' --name sentinel -p 8858:8858 royalwang/sentinel-dashboard:latest
```

# 官网

https://github.com/alibaba/Sentinel

新手指南

[https://github.com/alibaba/Sentinel/wiki/新手指南](https://github.com/alibaba/Sentinel/wiki/%E6%96%B0%E6%89%8B%E6%8C%87%E5%8D%97)






# 根据 Dockerfile 自己编译

编译镜像

```shell
docker build -t royalwang/sentinel-dashboard:1.6.1 --build-arg version=1.6.1 ./
```

启动容器
````SHELLL
docker run --rm --name sentinel -p 8858:8858 royalwang/sentinel-dashboard:1.6.1

或
docker run --rm -e JAVA_OPT_EXT="-Dserver.port=8858 -Dcsp.sentinel.dashboard.server=localhost:8858 -Dproject.name=sentinel-dashboard -Djava.security.egd=file:/dev/./urandom" --name sentinel -p 8858:8858 royalwang/sentinel-dashboard:1.6.1
````

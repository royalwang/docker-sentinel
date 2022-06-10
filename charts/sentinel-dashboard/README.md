# sentinel-dashboard-for-k8s
alibaba sentinel dashboard for k8s.

# 端口
Web Port: 8858

Api Server Port: 8719

# 默认用户名和密码
sentinel/sentinel

# Helm deploy
```shell
helm repo add sentinel-dashboard https://royalwang.github.io/sentinel-dashboard-for-k8s/

helm install msentinel-dashboard sentinel-dashboard/sentinel-dashboard

```
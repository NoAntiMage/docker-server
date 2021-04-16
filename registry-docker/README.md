# 私有容器仓库搭建

### 服务初始化

---

##### 启动方式

```
docker-compose up -d
```



##### 客户端配置安全仓库

vi /etc/daemon.json

```
{ "insecure-registries":["$REPO:5000"] }
```



### repo-api

---

以nginx镜像为例

```
#获取所有镜像名
curl localhost:5000/v2/_catalog

#获取nginx所有镜像tag
curl localhost:5000/v2/nginx/tags/list

#获取nignx:v1的详细信息
curl --head localhost:5000/v2/nginx/manifests/v1

#获取nginx:v1正确的digest(registry 版本自2.3起)
curl \
--head \
-H 'Accept: application/vnd.docker.distribution.manifest.v2+json' \
localhost:5000/v2/nginx/manifests/v1 

#删除nginx:v1
curl -X DELETE localhost:5000/v2/busybox/manifests/<Docker-Content-Digest>

```





### reference

---

https://docs.docker.com/registry/deploying/

https://docs.docker.com/registry/configuration/

https://docs.docker.com/registry/spec/api/
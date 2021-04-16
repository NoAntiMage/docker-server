## docker跨主机网络方案

#### Overlay Driver

Overlay网络驱动用于分布式多节点网络通信。overlay网络栈位于二层网络之上，将创建docker_gwbridge桥接，划分子网段，创建虚拟ip，其中：

1. TCP端口2377，用于集群管理信息的交流。
2. TCP、UDP端口7946用于集群中节点的交流。
3. UDP端口4789用于overlay网络中数据报的发送与接收。



#### Node discovery

docker daemon基于libkv模块提供元数据存储功能，用于保存分布式节点信息。

节点发现配置：

cluster-advertise：将自身广播至集群

cluster-store：调用KV数据库保存集群信息



## 操作流程：

节点声明：

- node-consul
- node-1
- node-2



#### STEP-1:  集群信息存储

于node-consul，启动 集群信息存储，本例选择consul

```
docker run -d -p 8500:8500 --name=consul consul agent -server -bootstrap -ui -client='0.0.0.0'
```



#### STEP-2: 节点集群模式

docker daemon启动方式

```
/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

默认dockerd启动将加载 /etc/docker/daemon.json



于node-1、node-2，更改dockerd启动参数，启动集群模式，之后重启docker加载配置，并检查配置

vi /etc/docker/daemon.json

```
{
  "live-restore": true,
  "cluster-store": "consul://${consul_ip}:8500",
  "cluster-advertise": "${local_ip}:2375"
}
```



检查docker信息

```
$ docker info
...
Cluster Store: consul://${consul_ip}:8500
Cluster Advertise: ${local_ip}:2375
```



调用consul检查集群是否创建成功

```
curl ${consul_ip}:8500/v1/agent/members
```

将获取集群节点信息



#### STEP-3：节点网络

于node-1、node-2任意节点，创建overlay网络

```
docker network create -d overlay my_overlay
```

可选参数

指定子网：  --subnet=192.168.0.0/16 

指定网关：  --gateway=192.168.0.100 



查看网络情况

```
$ docker network ls
NETWORK ID     NAME                   DRIVER    SCOPE
8fc94f390b32   my_overlay            overlay   global
```

检查网络为 overlay驱动模式，作用域为global全局模式



#### STEP-4: 应用加入网络

至此node-1，node-2创建容器时加入 my_overlay网络可互通。

示例：

```
docker run -d --network my_overlay nginx
```



## 小结：

此套方案为dockerd原生集群方案，docker-swarm集群为采用此方案进行的封装。
高可用升级方案，选择将consul启动集群位于负载均衡后端。



## 参考文档：

https://docs.docker.com/engine/reference/commandline/dockerd/

https://docs.docker.com/network/network-tutorial-overlay/

https://github.com/moby/moby/issues/30013

https://docker-k8s-lab.readthedocs.io/en/latest/docker/docker-etcd.html

https://github.com/docker/libkv/

https://blog.alexellis.io/docker-stacks-attachable-networks/
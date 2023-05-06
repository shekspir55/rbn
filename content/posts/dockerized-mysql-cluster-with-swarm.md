---
title: "Dockerized Mysql Cluster With Swarm 🐋🐳🐋"
date: 2023-05-05T20:54:50+04:00
draft: false
---
Docker Swarm is a good choice for smaller and simpler Dockerized MySQL clusters due to its ease of use and compatibility with Docker. On the other hand, Kubernetes offers advanced features and scalability for larger and more complex deployments, but requires a higher level of knowledge and infrastructure. Ultimately, choose the best option based on your application's specific needs.

In this article, we'll explore the deployment of a 3-node InnoDB cluster using Docker Swarm. The cluster will consist of three MySQL nodes, each running on a separate server. We'll take a deep dive into the process of setting up Docker Swarm, configuring the MySQL nodes, and deploying the cluster. By the end of this article, you'll have a solid understanding of how to use Docker Swarm to deploy a MySQL cluster, and you'll be ready to tackle similar projects on your own.


🚨 Be careful when using Dockerized databases! 🚨

🔥 Containers can be a fire hazard if not properly secured, leading to potential data loss or breaches.



For our deployment of the 3-node InnoDB cluster using Docker Swarm, we have two main strategies to consider for setting up the necessary directories. 

1. The first strategy involves configuring NFS on any number of machines and adding one more server for NFS.
2. The second strategy involves creating dedicated directories for each server we will use, and forcing Docker to run on the servers we want to make it replicate bare metal deployment.

For our purposes, we'll be using the second strategy. This approach will allow us to have more control over the deployment, and ensure that each server has its own dedicated directory for the MySQL data. Let's take a closer look at the steps involved in this approach.

### Note about env vars
To distribute environment variables to all containers in a Docker Swarm cluster, you should embed them in the Docker Compose file. This is necessary because environment files are not distributed across all nodes in the cluster.

This is not very elegant but we will get back to this in another post probably.

![Docker Swarm Diagram](/images/docker-swarm-mysql-diagram.svg)

### repo with source codes example
Please pull the repository from here
https://github.com/shekspir55/mysql-docker-compose-examples
### less talk more work

create directories in the servers

```sh
    mkdir /mysql-data
```

```bash 
    docker swarm init
```
Follow instructions to set up secondary swarm instances.

Add labels to swarm nodes, this is needed to force nodes to run on the swarm nodes we want.

```sh
    # take ids from the output to input in the commands below
    docker node ls
    #for master swarm instance
    docker node update --label-add type=leader ID-GOES-HERE 
    #for master secondary instances
    docker node update --label-add type=worker-2 ID-GOES-HERE
    #for master secondary instances
    docker node update --label-add type=worker-3 ID-GOES-HERE 
```

```sh
    docker stack deploy -c ./docker-compose.yml cluster
```

### to debug docker swarm if something goes wrong and node doesn't start

`docker service ls` - to get all services which are suppose to run.

`docker service ps --no-trunc ID-OF-CONTAINER-NOT-STARTING`


### now check mysql-shell logs for results

## references:
- https://dev.mysql.com/blog-archive/docker-compose-setup-for-innodb-cluster/
- https://www.linkedin.com/pulse/dockerized-mysql-clustering-george-pentaris

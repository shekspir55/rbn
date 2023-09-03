---
title: "Tips on troubleshooting Docker Image build, Compose and Swarm issues 🐳🐳🐳"
date: 2023-08-19T23:52:45+04:00
draft: false
---
Docker has revolutionized the way we develop, deploy, and manage applications, allowing us to create lightweight and isolated containers that encapsulate our applications' dependencies and runtime environments. However, like any technology, Docker can present its fair share of challenges. In this blog post, we will delve into the world of troubleshooting Docker image builds, Docker Compose, and Docker Swarm failures, and explore some troubleshooting techniques I use that may help you save time.

## Dockerfile
### Troubleshooting docker image "build failed"

Let's say we have a Dockerfile which doesn't build. Let's say it looks like this.

```dockerfile
FROM ubuntu

RUN echo "build started"

RUN apt install -y curl

RUN echo "build finished"
```

The output will look something like this.
![build failed](/images/troubleshooting-docker/build-fail.png)

Let's say we don't understand why it's failing, though in this case it's written clearly.

we can do following, comment out all the lines in the dockerfile up to the point of failing line.

```dockerfile
FROM ubuntu

RUN echo "build started"

# RUN apt install -y curl

# RUN echo "build finished"
```

build it `docker build -t test-image .`

![commented-build](/images/troubleshooting-docker/commented-build.png)

Run image and shell into it `docker run -it test-image bash`.

Explore the image from the inside and try to fix the issues.

![running-docker-from-inside](/images/troubleshooting-docker/running-docker-from-inside.png)

and now if we do `apt install -y curl` it's finally installed.

![apt-finished](/images/troubleshooting-docker/apt-finished.png)

So we put the fix in the dockerfile and everything builds normally.

![build-successful](/images/troubleshooting-docker/build-successful.png)

## Compose
### Troubleshooting docker compose doesn't start properly

If you don't understand why your servers are not starting and you are at a dead end, you can always comment it out. Start by commenting one by one and running after each change to troubleshoot
1. networks
2. ports
3. volumes
4. Containers that depend on other containers


## Swarm with compose
### Common reasons why your docker-compose may work on it's own and not work with the swarm

### Networking issue
   1. Note that docker swarm cannot allocate a static IP to a machine, the main reason is that if there is more than 1 server it will not know to which server to allocate it.
   2. You can try commenting on all network parameters in compose file.

### Volume issue
   1. If you use virtual volumes in most cases you will not get a problem, otherwise, docker swarm will not start, the issue is that in the secondary nodes volume will not be found.
   There are 2 solutions to this problem
      1. Use virtual volumes
      2. Create directories and provide absolute paths to the volume.
      ```yml
        volumes:
            - /absolute-path-to-volume:/app/data
      ``` 
### Exposed Ports issue
   1. Try commenting out exported ports in docker compose.
   2. There might be some network misconfiguration
   3. Another possibility is another server docker or a non-docker is running. In this case, you will need to disable the server or change the exposed ports.

### ENV variables
   1. You cannot use `env_file:` when running docker swarm, the reason is that on the secondary nodes, you may not have the file, and thus docker cannot read it, use `environment:` instead
      1. I actually wrote a script in Makefile that created a temporary docker compose infused in env variables from `.env` file. It was junky🗑️ but it worked.


### Troubleshooting docker swarm amd docker compose

If you run docker swarm with **docker compose** and when you do `docker service ls` you see that your services may not start. In that cases, you can investigate the service manually.

```sh
docker service ps --no-trunc DOCKER_SERVICE_CONTAINER_ID
```
This command helped me in numerous cases🏆️ when I didn't understand what is wrong with the swarm!

Docker will tell you about the issue. If it's a network issue try 


```sh
docker network list
```
![docker service ps screenshot](/images/troubleshooting-docker/docker-ps.png)

And after you can continue investigating with 

```sh
docker network inspect DOCKER_NETWORK_ID
```

# Finally 💬
If you don't understand the issue, comment something out and run it.
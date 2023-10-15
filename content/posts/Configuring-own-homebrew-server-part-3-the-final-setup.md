---
title: "Configuring own homebrew server - part 3: The Final Setup 🐋🐧☁️"
date: 2023-10-15T12:04:21+04:00
draft: false
---

If you have read my previous [part 1](/posts/configuring-own-homebrew-server-part-1-arch-linux-networking-and-data-syncing/) and [part 2](/posts/configuring-own-homebrew-server-part-2-regain-control-of-your-data-secure-alternatives-to-google-drive-icloud-1password-spotify-and-more/), here is the configuration.

![internet whale](/images/homebrew-server/whale.png)

### Note: my server hardware is very slow, I use `AMD E-350 Processor` CPU with 8 GB DDR3 RAM with a speed of 1600 MT/s. it's 12 years old already when AMD didn't have the glory it has now.

This is a docker-compose file I use while writing the post.

```yml
version: '3.7'
services:

    ################################################
    #                      vpn                     #
    ################################################    
    wireguard:
        image: lscr.io/linuxserver/wireguard:latest
        restart: always
        environment:
            - PUID=1000
            - PGID=1000
            - TZ=Asia/Hong_Kong
            - SERVERURL=YOUR_SERVER_URL.COM
            - SERVERPORT=51820
            - PEERS=myPC1,myPC2,myPC3,myPhone4
            - PEERDNS=auto
        ports:
          - 51820:51820/udp
        volumes:
            - ./wireguard/config:/config
            - ./wireguard/modules:/lib/modules
        cap_add:
            - NET_ADMIN
            - SYS_MODULE
        sysctls:
            - "net.ipv4.conf.all.rp_filter=2"
        networks:
            - vpn


    ################################################
    #                      nextcloud               #
    ################################################    
    nextcloud-db:
        image: mariadb:10.5.9
        restart: always
        command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
        volumes:
          - ./nextcloud/nextcloud-db:/var/lib/mysql
        environment:
          - MYSQL_ROOT_PASSWORD=VERY_SECURE_PASSWORD
          - MYSQL_PASSWORD=VERY_SECURE_PASSWORD
          - MYSQL_DATABASE=nextcloud
          - MYSQL_USER=nextcloud
        networks:
            - nextcloud-internal

    my.cloud:
        image: nextcloud:27
        restart: always
        volumes:
          - ./nextcloud/nextcloud:/var/www/html
        environment:
          - MYSQL_PASSWORD=VERY_SECURE_PASSWORD
          - MYSQL_DATABASE=nextcloud
          - MYSQL_USER=nextcloud
          - MYSQL_HOST=nextcloud-db
          - NEXTCLOUD_TRUSTED_DOMAINS=my.cloud next.cloud
        depends_on:
          - nextcloud-db
        networks:
            vpn:
              ipv4_address: 192.168.104.10
            nextcloud-internal:

    cron:
      image: nextcloud:27
      container_name: nextcloud-cron
      restart: unless-stopped
      depends_on:
        - my.cloud
      environment:
          - MYSQL_PASSWORD=VERY_SECURE_PASSWORD
          - MYSQL_DATABASE=nextcloud
          - MYSQL_USER=nextcloud
          - MYSQL_HOST=nextcloud-db
          - NEXTCLOUD_TRUSTED_DOMAINS=my.cloud next.cloud
          - TRUSTED_PROXIES=192.168.104.13
      volumes:
          - ./nextcloud/nextcloud:/var/www/html
      entrypoint: /cron.sh
      networks:
        - nextcloud-internal

    phpmyadmin.cloud:
      image: phpmyadmin
      restart: always
      environment:
        - PMA_ARBITRARY=1
      depends_on:
        - nextcloud-db
      networks:
            vpn:
              ipv4_address: 192.168.104.12
            nextcloud-internal:

    ################################################
    #                      gitea                   #
    ################################################    
    git.cloud:
      image: gitea/gitea:1.16.6
      environment:
        - USER_UID=1000
        - USER_GID=1000
      restart: always
      networks:
        vpn:
          ipv4_address: 192.168.104.14
      volumes:
        - ./gitea:/data
        - /etc/timezone:/etc/timezone:ro
        - /etc/localtime:/etc/localtime:ro
    ################################################
    #                   mirotalk                   #
    ################################################   
    call.cloud:
        image: mirotalk
        volumes:
            - ./mirotalk/.env:/src/.env:ro
            - ./mirotalk/server.js:/src/app/src/server.js:ro
            - ./mirotalk/client.js:/src/public/js/client.js:ro
        restart: unless-stopped
        networks:
          vpn:
            ipv4_address: 192.168.104.6

    coturn.cloud:
      image: coturn/coturn
      restart: unless-stopped
      environment:
          - PUID=1000
          - PGID=1000
      volumes:
        - ./mirotalk-conf/turnserver.conf:/etc/turnserver.conf:ro
      networks:
        vpn:
          ipv4_address: 192.168.104.5

networks:
    vpn:
      ipam:
        config:
          - subnet: 192.168.104.0/28

    nextcloud-internal:
```
Let's go over each server and config one by one.

# wireguard

Is a server that allows us to have a secure VPN and to all our servers.

To add devices just modify `PEERS` environment variable by adding new device names, when doing so the run 

```sh
 docker-compose logs -f wireguard
```

You will find a QR code with configuration for all devices you wrote. If you want to add more devices or remove some, just edit the "PEERS" environment variable and check the logs again.

In order not to route all my traffic through VPN I modified my configuration to only include IPs I need.

```conf
AllowedIPs = 192.168.104.0/24, 10.13.13.0/24, ::/0
```
# Security
Everything is HTTP because it's under VPN and it's my VPN, so I don't want to worry about the SSL configuration.

## NOTE: make sure you don't expose any ports that might be accessible through the internet to avoid being HACKED 🕵🏻.

# DNS
In this configuration, you will not need a separate DNS as all DNS is handled by docker network once by the hostnames. For example, you can access nextcloud by typing `http://my.cloud` in your browser.


# nextcloud
`http://my.cloud`

Make sure to change MYSQL_PASSWORD and MYSQL_DATABASE. Access `http://phpmyadmin.cloud` to view the DB.
Now you can install every plugin that you can find on nextcloud plugin website.

# git server
`http://git.clud:3000` - server is running on port 3000.

Ever wanted to run your github or gitlab like application to store your source code? Gitea is a wonderful solution, as I run it alone or with my family it can be run without complicated SQL, in my case SQLite works just fine.


# mirotalk
`http://call.cloud`

You need to clone `mirotalk` https://github.com/miroslavpejic85/mirotalk to run this server.
This is a simple call application to do secure calls similar to Zoom or Google Meet. I was hosting Jitsy and other solutions that were hanging up the machine. If your server could support it I would put some nextcloud plugin.

My .env file.
```environment
PORT=443
NGROK_ENABLED=false
STUN=stun:coturn.cloud:3478
TURN_ENABLED=true
TURN_URLS=turn:coturn.cloud
TURN_USERNAME=username
TURN_PASSWORD=password
API_KEY_SECRET=mirotalk_super_duper__secret
SENTRY_ENABLED=false
SLACK_ENABLED=false
```

# Run your server be FREE
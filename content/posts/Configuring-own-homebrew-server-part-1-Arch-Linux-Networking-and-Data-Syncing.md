---
title: "Configuring own homebrew server - part 1: Arch Linux, Networking, and Data Syncing 🐧"
date: 2023-05-29T19:33:59+04:00
draft: false
---


After three long years of loyalty to CentOS, the time had finally come to shake things up and introduce Arch Linux to the server. Armed with determination and a USB cable, I faced the challenge of connecting my phone to the server, since I didn't have a LAN cable and monitor in the same location. An unconventional setup, indeed! 😅📱💻

Following this guide for installation for Arch Linux.
https://www.youtube.com/watch?v=G-mLyrHonvU

Encountered an issue, that was fixed here https://github.com/archlinux/archinstall/issues/1810#issuecomment-1545235595

After installation update the packages `pacman -Syy`.
install dependencies for our setup server `pacman -S openssh net-tools rsync git fish`

Add to the end of `visudo /etc/sudoers` to stop asking password for sudo every time.
```

```
Manual server network configuration

```sh
ip address add MY_STATIC_IP/255.255.255.0 dev enp4s0
ip route add default via MY_GATEWAY dev enp4s0
```

Automated
/etc/systemd/network/20-ethernet.network
```network
[Match]
Name=enp4s0

[Network]
Address=MY_STATIC_IP/24
Gateway=MY_GATEWAY
```
Where enp4s0 is the name of your network interface.

## SSH
Enable ssh service.
```sh
systemctl start sshd
systemctl enable sshd
```

Copying key to ssh to the server.
```sh
ssh-copy-id user@MY_SERVER_IP
```

Testing ssh connection.
```sh
ssh user@MY_SERVER_IP
```

As this server is accessible through internet I have disabled password on ssh part to improve security💾🔒✨ by adding to this file `/etc/ssh/sshd_config`

```sh
PasswordAuthentication no
```

Fish is the 🐠 coolest shell around! To make it the default shell for any user, simply run this command:

```
chsh -s $(which fish)
```

## disc and sync

In this concise guide, we'll explore a simple yet effective method for backing up your data using the power of rsync. By following the advice of [norayr](norar.am), we'll configure a backup solution that provides peace of mind without the complexity of RAID. I have 2 disc configuration for my data storage except for my OS drive. Let's get started and secure your precious data! 💪💾

Let's list all connected devices
```sh
lsblk -f
```

Output
```sh
NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                           
├─sda1 vfat   FAT32       C8B9-F37C                             451.9M    11% /boot
└─sda2 ext4   1.0         9aa35d6f-d7b8-446a-a070-5ca6e252aeb5  218.9G     1% /
sdb                                                                           
└─sdb1 xfs                a9ce21d2-a8f8-403a-a583-997aacb1f68f                
sdc                                                                           
└─sdc1 xfs                7ca56d73-fc0a-4fb1-a1d5-6816123fac4d                 
zram0                                                                         [SWAP]

```

In my case SDB and SDC are drives I want to "RAID". They are already formatted and are using xfs as their filesystem.

Creating directories for disks.
```sh
mkdir /disk0 && mkdir /disk1
```

Mounting disks to directories on startup by adding `nano /etc/fstab`
```
    UUID=a9ce21d2-a8f8-403a-a583-997aacb1f68f /disk1     xfs   defaults  0      0
    UUID=7ca56d73-fc0a-4fb1-a1d5-6816123fac4d /disk0     xfs   defaults  0      0
```

Reboot the system and make sure the disks are in place.

## sync
This is our GEM 💎, we will create a script that runs once a day syncing one disk to the other.  

First create sync scrypt.
`nano /root/bin/sync.sh`
```sh
#!/bin/bash

rsync -avh /disk0/ /disk1/ --delete-after > /tmp/cron.log 2>&1
```
Make it executable.
```sh
chmod +x /root/bin/sync.sh
```

#### systemd
Now we are going to create a systemd timer

Initially we need to create the service which will run our script.
`nano /etc/systemd/system/rsync.service`
```
[Unit]
Description=Rsync for synchronizing Disk0 with Disk1

[Service]
ExecStart=/root/bin/sync.sh
```

We need to create the timer to run once every day to sync our data by `nano /etc/systemd/system/rsync.timer`
```
[Unit]
Description=Rsync service timer

[Timer]
OnCalendar=daily
AccuracySec=12h

[Install]
WantedBy=timers.target
```

All logs for the script output can be fount at `/tmp/cron.log`.

Phew! 🥵 That was a ton of work, but I've finally got it all sorted out. Stay tuned for my upcoming blog post where I spill the beans on how I've set up my homemade server. 💪🏠😉
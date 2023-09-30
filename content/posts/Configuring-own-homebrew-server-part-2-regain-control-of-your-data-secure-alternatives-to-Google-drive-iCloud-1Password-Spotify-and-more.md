---
title: "Configuring own homebrew server - part 2: regain control of your data, secure alternatives to Google drive / iCloud, 1Password, Spotify and more ☁️🔒️"
date: 2023-09-30T08:18:45+04:00
draft: false
---
Many of us don't want to give our data to big companies because they sometimes accidentally or on purpose share it, invade our privacy, or let the governments snoop. As computer programs get smarter and ads get creepier, it feels like companies are watching us.👁️(Actually they do.😢) 

Some people want to be in charge of their own data again so let's explore an option.

![cat in a hat](/images/homebrew-server/cat.jpg)

## What is nextcloud? ☁️

Nextcloud is an open-source platform that lets you create your own private and secure cloud storage and collaboration system, giving you control over your data and enabling features like file storage, sharing, and collaboration, similar to popular commercial cloud services. It supports functionalities similar to Google Drive and iCloud.

https://nextcloud.com/

### Password manager like 1password? 🔑
[Remember the Lastpass leak?](
https://www.wired.com/story/lastpass-engineer-breach-security-roundup/) 

Why trust password management companies with your passwords? It's like paying a stranger to be your personal locksmith – you never know when they might accidentally(or not) leave your digital front door wide open!

Passman nextcloud is an open-source plugin allows creating encrypted secure vaults and storing your passwords encrypted in a secure vault on your server. It has Android(can be found on fDroid), iOS, as well as browser extensions.

https://apps.nextcloud.com/apps/passman

### Audio straming like spotify? 🎵

While you can inherit your CD, phone, computer or a book, you cannot inherit a Spotify subscription.

Some of us prefer not to pay for audio streaming subscriptions because we find the cost to be high or accumulative overtime, and we don't like the idea of not actually owning the media we paid for.

With alternatives like Nextclouds' Audio plugin for hosting and streaming content and buying books/music directly for example from [audiobookstore.com](https://audiobookstore.com/), we can have more control over their digital library and costs. The plugin supports Subsonic and Ultrasonic protocols which has a lot of open source clients.

https://apps.nextcloud.com/apps/music


These were my peaks that I use daily.

# What is wireguard? 🐉

WireGuard is a modern and secure open-source VPN (Virtual Private Network) known for its simplicity to setup and efficiency and security. It's designed to establish secure communication channels between devices or networks over the internet like your phone, laptop and the server.

If you have a Nextcloud server or any other service you want to access securely over the internet, using a VPN like WireGuard is a good practice. It helps ensure that your data is transmitted safely, and it adds an extra layer of protection by allowing you to access your services through a private network, rather than leaving them open to the entire internet and welcome for hackers. 🕵🏻

### Final thoughts
This is the very config I use daily. Take control of your data and privacy. Your data, your rules! 🌐🔐 

Make sure to checkout more nextcloud plugins and functionalities.
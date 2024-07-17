---
title: "Creating a Complete Open Source Software Challenge in 48 Hours Microsoftr👨🏻‍💻"
date: 2024-07-17T17:55:58+04:00
draft: false
---

It's bad timing, I need more time, but I need a deadline to make sure that I follow the deadline.

The idea is:
Inspired by softr․io which is a site builder using Airtable spreadsheets as a database, I want to create an open-source solution, that will use Google spreadsheets as a database and provide users with a simple API to fetch data. The spreadsheet is read-only, at least for now.

# I will call it micro+softr=microsoftr

The system should be able to fetch data from different sheets inside a spreadsheet, it should be wrapped in a docker and be composable with docker-compose, and it should have a caching mechanism so it will meet Google spreadsheet api limits https://developers.google.com/sheets/api/limits . 

# The code will be published on github under GPL license, let the challenge begin.
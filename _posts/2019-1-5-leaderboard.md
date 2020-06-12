---
layout: post
title: "Leaderboard"
permalink: /leaderboard/
---
We ran a Data Science Hackathon as a Kaggle competition and I thought it would be fun to produce a "bar chart race" to track the leaderboard struggles in real time, as opposed to just seeing who had won at the end.
<!--more-->

Kaggle allows you to download the current leaderboard using their API. Then, I found a very nice free visualization on [Flourish](https://app.flourish.studio/@flourish/bar-chart-race), but it is prohibitively expensive if you want to use their API to upload data the programmatically. Using Selenium, I was able to automate this. Using this script you can take a "photo" of the leaderboard and update your bar code race periodically.

![leaderboard](https://github.com/teticio/leaderboard/blob/master/Global%20Wheat%20Detection%20-%20Kaggle%20competition.png?raw=true)

You can find the script and details on how to use it [here](https://github.com/teticio/leaderboard).

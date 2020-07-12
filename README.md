# TwitterToTelegram
-------------
- Configurations file
Here, you just have to change filling with your personal settings

- Crontab file
In order to check any minute if there is some update on monitored twitter accounts, you can insert a crontab file in your machine
In the example bellow, we made a git clone in /opt/ directory
```
* * * * * cd /opt/TwitterToTelegram;./tweet.sh
```
-------------
TODO:

1 - Ignore pinned tweets in order to trully return last tweet

2 - Do integration with existent bot to allow insert automatticaly a twitter account to monitor

# TwitterToTelegram
-------------
- In "Configurations" file, you just have to change filling with your personal settings
- Inside tweet.sh, pay attention to change value from listTwitterUsersToCheck variable, because there is where you have to fill which twitter users you will grab.
- Create a Crontab file
In order to check any minute if there is some update on monitored twitter accounts, you can insert a crontab file in your machine
In the example bellow, we had made a git clone in /opt/ directory
```
* * * * * cd /opt/TwitterToTelegram;./tweet.sh
```
-------------
TODO:

1 - Ignore pinned tweets in order to trully return last tweet

2 - Do integration with existent telegram bot to allow insert automatically a twitter account to monitor

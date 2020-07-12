# TwitterToTelegram
-------------
## Starting
- In "Configurations" file, you just have to change filling with your personal settings
- Inside tweet.sh, pay attention to change value from listTwitterUsersToCheck variable, because there is where you have to fill which twitter users you will grab.
  - You can get your apiTokenTelegram for your current Telegram Bot calling the user @BotFather on Telegram and clicking on start button. 
  - Your ChatID can be easily visible following this steps: https://youtu.be/I-qI6jeLIsI?t=83
- Create a Crontab file
In order to check any minute if there is some update on monitored twitter accounts, you can insert a crontab file in your machine
In the example bellow, we had made a git clone in /opt/ directory
```
* * * * * cd /opt/TwitterToTelegram;./tweet.sh
```
-------------
## TODO:

1 - Ignore pinned tweets in order to trully return last tweet

2 - Do an integration with existents telegram bots to allow insert automatically a twitter account to monitor from telegram

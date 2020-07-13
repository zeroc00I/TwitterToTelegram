# TwitterToTelegram
-------------
## Starting
- In "Configurations" file, you just have to change filling with your personal settings
- Inside tweet.sh, pay attention to change value from listTwitterUsersToCheck variable, because there is where you have to fill which twitter users you will grab.
  - You can create your own apiTokenTelegram for your Telegram Bot calling the user @BotFather on Telegram and clicking on start button. 
  - Your ChatID can be easily visible following this steps: https://youtu.be/I-qI6jeLIsI?t=83
- Create a Crontab file
In order to check any minute if there is some update on monitored twitter accounts. 
You can insert a crontab file in your machine
In the example bellow (We had made a git clone in /opt/ directory)
```
* * * * * cd /opt/TwitterToTelegram;./tweet.sh
```

## Running Example 
-------------
Now your telegram chat group can comment with you all about some tweet made by your monitored users \o/

![alt text](https://github.com/bminossi/TwitterToTelegram/blob/master/examples/working.png?raw=true)

-------------
## TODO:
1 - Ignore utf8 characters, such as "â". 
We're having problems with Telegram Api after the url encode proccess %e2
Should be %C3%A3

2 - Ignore pinned tweets in order to trully return last tweet

3 - Do an integration with existents telegram bots to allow insert automatically a twitter account to monitor from telegram

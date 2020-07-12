#!/bin/bash

listTwitterUsersToCheck=("CyberResenha" "avanish46")

function dependencies() {
  #Check jq | html2text
  if [ ! -f "$userToCheck" ]; then
    touch $userToCheck
  fi
  ConfirmIfallParamsAreFilled=$(cat configurations | cut -d "=" -f2 | sed '/^$/d' | wc -l)
  if [[ "$ConfirmIfallParamsAreFilled" -eq 3 ]] ; then
    source configurations
    else
    echo "You didnt fill the configuration file or you've deleted him, so you have to recreate";
  fi
}

function fetchLastTwoTweetsFromUserMonitored() {
  resultOfFetch=$(
    curl -s \
      -H "X-Requested-With:XMLHttpRequest" \
      -H "X-Twitter-Active-User:yes;User-Agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.8" \
      "https://twitter.com/i/profiles/show/$userToCheck/timeline/tweets?include_available_features=1&include_entities=1&include_new_items_bar=true"
  )

  preparingJsonToReadable=$(echo $resultOfFetch | grep -o '{"min_position":.*')
  lastTwoTweetsFetched=$(
    echo -e $preparingJsonToReadable | grep -m2 "data-aria-label-part...0.*" |
      # Removing unnecessary escapes
      tr -d "\\" 2>/dev/null |
      # removing html tags
      html2text |
      # Fixing images url
      sed 's#pic.twitter# http://pic.twitter#g'
  )
    someNewToSendByTelegram $lastTwoTweetsFetched
}

function someNewToSendByTelegram() {
  lastTwoTweetsStoredMd5=($(cat $userToCheck))
  lastTwoTweetsFetchedMd5=($(echo $lastTwoTweetsFetched | md5sum))

  if [ "$lastTwoTweetsStoredMd5" == "$lastTwoTweetsFetchedMd5" ];then
    echo "Nothing new to $userToCheck"
    return
    fi
    echo "There are some news to $userToCheck [$lastTwoTweetsStoredMd5/$lastTwoTweetsFetchedMd5]! Logging and Sending to telegram channel"
    updatingLastTweetsFromUser $lastTwoTweetsFetchedMd5
    sendNewsToTelegramChannel $lastTwoTweetsFetched
}

function updatingLastTweetsFromUser(){
  echo $lastTwoTweetsFetchedMd5 > $userToCheck
}

function sendNewsToTelegramChannel(){
  echo "Function to send news to telegram channel"
  encodedNewTweetUpdate=$(urlencode $lastTwoTweetsFetched)
  telegramUrlToSendContent=$apiUrlTelegram"sendmessage?chat_id="$chatID"&text="$encodedNewTweetUpdate;
  echo "Fazendo curl para [$telegramUrlToSendContent]"
	curl -s $telegramUrlToSendContent;
}

function urlencode(){
  local string="$lastTwoTweetsFetched"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:${pos}:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
  #REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

function main() {
  dependencies $userToCheck
  fetchLastTwoTweetsFromUserMonitored $userToCheck
}

for userToCheck in "${listTwitterUsersToCheck[@]}"; do
  main $userToCheck
done

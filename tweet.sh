#!/bin/bash

listTwitterUsersToCheck=("CyberResenha" "CVEnew")
components=("jq" "html2text")

function dependencies() {

  for component in "${components[@]}"; do
    command -v $component >/dev/null 2>&1
    if [ "$?" -eq 1 ]; then
      echo -e "[Check Dependencies Failed]\nConsider to sudo apt install $component"
      exit
    fi
  done

  if [ ! -f "$userToCheck" ]; then
    touch $userToCheck
  fi

  ConfirmIfallParamsAreFilled=$(cat configurations | cut -d "=" -f2 | sed '/^$/d' | wc -l)

  if [[ "$ConfirmIfallParamsAreFilled" -eq 3 ]]; then
    source configurations
  else
    echo "You didnt fill the configuration file or you've deleted it, so you have to recreate it"
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
    for i in {2..3}; do
      echo -e "$preparingJsonToReadable" |
        tr -d "\n\\" 2>/dev/null |
        awk -F'<div class=\"js-tweet-text-container\">' "{print \$$i}" |
        awk -F'</div>' '{print $1}'
    done
  )
  lastTwoTweetsFetched=$(
    echo -e $lastTwoTweetsFetched |
      # Fixing images url
      sed 's#pic.twitter# http://pic.twitter#g' |
      html2text
  )
  someNewToSendByTelegram $lastTwoTweetsFetched
}

function someNewToSendByTelegram() {
  lastTwoTweetsStoredMd5=($(cat $userToCheck))
  lastTwoTweetsFetchedMd5=($(echo $lastTwoTweetsFetched | md5sum))

  if [ "$lastTwoTweetsStoredMd5" == "$lastTwoTweetsFetchedMd5" ]; then
    echo "Nothing new to $userToCheck"
    return
  fi
  echo "There are some news to $userToCheck [$lastTwoTweetsStoredMd5/$lastTwoTweetsFetchedMd5]! Logging and Sending to telegram channel"
  updatingLastTweetsFromUser $lastTwoTweetsFetchedMd5
  sendNewsToTelegramChannel $lastTwoTweetsFetched
}

function updatingLastTweetsFromUser() {
  echo $lastTwoTweetsFetchedMd5 >$userToCheck
}

function sendNewsToTelegramChannel() {
  echo "Function to send news to telegram channel"
  encodedNewTweetUpdate=$(urlencode $lastTwoTweetsFetched)
  telegramUrlToSendContent=$apiUrlTelegram"sendmessage?chat_id="$chatID"&text=%5B%40$userToCheck%5D"$encodedNewTweetUpdate
  echo "Fazendo curl para [$telegramUrlToSendContent]"
  curl -s $telegramUrlToSendContent
}

function urlencode() {
  local LC_ALL=C
  local string="$lastTwoTweetsFetched"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for ((pos = 0; pos < strlen; pos++)); do
    c=${string:${pos}:1}
    case "$c" in
    [-_.~a-zA-Z0-9]) o="${c}" ;;
    *) printf -v o '%%%02x' "'$c" ;;
    esac
    encoded+="${o}"
  done
  echo "${encoded}" # You can either set a return variable (FASTER)
}

function main() {
  dependencies $userToCheck
  fetchLastTwoTweetsFromUserMonitored $userToCheck
}

for userToCheck in "${listTwitterUsersToCheck[@]}"; do
  main $userToCheck
done

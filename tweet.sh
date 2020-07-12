#!/bin/bash
if [ ! -f "" ];then
touch lastMonitTwitter
fi
monitoredTwitterUser="HusseiN98D"

result=`
curl -s -H "X-Requested-With:XMLHttpRequest" -H "X-Twitter-Active-User:yes;User-Agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.8" "https://twitter.com/i/profiles/show/$monitoredTwitterUser/timeline/tweets?include_available_features=1&include_entities=1&include_new_items_bar=true" 
`
jq=`echo $result | grep -o '{"min_position":.*'`

#totalPosts=`echo "$jq" | jq .new_latent_count`
echo $totalPosts
echo -e "Ultimo post feito:"
echo -e $jq | grep -v "Pinned" | grep -m1 "data-aria-label-part...0.*" | tr -d "\\" 2>/dev/null | html2text 


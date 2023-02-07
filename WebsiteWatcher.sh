#To run this script periodicly create a cron job by running "crontab -e" and inserting the line "#*/10 * * * * WebsiteWatcher.sh" to run every 10 minutes

#create bot on Telegram app by chatting with @BotFather
#curl https://api.telegram.org/bot{TOKEN}/getUpdates
#get chat_id
#curl -X POST -H 'Content-Type: application/json' -d '{"chat_id": "{CHAT_ID},", "text": "$link was updated!", "disable_notification": false}'      https://api.telegram.org/bot{TOKEN}/sendMessage
#to send message

send_mesage_to_telegram()
{
  cat <<EOF
curl -X POST -H 'Content-Type: application/json' -d '{"chat_id": "{CHAT_ID},", "text": "$link was updated!", "disable_notification": false}' https://api.telegram.org/bot{TOKEN}/sendMessage
EOF
}

foldername="WebsiteWatcher3"
link="{LINK}"

#check internet connection
if ! ping -c 1 -W 1 1.1.1.1; then
	exit
fi

#create folder if not present
if ! ls /tmp/$foldername; then
	mkdir /tmp/$foldername
fi

#create a copy of the website to compare to (first run)
if ! ls /tmp/$foldername/old.html; then
	curl -s -k $link -o /tmp/$foldername/old.html
	exit
fi

#send message if new version is different from old one and move the new one to be the new old one
curl -s -k $link -o /tmp/$foldername/new.html
if ! cmp -s /tmp/$foldername/old.html /tmp/$foldername/new.html; then
	echo "was updated!"
	eval "$(send_mesage_to_telegram)"
else
	echo "no changes"
fi
mv /tmp/$foldername/new.html /tmp/$foldername/old.html

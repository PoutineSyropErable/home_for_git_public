#!/bin/bash


current_dir="$HOME/BatteryInfo"
notification_sound="scifi-reject-notification.wav"


notification_dir="$current_dir/NotificationFiles"



send_notification() {
	urgency=$1
	message=$2
	paplay "$current_dir/$notification_sound" &
	notify-send -u "$urgency" "Battery Status" "$message" 
}




percentage=69
send_notification "critical" "Battery is very low at ${percentage}%!"
